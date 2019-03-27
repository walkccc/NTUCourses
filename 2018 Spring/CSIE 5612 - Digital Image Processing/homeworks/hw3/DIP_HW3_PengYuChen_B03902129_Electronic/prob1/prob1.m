function prob1()
    I1 = readraw('./raw/sample1.raw');
        
    % Perform boundary extraction
    [B, I1H] = boundaryExtract(I1);
    figure('Name', 'Prob1: Boundary Extraction', 'NumberTitle', 'off');
    subplot(1, 3, 1), imshow(I1),  title('I1');
    subplot(1, 3, 2), imshow(I1H), title('I1 ominus H');
    subplot(1, 3, 3), imshow(B),  title('B');
    
    % Count objects of I1
    [Dilated, Labeled, numObjects] = countObjects(I1);
    fprintf("The count number of the objects is %d\n", numObjects);
    figure('Name', 'Prob1: Count Objects and Label', 'NumberTitle', 'off');
    subplot(1, 3, 1), imshow(I1), title('I1');
    subplot(1, 3, 2), imshow(Dilated), title('Dilated');
    subplot(1, 3, 3), imshow(uint8(255 / numObjects * Labeled)), title('Labeled by different intensities');

    % Perform skeletonizing    
    S = skeletonize(I1);
    figure('Name', 'Prob1: Skeletonizing', 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(I1), title('I1');
    subplot(1, 2, 2), imshow(S), title('S');
    
    % Write necessary files
    writeraw(B, './outputs/B.raw');
    writeraw(S, './outputs/S.raw');
    
    % Write necessary images for report
%     imwrite(I1, '/Users/jay/Desktop/hw3/report/img/I1.png');
%     imwrite(I1H, '/Users/jay/Desktop/hw3/report/img/I1H.png');
%     imwrite(B, '/Users/jay/Desktop/hw3/report/img/B.png');
%     imwrite(Dilated, '/Users/jay/Desktop/hw3/report/img/Dilated.png');
%     imwrite(uint8(255 / numObjects * Labeled), '/Users/jay/Desktop/hw3/report/img/Labeled.png');
%     imwrite(S, '/Users/jay/Desktop/hw3/report/img/S.png');

end