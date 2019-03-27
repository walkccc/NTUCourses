function Dilated = dilate(I, SIZE)
    fprintf('Performing Dilation with size = %d\n', SIZE);
    [h, w] = size(I);
    Dilated = zeros(h, w);
    p = (SIZE - 1) / 2;
    
    for i = 1 + p: h - p
        for j = 1 + p: w - p
            Dilated(i - p: i + p, j - p: j + p) = I(i, j);
%             for k = i - p: i + p
%                 for l = j - p: j + p
%                     Dilated(i, j) = I(i, j);
%                 end
%             end
        end
    end
    
    Dilated = uint8(Dilated);
end