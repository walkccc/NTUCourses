function M = law(I) 
    fprintf('Computing masks\n');
    [h, w] = size(I);

    % Pad array I
    I = [I(:, 1) I I(:, w)];
    I = [I(1, :); I; I(h, :)];
    p = 1;
    
    % Micro-structure impulse response arrays (a basis set)
    mask(:, :, 1) = 1 / 36 * [ 1  2  1;  2 4  2;  1  2  1];
    mask(:, :, 2) = 1 / 12 * [ 1  0 -1;  2 0 -2;  1  0 -1];
    mask(:, :, 3) = 1 / 12 * [-1  2 -1; -2 4 -2; -1  2 -1];
    mask(:, :, 4) = 1 / 12 * [-1 -2 -1;  0 0  0;  1  2  1];
    mask(:, :, 5) = 1 /  4 * [ 1  0 -1;  0 0  0; -1  0  1];
    mask(:, :, 6) = 1 /  4 * [-1  2 -1;  0 0  0;  1 -2  1];
    mask(:, :, 7) = 1 / 12 * [-1 -2 -1;  2 4  2; -1 -2 -1];
    mask(:, :, 8) = 1 /  4 * [-1  0  1;  2 0 -2; -1  0  1];
    mask(:, :, 9) = 1 /  4 * [ 1 -2  1; -2 4 -2;  1 -2  1];
    M = zeros(h, w, 9);
    
    for idx = 1: 9
        fprintf('Computing M%d\n', idx);
        for i = 1: h
            for j = 1: w
                M(i, j, idx) = sum(sum(double(I(i: i + 2 * p, j: j + 2 * p)) .* mask(:, :, idx)));
            end
        end
    end
end