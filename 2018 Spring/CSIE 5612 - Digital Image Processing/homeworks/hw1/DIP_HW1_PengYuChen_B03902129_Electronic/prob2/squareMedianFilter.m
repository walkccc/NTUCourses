function RS = squareMedianFilter(I, n)      % n: window size of the mask
    [h, w] = size(I);
    RS = zeros(h, w);
    
    % pad the array I to P
    p = (n - 1) / 2;
    P = padarray(I, [p p], 'replicate', 'both');

    % For each entry in P
    for i = 1 + p: h + p
        for j = 1 + p: w + p
            mat = P(i - p: i + p, j - p: j + p);
            mat = reshape(mat, [1, n * n]);
            RS(i - p, j - p) = median(mat);
        end
    end
    
    RS = uint8(RS);
end