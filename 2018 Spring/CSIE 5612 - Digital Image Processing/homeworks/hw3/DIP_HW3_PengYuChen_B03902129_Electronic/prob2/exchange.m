function exchanged = exchange(I2, K, SIZE)
    % I2: original image
    % K: an image with only 3 intensities
    % SIZE: default = 512
    
    [h, w] = size(K);
    texture1 = I2(1: SIZE / 4, 1: SIZE / 4);
    texture2 = I2(SIZE / 4 * 3 + 1: SIZE, 1: SIZE / 4);
    texture3 = I2(SIZE / 4 * 3 + 1: SIZE, SIZE / 4 * 3 + 1: SIZE);
    
    map1 = [];
    map2 = [];
    map3 = [];
    
    % Append maps horizontally 4 times
    for i = 1: SIZE / 128
        map1 = [map1 texture1];
        map2 = [map2 texture2];
        map3 = [map3 texture3];
    end

    % Append maps vertically 1 * 2 * 2 = 4 times
    for j = 1: 2
        map1 = [map1; map1];
        map2 = [map2; map2];
        map3 = [map3; map3];
    end
    
    exchanged = zeros(SIZE, SIZE);
    for i = 1: SIZE
        for j = 1: SIZE
            switch K(i, j)
                case 0   
                    exchanged(i, j) = map3(i, j);
                case 100
                    exchanged(i, j) = map1(i, j);
                case 200
                    exchanged(i, j) = map2(i, j);
            end
        end
    end

    
    % Write necessary images for report
%     imwrite(map1, '/Users/jay/Desktop/hw3/report/img/map1.png');
%     imwrite(map2, '/Users/jay/Desktop/hw3/report/img/map2.png');
%     imwrite(map3, '/Users/jay/Desktop/hw3/report/img/map3.png');
    
    exchanged = uint8(exchanged);
end
    
    