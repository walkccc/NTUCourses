function H = histEq(I)
    disp('Doing Histogram Equalization');
    % usage: doHistogram Equalization on image I, then return the result as H
    
    [h, w] = size(I);
    L = 256;                    % L: number of gray levels in the image
    H = zeros(h, w);            % initialize the histogram equalization image
    prob = zeros(256, 1);       % prob: the occurrence of each pixel val
        
    % Calculate the prob in [0: 255]
    for i = 1: h * w
        val = I(i);
        prob(val + 1) = prob(val + 1) + 1;
    end

    cdf = zeros(256, 1);        % cdf: cumulative distribution function
    sum = 0;                    % sum: cumulative occurrence

    % Calculate the cdf in [0: 255]
    for i = 1: 256
        sum = sum + prob(i);
        cdf(i) = sum;
    end
    
    % Get the histogram equalization image
    for i = 1: h * w
        H(i) = round((cdf(I(i) + 1) - min(cdf)) / (h * w - min(cdf)) * (L - 1));
    end
    
    H = uint8(H);
end