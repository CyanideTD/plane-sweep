function[mean, std] = calNcc(img, winsize)
    g = gpuArray(ones(winsize,1) ./ winsize); 
    mean = colfilter(colfilter(img,g).',g).';
    sqr = img .* img;
    meansqr = colfilter(colfilter(sqr,g).',g).';
    var = meansqr - mean .* mean;
    positive = bsxfun(@gt, var, 0);
    std = sqrt(positive .* var);
end