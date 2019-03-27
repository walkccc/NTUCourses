function W = warping(I)
    I = double(I);
    [h, w] = size(I);    
    W = zeros(h, w);

    for i = 1: h
        for j = 1: w
            x = i + 20 * sin((j - 10) / 24);    % OK now
            y = j + 18 * sin((i + 40) / 40);
            if x > 512 || x < 1 || y > 512 || y < 1
                continue
            end
            W(i, j) = I(uint16(x), uint16(y));
        end
    end
       
    W = uint8(W);
%     imwrite(W, './myOutputs/D.png');
end