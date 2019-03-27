function RS = crossMedianFilter(I, n)       % n: cross size of mask
    [h, w] = size(I);
    RS = zeros(h, w);
   
    % pad the array I to P
    p = (n - 1) / 2;                                  
    P = padarray(I, [p p], 'replicate', 'both');

    % For each entry in P
    for i = 1 + p: h + p
        for j = 1 + p: w + p
            mat = [P(i - p: i + p, j)', P(i, j - p: j - 1), P(i, j + 1: j + p)];
            mat = reshape(mat, [1, 2 * n - 1]);
            RS(i - p, j - p) = median(mat);
        end
    end
    
    RS = uint8(RS);
end