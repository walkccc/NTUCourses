function ILT = invLogTrans(I, c)
    fprintf('Doing Inverse Log Transformation, c = %d\n', c);
    [h, w] = size(I);
    ILT = zeros([h w]);
    % c = (256 - 1) / log(L);

    I = double(I);
    ILT = exp(I) .^ (1 / c) - 1;
    ILT = uint8(ILT);
end