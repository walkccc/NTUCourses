function prob2()
    I2 = readraw2('./raw/sample2.raw');
    [h, w] = size(I2);
    
    % Compute 9 images by laws' masks
    M = law(I2);
    CHANNELS = 9;

    % Plot Ms
    figure('Name', "Prob2: Laws' masks", 'NumberTitle', 'off');
    for i = 1: CHANNELS
        subplot(3, 3, i), imshow(uint8(M(:, :, i))), title(strcat('M', num2str(i)));
    end
    
    % Compute Ts by Ms
    for i = 1: CHANNELS
        fprintf('Computing T%d (Energy of M%d)\n', i, i);
        T(:, :, i) = computeEnergy(M(:, :, i), 13);
    end
    
    % Plot Ts
    figure('Name', "Prob2: Energies", 'NumberTitle', 'off');
    for i = 1: CHANNELS
        subplot(3, 3, i), imshow(uint8(T(:, :, i) / 50)), title(strcat('T', num2str(i)));
    end
    
    KMEANS = kmeans(3, M);
    TK = computeEnergy(KMEANS, 13);
    noiseK = findTextures(TK, T(:, :, 8));
    K = crossMedianFilter(noiseK, 61);

    % Manually clean the boundary noise
    for i = 1: h
        for j = 1: w
            if (i > 500 && j > 240) || (i > 280 && j > 500)
                K(i, j) = 100;
            end
        end
    end
    
    figure('Name', 'Prob2: Texture Analysis', 'Numbertitle', 'off');
    subplot(1, 3, 1), imshow(KMEANS), title('KMEANS');
    subplot(1, 3, 2), imshow(noiseK), title('K with noise');
    subplot(1, 3, 3), imshow(K), title('K');

    exchanged = exchange(I2, K, 512);
    
    figure('Name', 'Prob2: Texture Exchanging', 'Numbertitle', 'off');
    subplot(1, 2, 1), imshow(I2), title('I2');
    subplot(1, 2, 2), imshow(exchanged), title('exchanged');

    % Write necessary files
    writeraw(K, './outputs/K.raw');
    
    % Write necessary images for report
%     imwrite(KMEANS, '/Users/jay/Desktop/hw3/report/img/KMEANS.png');
%     imwrite(noiseK, '/Users/jay/Desktop/hw3/report/img/noiseK.png');
%     imwrite(K, '/Users/jay/Desktop/hw3/report/img/K.png');
%     imwrite(exchanged, '/Users/jay/Desktop/hw3/report/img/exchanged.png');
end