function depthmap = generate()
    load('data.mat');
    point = BackgroundPointCloudRGB(1:3,:);
    [K, R, T] = readKRT('E:\repo\cs532final\plane-sweep-master\plane_sweep\0005.png.camera');
    P = K * [eye(3) [0 0 0]'];
    depthmap = zeros(2048, 3072);
    point = [point; ones(1, size(point, 2))];
    for ii = 1:size(point, 2)
        xy2 = P * point(:, ii);
        xy2 = xy2./xy2(3);
        xy2 = round(xy2);
        if (xy2(1) > 0 && xy2(2) > 0 && xy2(2) <= 2048 && xy2(1) <= 3072)
            if (depthmap(xy2(2), xy2(1)) == 0 || depthmap(xy2(2), xy2(1)) > point(3, ii))
                depthmap(xy2(2), xy2(1)) = point(3, ii);
            end
        end
    end
end