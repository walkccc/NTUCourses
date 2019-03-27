function K = findTextures(T1, T2)
    [h, w] = size(T1);
    K = zeros(h, w);
    
    % Thresholding
    for i = 1: h
        for j = 1: w
            if T1(i,j) == 13520
                K(i, j) = 200;
            end
            if T1(i, j) > 20000 && T2(i, j) > 3500
                K(i, j) = 100;
            end
        end
    end    
    K = uint8(K);
end