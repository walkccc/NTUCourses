function B = binary(I)
    [h, w] = size(I);
    B = zeros(h, w);
    for i = 1: h
        for j = 1: w
            if I(i, j) > 128
                B(i, j) = 0;
            else
                B(i, j) = 1;
            end
        end
    end
end