function PSNR = PSNR(I1, I2)
    [h, w] = size(I1);
    I1 = double(I1);
    I2 = double(I2);
    MSE = sum(sum(I1 - I2)).^2 / (h * w);
    PSNR =  10 * log10(255 ^ 2 / MSE);
end