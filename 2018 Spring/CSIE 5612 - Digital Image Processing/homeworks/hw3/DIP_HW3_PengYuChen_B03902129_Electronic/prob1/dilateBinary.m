function Dilated = dilateBinary(I, SIZE)
    fprintf('Performing Binary Dilation\n');
    [h, w] = size(I);
    Dilated = zeros(h, w);
    
    for i = 1: h
        for j = 1: w
            if I(i, j) == 255
                for k = 1: SIZE
                    for l = 1: SIZE
                        Dilated(i + k, j + l) = 1;
                    end
                end
            end
        end
    end
end