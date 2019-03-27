function Dilated = dilate(I, SIZE)
    fprintf('Performing Dilation with size = %d\n', SIZE);
    [h, w] = size(I);
    Dilated = zeros(h + SIZE * 2, w + SIZE * 2);
        
    for i = 1: h
        for j = 1: w
            if I(i, j) == 255
                for win_i = i: i + 2
                    for win_j = j: j + 2
                        Dilated(win_i, win_j) = 255;
                    end
                end
            end
        end
    end
    
    Dilated = uint8(Dilated(2: h + 1, 2: w + 1));
end