function prob1()
    I1 = readraw('./raw/sample1.raw');
    I2 = readraw('./raw/sample2.raw');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Perform 1st Order Edge Detection %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ED1_3_10 = edgeDetectFirst(I1, 3, 10);
    ED1_3_30 = edgeDetectFirst(I1, 3, 30);
    ED1_3_50 = edgeDetectFirst(I1, 3, 50);
    ED1_4_10 = edgeDetectFirst(I1, 4, 10);
    ED1_4_30 = edgeDetectFirst(I1, 4, 30);
    ED1_4_50 = edgeDetectFirst(I1, 4, 50);
    ED1_9_10_1 = edgeDetectFirst(I1, 9, 10, 1);
    ED1_9_30_1 = edgeDetectFirst(I1, 9, 30, 1);
    ED1_9_50_1 = edgeDetectFirst(I1, 9, 50, 1);
    ED1_9_10_2 = edgeDetectFirst(I1, 9, 10, 2);
    ED1_9_30_2 = edgeDetectFirst(I1, 9, 30, 2);
    ED1_9_50_2 = edgeDetectFirst(I1, 9, 50, 2);
    
    figure('Name', 'Prob1: 1st Order Edge Detection with different parameters', 'NumberTitle', 'off');
    subplot(4, 3, 1), imshow(ED1_3_10), title('p = 3, T = 10');
    subplot(4, 3, 2), imshow(ED1_3_30), title('p = 3, T = 30');
    subplot(4, 3, 3), imshow(ED1_3_50), title('p = 3, T = 50');
    subplot(4, 3, 4), imshow(ED1_4_10), title('p = 4, T = 10');
    subplot(4, 3, 5), imshow(ED1_4_30), title('p = 4, T = 30');
    subplot(4, 3, 6), imshow(ED1_4_50), title('p = 4, T = 50');
    subplot(4, 3, 7), imshow(ED1_9_10_1), title('p = 9, T = 10, k = 1');
    subplot(4, 3, 8), imshow(ED1_9_30_1), title('p = 9, T = 30, k = 1');
    subplot(4, 3, 9), imshow(ED1_9_50_1), title('p = 9, T = 50, k = 1');
    subplot(4, 3, 10), imshow(ED1_9_10_2), title('p = 9, T = 10, k = 2');
    subplot(4, 3, 11), imshow(ED1_9_30_2), title('p = 9, T = 30, k = 2');
    subplot(4, 3, 12), imshow(ED1_9_50_2), title('p = 9, T = 50, k = 2');
    
%     imwrite(ED1_3_10, './myOutputs/ED1_3_10.png');   
%     imwrite(ED1_3_30, './myOutputs/ED1_3_30.png');   
%     imwrite(ED1_3_50, './myOutputs/ED1_3_50.png');   
%     imwrite(ED1_4_10, './myOutputs/ED1_4_10.png');   
%     imwrite(ED1_4_30, './myOutputs/ED1_4_30.png');   
%     imwrite(ED1_4_50, './myOutputs/ED1_4_50.png');   
%     imwrite(ED1_9_10_1, './myOutputs/ED1_9_10_1.png');
%     imwrite(ED1_9_30_1, './myOutputs/ED1_9_30_1.png');
%     imwrite(ED1_9_50_1, './myOutputs/ED1_9_50_1.png');
%     imwrite(ED1_9_10_2, './myOutputs/ED1_9_10_2.png');
%     imwrite(ED1_9_30_2, './myOutputs/ED1_9_30_2.png');
%     imwrite(ED1_9_50_2, './myOutputs/ED1_9_50_2.png');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Perform 2nd Order Edge Detection %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ED2_4_10 = edgeDetectSecond(I1, 4, 10);
    ED2_4_15 = edgeDetectSecond(I1, 4, 15);
    ED2_4_20 = edgeDetectSecond(I1, 4, 20);
    ED2_8_10 = edgeDetectSecond(I1, 8, 10);
    ED2_8_15 = edgeDetectSecond(I1, 8, 15);
    ED2_8_20 = edgeDetectSecond(I1, 8, 20);

    figure('Name', 'Prob1: 2nd Order Edge Detection with different parameters', 'NumberTitle', 'off');
    subplot(2, 3, 1), imshow(ED2_4_10), title('n = 4, T = 10');
    subplot(2, 3, 2), imshow(ED2_4_15), title('n = 4, T = 15');
    subplot(2, 3, 3), imshow(ED2_4_20), title('n = 4, T = 20');
    subplot(2, 3, 4), imshow(ED2_8_10), title('n = 8, T = 10');
    subplot(2, 3, 5), imshow(ED2_8_15), title('n = 8, T = 15');
    subplot(2, 3, 6), imshow(ED2_8_20), title('n = 8, T = 20');
    
%     imwrite(ED2_4_10, './myOutputs/ED2_4_10.png');
%     imwrite(ED2_4_15, './myOutputs/ED2_4_15.png');
%     imwrite(ED2_4_20, './myOutputs/ED2_4_20.png');
%     imwrite(ED2_8_10, './myOutputs/ED2_8_10.png');
%     imwrite(ED2_8_15, './myOutputs/ED2_8_15.png');
%     imwrite(ED2_8_20, './myOutputs/ED2_8_20.png');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Perform Canny Edge Detection %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    edgeDetectCanny(I1, 0.075, 0.175, '');
    edgeDetectCanny(I2, 0.175, 0.225, '(noise)');

end