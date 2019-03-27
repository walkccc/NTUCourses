function bonus()
    I3 = readraw('./raw/sample3.raw');
    RS = crossMedianFilter(I3, 25);
    Dilated = dilate(RS, 11);

    figure('Name', 'Bonus', 'Numbertitle', 'off');
    subplot(1, 3, 1), imshow(I3), title('I3');
    subplot(1, 3, 2), imshow(RS), title('Cross Median Filter');
    subplot(1, 3, 3), imshow(Dilated), title('Blurred Image');
    
%     Write necessary images for report
%     imwrite(I3, '/Users/jay/Desktop/hw3/report/img/I3.png');
%     imwrite(RS, '/Users/jay/Desktop/hw3/report/img/RS.png');
%     imwrite(Dilated, '/Users/jay/Desktop/hw3/report/img/Dilated2.png');
end