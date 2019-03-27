function E = computeEnergy(I, SIZE)
    p = (SIZE - 1) / 2;
    I = uint8(I);
    [h, w] = size(I);
    E = zeros(h, w);
    
    % Initialize padding array first
    P = I;

    % Pad the array
    for i = 1: p
        P = [I(:, 1) P];
    end
    for i = p + 2: 2 * p + 1
        P = [P I(:, w)];
    end
    for i = 1: p
        P = [P(1, :); P];
    end
    for i = p + 2: 2 * p + 1
        P = [P; P(h + p, :)];
    end

    for i = 1: h
        for j = 1: w
            E(i, j) = sum(sum(P(i: i + 2 * p, j: j + 2 * p)));
        end
    end
end