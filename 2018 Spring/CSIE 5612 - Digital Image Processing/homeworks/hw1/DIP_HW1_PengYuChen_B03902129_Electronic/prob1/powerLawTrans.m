function PL = powerLawTrans(I, p)
    fprintf('Doing Power-Law Transformation, p = %d\n', p)
    [h, w] = size(I);
    PL = zeros([h w]);
    
    % Power-Law Transformation
    % For gamma <= 1: brighter image
    % For gamma > 1: darker image
    % Computing PL = c * I^p
    I = double(I);
    PL = I .^ p;
    PL = uint8(PL);
end