function [I3, I4, G1, G2, S1, S2, RG, RS, face] = prob2()
    I3 = readraw('./raw/sample3.raw');
    I4 = readraw('./raw/sample4.raw');
    
    % Generate Gaussian noise images
    G1 = addGaussianNoise(I3, 3, 0);
    G2 = addGaussianNoise(I3, 10, 0);
    
    % Generate salt-and-pepper noise images
    S1 = addSaltAndPepper(I3, 0.01);
    S2 = addSaltAndPepper(I3, 0.03);

    % 3 x 3 Low Pass Filter with different parameters
    RG1 = lowPassFilter(G1, 1);
    RG2 = lowPassFilter(G1, 2);
    RG5 = lowPassFilter(G1, 5);
    RG10 = lowPassFilter(G1, 10);
    RG15 = lowPassFilter(G1, 15);
    RG20 = lowPassFilter(G1, 20);
    RG30 = lowPassFilter(G1, 30);
    RG = RG1;
    
    figure('Name', 'Prob2: Low Pass Filter with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(I3), title('I3');
    subplot(3, 3, 2), imshow(G1), title('G1');
    subplot(3, 3, 3), imshow(RG1), title('b = 1');
    subplot(3, 3, 4), imshow(RG2), title('b = 2');
    subplot(3, 3, 5), imshow(RG5), title('b = 5');
    subplot(3, 3, 6), imshow(RG10), title('b = 10');
    subplot(3, 3, 7), imshow(RG15), title('b = 15');
    subplot(3, 3, 8), imshow(RG20), title('b = 20');
    subplot(3, 3, 9), imshow(RG30), title('b = 30');
    
    % n x n Square Median Filter with different window sizes
    RS3 = squareMedianFilter(S1, 3);
    RS5 = squareMedianFilter(S1, 5);
    RS7 = squareMedianFilter(S1, 7);
    RS9 = squareMedianFilter(S1, 9);
    RS11 = squareMedianFilter(S1, 11);
    RS13 = squareMedianFilter(S1, 13);
    RS15 = squareMedianFilter(S1, 15);
    RS = RS3;
    
    figure('Name', 'Prob2: n x n Square Median Filter with different window sizes', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(I3), title('I3');
    subplot(3, 3, 2), imshow(S1), title('S1');
    subplot(3, 3, 3), imshow(RS3), title('n = 3');
    subplot(3, 3, 4), imshow(RS5), title('n = 5');
    subplot(3, 3, 5), imshow(RS7), title('n = 7');
    subplot(3, 3, 6), imshow(RS9), title('n = 9');
    subplot(3, 3, 7), imshow(RS11), title('n = 11');
    subplot(3, 3, 8), imshow(RS13), title('n = 13');
    subplot(3, 3, 9), imshow(RS15), title('n = 15');

    % n + n - 1 Cross Median Filter with different cross sizes    
    RSC3 = crossMedianFilter(S1, 3);
    RSC5 = crossMedianFilter(S1, 5);
    RSC7 = crossMedianFilter(S1, 7);
    RSC9 = crossMedianFilter(S1, 9);
    RSC11 = crossMedianFilter(S1, 11);
    RSC13 = crossMedianFilter(S1, 13);
    RSC15 = crossMedianFilter(S1, 15);
    RSC = RSC3;

    figure('Name', 'Prob2: n + n - 1 Cross Median Filter with different cross sizes', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(I3), title('I3');
    subplot(3, 3, 2), imshow(S1), title('S1');
    subplot(3, 3, 3), imshow(RSC3), title('n = 3');
    subplot(3, 3, 4), imshow(RSC5), title('n = 5');
    subplot(3, 3, 5), imshow(RSC7), title('n = 7');
    subplot(3, 3, 6), imshow(RSC9), title('n = 9');
    subplot(3, 3, 7), imshow(RSC11), title('n = 11');
    subplot(3, 3, 8), imshow(RSC13), title('n = 13');
    subplot(3, 3, 9), imshow(RSC15), title('n = 15');
    
    % Compute the PSNR values of RG and RS
    PSNR_RG = PSNR(RG, I3)
    PSNR_RS = PSNR(RS, I3)
    PSNR_RSC = PSNR(RSC, I3)
    
    face = removeWrinkle(I4);
    
    figure('Name', 'Prob2: Face wrinkle removing', 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(I4), title('I4');
    subplot(1, 2, 2), imshow(face), title('face (removed wrinkle)');    
end