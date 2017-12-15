function err = cal_err(ground, img)
    true = bsxfun(@gt, ground, 0);
    img = bsxfun(@times, img, true);
    err = img - ground;
    err = abs(err);
end