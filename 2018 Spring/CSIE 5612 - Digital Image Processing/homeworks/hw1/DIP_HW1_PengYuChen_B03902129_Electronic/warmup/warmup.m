function [I1, gray, B] = warmup()
    addpath('./readwriter');
    
    I1 = readrawRGB('./raw/sample1.raw');
    gray = (I1(:, :, 1) + I1(:, :, 2) + I1(:, :, 3)) / 3;
    B = permute(I1, [2, 1, 3]);
    
    % Create a figure window and plot sub figures
    figure('Name', 'WARM-UP', 'NumberTitle', 'off');
    subplot(1, 3, 1), imshow(I1), title('I1 (original)');
    subplot(1, 3, 2), imshow(gray), title('gray-level');
    subplot(1, 3, 3), imshow(B), title('diagonal flipping');
    
    % Write raw images
    writerawRGB(B, './outputs/B.raw');
end