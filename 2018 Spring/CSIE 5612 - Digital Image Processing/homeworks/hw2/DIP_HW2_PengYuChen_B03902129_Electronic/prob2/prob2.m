function prob2()
    I3 = readraw('./raw/sample3.raw');
%     imwrite(I3, './myOutputs/C.png');
    C_5_06 = edgeCrispening(I3, 5 * I3, 0.6);
    C_5_07 = edgeCrispening(I3, 5 * I3, 0.7);
    C_5_08 = edgeCrispening(I3, 5 * I3, 0.8);
    C_7_06 = edgeCrispening(I3, 7 * I3, 0.6);
    C_7_07 = edgeCrispening(I3, 7 * I3, 0.7);
    C_7_08 = edgeCrispening(I3, 7 * I3, 0.8);
    C_9_06 = edgeCrispening(I3, 9 * I3, 0.6);
    C_9_07 = edgeCrispening(I3, 9 * I3, 0.7);
    C_9_08 = edgeCrispening(I3, 9 * I3, 0.8);
    
    figure('Name', 'Prob2: Edge Crispening with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(C_5_06), title('L = 5, c = 0.6');
    subplot(3, 3, 2), imshow(C_5_07), title('L = 5, c = 0.7');
    subplot(3, 3, 3), imshow(C_5_08), title('L = 5, c = 0.8');
    subplot(3, 3, 4), imshow(C_7_06), title('L = 7, c = 0.6');
    subplot(3, 3, 5), imshow(C_7_07), title('L = 7, c = 0.7');
    subplot(3, 3, 6), imshow(C_7_08), title('L = 7, c = 0.8');
    subplot(3, 3, 7), imshow(C_9_06), title('L = 9, c = 0.6');
    subplot(3, 3, 8), imshow(C_9_07), title('L = 9, c = 0.7');
    subplot(3, 3, 9), imshow(C_9_08), title('L = 9, c = 0.8');

%     imwrite(C_5_06, './myOutputs/C_5_06.png');
%     imwrite(C_5_07, './myOutputs/C_5_07.png');
%     imwrite(C_5_08, './myOutputs/C_5_08.png');
%     imwrite(C_7_06, './myOutputs/C_7_06.png');
%     imwrite(C_7_07, './myOutputs/C_7_07.png');
%     imwrite(C_7_08, './myOutputs/C_7_08.png');
%     imwrite(C_9_06, './myOutputs/C_9_06.png');
%     imwrite(C_9_07, './myOutputs/C_9_07.png');
%     imwrite(C_9_08, './myOutputs/C_9_08.png');
    
    W = warping(I3);
    
    figure('Name', 'Prob2: Perform warping function', 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(I3), title('sample3.raw');
    subplot(1, 2, 2), imshow(W), title('warped image');
    
end