camera = struct('Image', {}, ...
                'K', {}, ...
                'R', {}, ...
                'T', {} ...
                );
winsize = 5;
[camera(1).K, camera(1).R, camera(1).T] = readKRT('0005.png.camera');
[camera(2).K, camera(2).R, camera(2).T] = readKRT('0006.png.camera');
[camera(3).K, camera(3).R, camera(3).T] = readKRT('0004.png.camera');

[Kref, Rref, Tref] = readKRT('0004.png.camera');
Rrelref = Rref' * camera(1).R;
Trelref = Rref' * (camera(1).T - Tref);

Rrel(:,:,1) = camera(2).R'*camera(1).R;
Trel(:,:,1) =  camera(2).R'*(camera(1).T - camera(2).T);

Rrel(:,:,2) = camera(3).R'*camera(1).R;
Trel(:,:,2) =  camera(3).R'*(camera(1).T - camera(3).T);

camera(1).Image = 255 * im2double(rgb2gray(imread('0005.png')));
camera(2).Image = 255 * im2double(rgb2gray(imread('0006.png')));
camera(3).Image = 255 * im2double(rgb2gray(imread('0004.png')));
g = gpuArray(ones(winsize,1) ./ winsize);
ref = camera(1).Image;
[meanref, stdref] = calNcc(ref, winsize);
[ydim, xdim] = size(camera(1).Image);
depthmap = zeros(ydim, xdim);
bestncc = depthmap;

depth = 4:0.01:10;
depthmap = bsxfun(@plus, depthmap, depth(1));

n = gpuArray([0 0 1]');
% n = Rrelref' * n + Trelref;

[depthmap, bestncc] = cal_depth(depthmap, bestncc, camera, 2, Rrel(:,:,1), Trel(:,:,1), winsize, meanref, stdref, 0, depth, n);
[depthmap, bestncc] = cal_depth(depthmap, bestncc, camera, 3, Rrel(:,:,2), Trel(:,:,2), winsize, meanref, stdref, 0, depth, n);

denoised = denoiseTVL1(depthmap, camera(1).Image, 0.3, 100, depth(end), depth(1));

% err_depthmap = cal_err(ground, depthmap);
% err_denoised = cal_err(ground, denoised);


