function [E, Gx, Gy, G] = edgeDetectFirst(I, points, T, k)
    I = double(I);
    [h, w] = size(I);
    E = zeros(h, w);
    Gx = zeros(h, w);
    Gy = zeros(h, w);

    p = 1;
    I = padarray(I, [p p], 0, 'both');
    
    for i = p + 1: p + h
        for j = p + 1: p + w
            switch points
                case 3                  % Approximation I - 3 points
                    Gx(i - p, j - p) = I(i, j) - I(i, j - 1);
                    Gy(i - p, j - p) = I(i, j) - I(i + 1, j);

                case 4                  % Approximation II - 4 points
                    Gx(i - p, j - p) = I(i, j) - I(i + 1, j + 1);
                    Gy(i - p, j - p) = I(i, j + 1) - I(i + 1, j);

                case 9                  % Approximation III - 4 points
                    A0 = I(i - 1, j - 1);
                    A1 = I(i - 1, j);
                    A2 = I(i - 1, j + 1);
                    A3 = I(i, j + 1);
                    A4 = I(i + 1, j + 1);
                    A5 = I(i + 1, j);
                    A6 = I(i + 1, j - 1);
                    A7 = I(i, j - 1);

                    % k = 1: Prewitt Mask
                    % k = 2: Sobel Mask
                    Gx(i - p, j - p) = ((A2 + k * A3 + A4) - (A0 + k * A7 + A6)) / (k + 2);
                    Gy(i - p, j - p) = ((A0 + k * A1 + A2) - (A6 + k * A5 + A4)) / (k + 2);
            end
        end
    end
    G = sqrt(Gx.^2 + Gy.^2);
    
    for i = 1: h
        for j = 1: w
            if G(i, j) > T
                E(i, j) = 255;
            end
        end
    end
    E = uint8(E);
        
end