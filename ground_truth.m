
[camera(1).K, camera(1).R, camera(1).T] = readKRT('0005.png.camera');
[camera(2).K, camera(2).R, camera(2).T] = readKRT('0007.png.camera');

Rrel = camera(1).R'*camera(2).R;
Trel =  camera(1).R'*(camera(2).T - camera(1).T);

P = camera(1).K*[Rrel' -Rrel'*Trel];

points = BackgroundPointCloudRGB(1:3, :);

points = [points; ones(1, size(points, 2))];

x = P * points;

x = x ./ [x(3,:);x(3,:);x(3,:)];

x = floor(x);

image = zeros(2048, 3072);

for ii = 1 : size(points, 2)
    if (x(2, ii) > 0 && x(1, ii) > 0 && x(2, ii) <= 2048&& x(1, ii) <= 3072)
        image(x(2, ii), x(1, ii)) = points(3, ii) - camera(2).T(3);
    end
end