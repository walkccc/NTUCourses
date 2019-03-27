function RG = lowPassFilter(I, b)
    I = double(I);
    [h, w] = size(I);
    
    % Initialize resultant image and padding image
    RG = zeros(h, w);                               % initialize the resultant images
    P = padarray(I, [1 1], 'replicate', 'both');    % pad around the image I
    pad = 1;                                        % assume mask size = 3 x 3
    
    % 3 x 3 mask
    mask = 1 / (b + 2)^2 * [1, b, 1; b, b^2, b; 1, b, 1];
    
    % Perform low-pass filtering
    for i = 1 + pad: h + pad
        for j = 1 + pad: w + pad
            mat = P(i - pad: i + pad, j - pad: j + pad);
            RG(i - pad, j - pad) = sum(sum(mat .* mask));
        end
    end
    

    RG = uint8(RG);
end