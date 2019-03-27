function [Labeled, numObjects] = countObjects(I)
    [h, w] = size(I);
    
    fprintf('Start Labeling\n');
    Labeled = zeros(size(I));
    labelNum = 1;

    for i = 2: h - 1
        for j = 2: w - 1
            if I(i, j) == 1 && Labeled(i, j) == 0
                Labeled(i, j) = labelNum;
                Labeled = label(I, Labeled, labelNum, i, j, h, w);
                labelNum = labelNum + 1;
            end
        end
    end
    
    numObjects = max(max(Labeled));
end