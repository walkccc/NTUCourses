function LT = logTrans(I, c)
    fprintf('Doing Log Transformation, c = %d\n', c);
    [h, w] = size(I);
    LT = zeros([h w]);
    % c = (256 - 1) / log(L);
    
    I = double(I);
    LT = c * log(I + 1);
    LT = uint8(LT);
end