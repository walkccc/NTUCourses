function S = shift(I)
    [h, w] = size(I);
    S = zeros(h, w);
    for i = 1: h
        for j = 1: w
            if I(i, j) == 255 && j + 1 <= w
                S(i, j + 1) = 255;
            end
        end
    end
end