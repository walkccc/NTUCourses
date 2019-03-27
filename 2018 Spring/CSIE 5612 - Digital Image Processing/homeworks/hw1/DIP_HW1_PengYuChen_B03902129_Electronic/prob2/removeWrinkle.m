function face = removeWrinkle(I)
    face = I;
    binary = I(:, :, 1) < 128;          % Convert image to binary mask
    de = strel('disk', 3, 0);           % Define a disk element   
    halfThick = imerode(binary, de);    % Chop half thickness from mask
    dilate = imdilate(halfThick, de);   % Dilate the eroded mask
    invalidArea = binary & ~dilate;
    threshold = 3;
   
    for i = 1: 256
        for j = 1: 256
            if (invalidArea(i, j) == 1) && (j <= 140)
                face(i, j) = 1.5 * (I(i, j) + threshold);
            end
        end
    end        
    
    for i = 1: 5
        face = crossMedianFilter(face, 15);
    end
end