function [I2, D, H, L] = prob1()
    I2 = readraw('./raw/sample2.raw');
    
    % Decrease the brightness of I2 and output the result as D
    D = I2 / 3;
    
    figure('Name', 'Prob1: I2 and D', 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(I2), title('I2 (original)');
    subplot(1, 2, 2), imshow(D), title('D (decrease brightness)');  
    
    figure('Name', 'Prob1: Histograms of I2 and D', 'NumberTitle', 'off');
    subplot(1, 2, 1), plotHist(I2), title('histogram of I2');
    subplot(1, 2, 2), plotHist(D), title('histogram of D');
    
    % Perform Histogram Equalization on D and output the result as H
    H = histEq(D);

    figure('Name', 'Prob1: D and H', 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(D), title('D');
    subplot(1, 2, 2), imshow(H), title('H (histogram equalization)');  
    
    % Perform Local Histogram Equalization on D and output the result as L
    L3 = localhist(D, 3);
    L5 = localhist(D, 5);
    L7 = localhist(D, 7);
    L9 = localhist(D, 9);
    L15 = localhist(D, 15);
    L25 = localhist(D, 25);
    L45 = localhist(D, 45);
    L255 = localhist(D, 255);
    L = L45;
    
    figure('Name', 'Prob1: Local Histogram Equalization with different window sizes', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(L3), title('n = 3');
    subplot(3, 3, 2), imshow(L5), title('n = 5');
    subplot(3, 3, 3), imshow(L7), title('n = 7');
    subplot(3, 3, 4), imshow(L9), title('n = 9');
    subplot(3, 3, 5), imshow(L15), title('n = 15');
    subplot(3, 3, 6), imshow(L25), title('n = 25');
    subplot(3, 3, 7), imshow(L45), title('n = 45');
    subplot(3, 3, 8), imshow(L255), title('n = 255');
    subplot(3, 3, 9), imshow(H), title('H (global histogram)');
    
    figure('Name', 'Prob1: Histograms of H and L with different window sizes', 'NumberTitle', 'off');
    subplot(3, 3, 1), plotHist(L3), title('n = 3');
    subplot(3, 3, 2), plotHist(L5), title('n = 5');
    subplot(3, 3, 3), plotHist(L7), title('n = 7');
    subplot(3, 3, 4), plotHist(L9), title('n = 9');
    subplot(3, 3, 5), plotHist(L15), title('n = 15');
    subplot(3, 3, 6), plotHist(L25), title('n = 25');
    subplot(3, 3, 7), plotHist(L45), title('n = 35');
    subplot(3, 3, 8), plotHist(L255), title('n = 45');
    subplot(3, 3, 9), plotHist(H), title('H (global histogram)');
    
    % Perform the Log Transformation, Inverse Log Transformation and Power-Law Transformation to enhance image D.
    % Perform the Log Transformation to enhance image D.
    LT5 = logTrans(D, 5);
    LT15 = logTrans(D, 15);
    LT25 = logTrans(D, 25);
    LT35 = logTrans(D, 35);
    LT45 = logTrans(D, 45);
    LT55 = logTrans(D, 55);
    LT65 = logTrans(D, 65);
    LT75 = logTrans(D, 75);
    LT85 = logTrans(D, 85);

    figure('Name', 'Prob1: Log Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(LT5), title('c = 5');
    subplot(3, 3, 2), imshow(LT15), title('c = 15');
    subplot(3, 3, 3), imshow(LT25), title('c = 25');
    subplot(3, 3, 4), imshow(LT35), title('c = 35');
    subplot(3, 3, 5), imshow(LT45), title('c = 45');
    subplot(3, 3, 6), imshow(LT55), title('c = 55');
    subplot(3, 3, 7), imshow(LT65), title('c = 65');
    subplot(3, 3, 8), imshow(LT75), title('c = 75');
    subplot(3, 3, 9), imshow(LT85), title('c = 85');

    figure('Name', 'Prob1: Histograms of Log Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), plotHist(LT5), title('c = 5');
    subplot(3, 3, 2), plotHist(LT15), title('c = 15');
    subplot(3, 3, 3), plotHist(LT25), title('c = 25');
    subplot(3, 3, 4), plotHist(LT35), title('c = 35');
    subplot(3, 3, 5), plotHist(LT45), title('c = 45');
    subplot(3, 3, 6), plotHist(LT55), title('c = 55');
    subplot(3, 3, 7), plotHist(LT65), title('c = 65');
    subplot(3, 3, 8), plotHist(LT75), title('c = 75');
    subplot(3, 3, 9), plotHist(LT85), title('c = 85'); 
    
    % Perform the Inverse Log Transformation to enhance image D.
    ILT1 = invLogTrans(D, 1);
    ILT2 = invLogTrans(D, 2);
    ILT3 = invLogTrans(D, 3);
    ILT4 = invLogTrans(D, 4);
    ILT5 = invLogTrans(D, 5);
    ILT6 = invLogTrans(D, 6);
    ILT7 = invLogTrans(D, 7);
    ILT8 = invLogTrans(D, 8);
    ILT9 = invLogTrans(D, 9);

    figure('Name', 'Prob1: Inverse Log Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(ILT1), title('c = 1');
    subplot(3, 3, 2), imshow(ILT2), title('c = 2');
    subplot(3, 3, 3), imshow(ILT3), title('c = 3');
    subplot(3, 3, 4), imshow(ILT4), title('c = 4');
    subplot(3, 3, 5), imshow(ILT5), title('c = 5');
    subplot(3, 3, 6), imshow(ILT6), title('c = 6');
    subplot(3, 3, 7), imshow(ILT7), title('c = 7');
    subplot(3, 3, 8), imshow(ILT8), title('c = 8');
    subplot(3, 3, 9), imshow(ILT9), title('c = 9');

    figure('Name', 'Prob1: Histograms of Inverse Log Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), plotHist(ILT1), title('c = 1');
    subplot(3, 3, 2), plotHist(ILT2), title('c = 2');
    subplot(3, 3, 3), plotHist(ILT3), title('c = 3');
    subplot(3, 3, 4), plotHist(ILT4), title('c = 4');
    subplot(3, 3, 5), plotHist(ILT5), title('c = 5');
    subplot(3, 3, 6), plotHist(ILT6), title('c = 6');
    subplot(3, 3, 7), plotHist(ILT7), title('c = 7');
    subplot(3, 3, 8), plotHist(ILT8), title('c = 8');
    subplot(3, 3, 9), plotHist(ILT9), title('c = 9'); 
    
    % Perform the Power-Law Transformation to enhance image D.
    PL02 = powerLawTrans(D, 0.2);
    PL04 = powerLawTrans(D, 0.4);
    PL06 = powerLawTrans(D, 0.6);
    PL08 = powerLawTrans(D, 0.8);
    PL10 = powerLawTrans(D, 1.0);
    PL15 = powerLawTrans(D, 1.5);
    PL20 = powerLawTrans(D, 2.0);
    PL25 = powerLawTrans(D, 2.5);
    PL30 = powerLawTrans(D, 3.0);

    figure('Name', 'Prob1: Power-Law Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), imshow(PL02), title('p = 0.2');
    subplot(3, 3, 2), imshow(PL04), title('p = 0.4');
    subplot(3, 3, 3), imshow(PL06), title('p = 0.6');
    subplot(3, 3, 4), imshow(PL08), title('p = 0.8');
    subplot(3, 3, 5), imshow(PL10), title('p = 1.0');
    subplot(3, 3, 6), imshow(PL15), title('p = 1.5');
    subplot(3, 3, 7), imshow(PL20), title('p = 2.0');
    subplot(3, 3, 8), imshow(PL25), title('p = 2.5');
    subplot(3, 3, 9), imshow(PL30), title('p = 3.0');

    figure('Name', 'Prob1: Histograms of Power-Law Transformation with different parameters', 'NumberTitle', 'off');
    subplot(3, 3, 1), plotHist(PL02), title('p = 0.2');
    subplot(3, 3, 2), plotHist(PL04), title('p = 0.4');
    subplot(3, 3, 3), plotHist(PL06), title('p = 0.6');
    subplot(3, 3, 4), plotHist(PL08), title('p = 0.8');
    subplot(3, 3, 5), plotHist(PL10), title('p = 1.0');
    subplot(3, 3, 6), plotHist(PL15), title('p = 1.5');
    subplot(3, 3, 7), plotHist(PL20), title('p = 2.0');
    subplot(3, 3, 8), plotHist(PL25), title('p = 2.5');
    subplot(3, 3, 9), plotHist(PL30), title('p = 3.0'); 
    
    % Write raw images
    writeraw(D, './outputs/D.raw');
    writeraw(H, './outputs/H.raw');
    writeraw(L, './outputs/L.raw');
end