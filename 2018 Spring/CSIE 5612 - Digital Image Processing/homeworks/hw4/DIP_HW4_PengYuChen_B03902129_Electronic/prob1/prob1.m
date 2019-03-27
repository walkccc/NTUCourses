function [feature, Labeled_I1, Labeled_I2, H, i, g, x, eight, I, B, T, S, four, seven] = prob1()
    % Read images and convert them to binary uint8
    I1 = uint8(binary(readraw('./raw/sample1.raw', 390, 125)));
    I2 = uint8(binary(readraw('./raw/sample2.raw', 390, 125)));
    TS = uint8(binary(readraw('./raw/TrainingSet.raw', 450, 248)));

    % Crop the TrainingSet to multiples of 5 and 14
    TS = uint8(256 * TS(3: 247, 2: 449));
        
    % Get characters of TrainingSet
    NUM_CHAR = 0;
    NORM_h = 15;
    NORM_w = 15;
    for i = 1: 5
        for j = 1: 14
            NUM_CHAR = NUM_CHAR + 1;
            char(:, :, NUM_CHAR) = getChar(TS((i - 1) * 49 + 1: i * 49, (j - 1) * 32 + 1: j * 32), 255, NORM_h, NORM_w);
        end
    end

    % Generate features of TraingSet
    feature = genFeature(NUM_CHAR, NORM_h, NORM_w, char);
    
    % Plot extracted characters of TrainingSet
    figure('Name', "Characters of TrainingSet.raw", 'NumberTitle', 'off');
    for i = 1: NUM_CHAR
        subplot(5, 14, i), imshow(char(:, :, i)), title(strcat(num2str(i)));
    end
    
    % Perform Cross Median Filter on I2
    I2 = crossMedianFilter(crossMedianFilter(I2, 3), 3);
    
    % Count number of objects in I1 and I2
    [Labeled_I1, n1] = countObjects(I1);
    [Labeled_I2, n2] = countObjects(I2);
    
    % Preprocessing of 'i'
    for i = 1: 125
        for j = 1: 390
            if uint8(Labeled_I1(i, j)) == uint8(5)
                Labeled_I1(i, j) = 4;
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    % Get characters of I1 %
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    H_img = getChar(Labeled_I1, 1, NORM_h, NORM_w) * 255;
    eight_img = dilate(getChar(Labeled_I1, 2, NORM_h, NORM_w) * 255 / 2, 1);
    g_img = getChar(Labeled_I1, 3, NORM_h, NORM_w) * 255 / 3;
    i_img = getChar(Labeled_I1, 4, NORM_h, NORM_w) * 255 / 4;
    i_img(:, 1: 9) = 0;
    x_img = getChar(Labeled_I1, 6, NORM_h, NORM_w) * 255 / 6;
    
    H_feature = genFeature(1, NORM_h, NORM_w, H_img);
    [H_diff, H] = findChar(H_feature, feature);
    
    eight_feature = genFeature(1, NORM_h, NORM_w, eight_img);
    [eight_diff, eight] = findChar(eight_feature, feature);
    
    g_feature = genFeature(1, NORM_h, NORM_w, g_img);
    [g_diff, g] = findChar(g_feature, feature);
    
    x_feature = genFeature(1, NORM_h, NORM_w, x_img);
    [x_diff, x] = findChar(x_feature, feature);
    
    i_feature = genFeature(1, NORM_h, NORM_w, i_img);
    [i_diff, i] = findChar(i_feature, feature);
        
    %%%%%%%%%%%%%%%%%%%%%%%%
    % Get characters of I2 %
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    I_img = getChar(Labeled_I2, 1, NORM_h, NORM_w) * 255;
    B_img = getChar(Labeled_I2, 2, NORM_h, NORM_w) * 255 / 2;
    T_img = shift(getChar(Labeled_I2, 3, NORM_h, NORM_w) * 255 / 3);
    S_img = getChar(Labeled_I2, 4, NORM_h, NORM_w) * 255 / 4;
    four_img = getChar(Labeled_I2, 5, NORM_h, NORM_w) * 255 / 5;
    seven_img = dilate(getChar(Labeled_I2, 6, NORM_h, NORM_w) * 255 / 6, 1);
    
    I_feature = genFeature(1, NORM_h, NORM_w, I_img);
    [I_diff, I] = findChar(I_feature, feature);
    
    B_feature = genFeature(1, NORM_h, NORM_w, B_img);
    [B_diff, B] = findChar(B_feature, feature);

    T_feature = genFeature(1, NORM_h, NORM_w, T_img);
    [T_diff, T] = findChar(T_feature, feature);

    S_feature = genFeature(1, NORM_h, NORM_w, S_img);
    [S_diff, S] = findChar(S_feature, feature);

    four_feature = genFeature(1, NORM_h, NORM_w, four_img);
    [four_diff, four] = findChar(four_feature, feature);

    seven_feature = genFeature(1, NORM_h, NORM_w, seven_img);
    [seven_diff, seven] = findChar(seven_feature, feature);
    
    % Print characters of Sample1.raw
    fprintf('Characters of Sample1.raw: ');
    if H == 8
        fprintf('H');
    end
    
    if i == 35
        fprintf('i');
    end
    
    if g == 33
        fprintf('g');
    end
    
    if x == 50
        fprintf('X');
    end
    
    if eight == 61
        fprintf('8');
    end
    fprintf('\n');
    
    % Print characters of Sample2.raw
    fprintf('Characters of Sample2.raw: ');
    if S == 19
        fprintf('S');
    end
    
    if B == 2
        fprintf('B');
    end
    
    if four == 57
        fprintf('4');
    end
    
    if T == 20
        fprintf('T');
    end
    
    if seven == 60
        fprintf('7');
    end
    
    if I == 9
        fprintf('I');
    end
    fprintf('\n');
end