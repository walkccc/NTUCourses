function S = addSaltAndPepper(I, t)
    [h, w] = size(I);
    S = zeros(size(h, w));
    for i = 1: h
        for j = 1: w            
            seed = rand();
            if seed < t
                S(i, j) = 0;
            elseif seed  > 1 - t
                S(i, j) = 255;
            else
                S(i, j) = I(i, j);
            end
        end
    end
    S = uint8(S);
end