function L = localhist(I, n)
    fprintf('Doing Local Histogram Equalization, window size = %d\n', n);
    % usage: Do Local Histogram Equalization on image I, then output the result as L
    % n: window size
    
    [h, w] = size(I);
    levels = 256;                           % levels: num of gray levels in the image
    L = zeros(h, w);                        % initialize the local histogram equalization image
    p = (n - 1) / 2;                        % p: padding size of 0s
    P = padarray(I, [p p], 0, 'both');      % pad 0s to I
    
    % For each entry in P
    for i = 1 + p: h + p
        for j = 1 + p: w + p
            prob = zeros(256, 1);           % prob: the occurrence of each pixel val
            mat = P(i - p: i + p, j - p: j + p);
            
            % Calculate the prob in [0: 255] for each n * n matrix
            for k = 1: n * n
                prob(mat(k) + 1) = prob(mat(k) + 1) + 1;
            end
            
            cdf = zeros(256, 1);            % cdf: cumulative distribution function
            out = zeros(256, 1);            % out: the output val of a pixel level.
            sum = 0;                        % sum: cumulative occurrence
            
            % Calculate the cdf in [0: 255] for each n * n matrix
            for k = 1: 256
                sum = sum + prob(k);
                cdf(k) = sum;
            end
            
            % Relation: i [1: 256] -> output(i)
            for k = 1: 256
                out(k) = round(((cdf(k) - min(cdf)) / (n * n - 1)) * (levels - 1));
            end
            
            L(i - p, j - p) = out(P(i, j) + 1);
        end
    end

    L = uint8(L);
end