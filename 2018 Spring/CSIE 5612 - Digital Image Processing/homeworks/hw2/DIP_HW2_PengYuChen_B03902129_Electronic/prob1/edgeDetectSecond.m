function E = edgeDetectSecond(I, nNeighbor, T)
    I = double(I);
    [h, w] = size(I);
    E = zeros(h, w);
    G = zeros(h, w);

    p = 1;
    I = padarray(I, [p p], 0, 'both');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2nd Order Edge Detection %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    switch nNeighbor
        case 4 
            mask = 1 / 4 * [0, 1, 0; 1, -4, 1; 0, 1, 0];    
        case 8 
            mask = 1 / 8 * [-1, -1, -1; 2, 2, 2; -1, -1, -1];
    end
    
    for i = p + 1: p + h
        for j = p + 1: p + w
            mat = I(i - p: i + p, j - p: j + p);
            G(i - p, j - p) = sum(sum(mat .* mask));    
        end
    end
    
    %%%%%%%%%%%%%%%%%
    % Zero-crossing %
    %%%%%%%%%%%%%%%%%
    
    % Step 1: Generate the histogram of G
    % Step 2: Set up a threshold to separate zero and non-zero to get E
    
    for i = 1: h
        for j = 1: w
            if G(i, j) > T
                E(i, j) = 255;
            else
                E(i, j) = 0;
            end
        end
    end
    
    % Step 3: For E(i, j) = 0, decide whether (i, j) is a zero-crossing point
    
    for i = 2: h - 1
        for j = 2: w - 1
            if E(i, j) == 255
                if G(i, j - 1) * G(i, j + 1) < 0 || G(i + 1, j - 1) * G(i - 1, j + 1) < 0 || G(i - 1, j) * G(i + 1, j) < 0 || G(i - 1, j - 1) * G(i + 1, j + 1) < 0
                    E(i, j) = 255;
                end
            end
        end
    end
    E = uint8(E);
       
end