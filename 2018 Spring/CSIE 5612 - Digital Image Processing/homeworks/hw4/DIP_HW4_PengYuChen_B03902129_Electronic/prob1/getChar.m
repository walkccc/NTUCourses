function C = getChar(I, intensity, NORM_h, NORM_w)
    [h, w] = size(I);
    top = h; left = w; right = 1; bot = 1;

    for i = 1: h
        for j = 1: w
            if I(i, j) == intensity
                if j < left left = j; end
                if j > right right = j; end
                if i < top top = i; end
                if i > bot bot = i; end
            end
        end
    end
    
    % Crop the character
    C = I(top: bot, left: right);
    [h, w] = size(C);
    
%     if h > w
%         pad_width = round((h - w) / 2 - 0.1);
%         C = [zeros(h, pad_width) C zeros(h, pad_width)];
%     end        
%     [h, w] = size(C);
    
    O = zeros(NORM_h, NORM_w);
    for i = 1: NORM_h
        for j = 1: NORM_w
            O(i, j) = C(uint8(round(i * h / NORM_h + 0.49)), uint8(round(j * w / NORM_w + 0.49)));
        end
    end
    C = O;
    
end