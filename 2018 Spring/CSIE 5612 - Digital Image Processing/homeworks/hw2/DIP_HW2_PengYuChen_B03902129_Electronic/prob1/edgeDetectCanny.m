function [E, G, THETA, THETA2] = edgeDetectCanny(I, TL, TH, isNoise)
    I = double(I);
    [h, w] = size(I);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 1: Noise reduction %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %     p = 1; P = padarray(I, [p p], 'replicate', 'both');
    %     b = 1; mask = 1 / (b + 2)^2 * [1, b, 1; b, b^2, b; 1, b, 1];
    p = 2; P = padarray(I, [p p], 0, 'both');
    mask = 1 / 159 * [2, 4, 5, 4, 2; 4, 9, 12, 9, 4; 5, 12, 15, 12, 5; 4, 9, 12, 9, 4; 2, 4, 5, 4, 2];
        
    % Perform a 5 x 5 Gaussian filter
    GF = zeros(h, w);
    for i = p + 1: p + h
        for j = p + 1: p + w
            mat = P(i - p: i + p, j - p: j + p);
            GF(i - p, j - p) = sum(sum(mat .* mask));
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 2: Compute gradient magnitude and orientation %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	[E, Gx, Gy, G] = edgeDetectFirst(GF, 9, 30, 2);  % k = 2: Using Sobel Mask
    THETA = atan2(Gy, Gx);
    THETA = THETA * 180 / pi;
    
    % Adjustment for negative directions, making all directions positive
    for i = 1: h
        for j = 1: w
            if (THETA(i, j) < 0) 
                THETA(i, j) = 360 + THETA(i, j);
            end
        end
    end
    

    % Adjusting directions to nearest 0, 45, 90, or 135 degree
    THETA2 = zeros(h, w);
    for i = 1: h
        for j = 1: w
            if (THETA(i, j) >= 0) && (THETA(i, j) < 22.5) || (THETA(i, j) >= 157.5) && (THETA(i, j) < 202.5) || (THETA(i, j) >= 337.5) && (THETA(i, j) <= 360)
                THETA2(i, j) = 0;
            elseif (THETA(i, j) >= 22.5) && (THETA(i, j) < 67.5) || (THETA(i, j) >= 202.5) && (THETA(i, j) < 247.5)
                THETA2(i, j) = 45;
            elseif (THETA(i, j) >= 67.5 && THETA(i, j) < 112.5) || (THETA(i, j) >= 247.5 && THETA(i, j) < 292.5)
                THETA2(i, j) = 90;
            elseif (THETA(i, j) >= 112.5 && THETA(i, j) < 157.5) || (THETA(i, j) >= 292.5 && THETA(i, j) < 337.5)
                THETA2(i, j) = 135;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 3: Non-maximal suppression %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    GN = zeros(h, w);
    for i = 2: h - 1
        for j = 2: w - 1
            switch THETA2(i, j)
                case 0
                    if G(i, j) > G(i, j - 1) && G(i, j) > G(i, j + 1)
                        GN(i, j) = G(i, j);
                    end
                case 45
                    if G(i, j) > G(i + 1, j - 1) && G(i, j) > G(i - 1, j + 1)
                        GN(i, j) = G(i, j);
                    end
                case 90
                    if G(i, j) > G(i - 1, j) && G(i, j) > G(i + 1, j)
                        GN(i, j) = G(i, j);
                    end
                case 135
                    if G(i, j) > G(i - 1, j - 1) && G(i, j) > G(i + 1, j + 1)
                        GN(i, j) = G(i, j);
                    end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 4: Hysteretic thresholding %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    TL = TL * max(max(GN));
    TH = TH * max(max(GN));
    
    label = zeros(h, w);    
    C = zeros(h, w);
    for i = 1: h
        for j = 1: w
            if GN(i, j) >= TH
                label(i, j) = 0;    % Label as Edge Pixel
                C(i, j) = 255;
            elseif GN(i, j) >= TL
                label(i, j) = 1;    % Label as Candidate Pixel
                C(i, j) = 127;
            else
                label(i, j) = 2;    % Label as Non-edge Pixel
            end
        end
    end
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 5: Connected component labeling method %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    E = zeros(h, w);
    for i = 2: h - 1
        for j = 2: w - 1
            switch label(i, j)
                case 0
                    E(i, j) = 255;
                case 1
                    if ((label(i, j - 1) == 0 || label(i, j - 1) == 0) && (label(i, j + 1) == 1 || label(i, j + 1) == 1)) || ((label(i + 1, j - 1) == 0 || label(i + 1, j - 1) == 0) && (label(i - 1, j + 1) == 1 || label(i - 1, j + 1) == 1)) || ((label(i - 1, j) == 0 || label(i - 1, j) == 0) && (label(i + 1, j) == 1 || label(i + 1, j) == 1)) || ((label(i - 1, j - 1) == 0 || label(i - 1, j - 1) == 0) && (label(i + 1, j + 1) == 1 || label(i + 1, j + 1) == 1))
                        E(i, j) = 255;
                    end
            end
        end
    end
    
    I = uint8(I);
    GF = uint8(GF);
    G = uint8(G);
    GN = uint8(GN);
    C = uint8(C);
    E = uint8(E);
    
    figure('Name', strcat('Prob1: Canny Edge Detector', isNoise), 'NumberTitle', 'off');
    subplot(2, 3, 1), imshow(I),  title('Input');
    subplot(2, 3, 2), imshow(GF), title('Step 1: Gaussian filter');
    subplot(2, 3, 3), imshow(G),  title('Step 2: Magnitude');
    subplot(2, 3, 4), imshow(GN), title('Step 3: Non-maximal');
    subplot(2, 3, 5), imshow(C),  title('Step 4: Hysteretec');
    subplot(2, 3, 6), imshow(E),  title('Step 5: Connected component');
    
%     imwrite(GF, strcat(strcat('./myOutputs/GF', isNoise), '.png'));
%     imwrite(G,  strcat(strcat('./myOutputs/G', isNoise), '.png'));
%     imwrite(GN, strcat(strcat('./myOutputs/GN', isNoise), '.png'));
%     imwrite(C,  strcat(strcat('./myOutputs/CC', isNoise), '.png'));
%     imwrite(E,  strcat(strcat('./myOutputs/E', isNoise), '.png'));
end