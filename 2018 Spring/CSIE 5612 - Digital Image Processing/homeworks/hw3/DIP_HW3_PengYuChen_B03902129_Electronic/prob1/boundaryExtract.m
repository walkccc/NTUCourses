function [B, FH] = boundaryExtract(F)
    fprintf('Doing Boundary Extraction\n');
    [h, w] = size(F);
    FH = zeros(h, w);
    B = zeros(h, w);
    p = 1;
    
    for i = 2: h - 1
        for j = 2: w - 1
            mat = F(i - p: i + p, j - p: j + p);
            isMatch = 1;
            for k = 1: 3 * 3
                if mat(k) == 0
                    isMatch = 0;
                    break
                end
            end
            if isMatch
                FH(i, j) = 255;
            end
        end
    end
    
    for i = 1: h
        for j = 1: w
            B(i, j) = F(i, j) - FH(i, j);
        end
    end
    
    B = uint8(B);
end