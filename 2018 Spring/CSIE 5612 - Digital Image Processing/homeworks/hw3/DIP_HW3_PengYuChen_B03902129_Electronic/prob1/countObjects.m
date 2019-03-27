function [Dilated, Labeled, numObjects] = countObjects(I)
    [h, w] = size(I);
        
    Dilated = dilateBinary(I, 9);
    
    fprintf('Start Labeling\n');
    Labeled = zeros(size(I));
    labelNum = 1;

    for i = 2: h - 1
        for j = 2: w - 1
            if Dilated(i, j) == 1 && Labeled(i, j) == 0
                Labeled(i, j) = labelNum;
                Labeled = label(Dilated, Labeled, labelNum, i, j, h, w);
                labelNum = labelNum + 1;
            end
        end
    end
    
    numObjects = max(max(Labeled));
end