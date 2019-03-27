function S = skeletonize(I)
    I = logical(I);         % Convert I to a logic array
    
    isChange = true;
    [h, w] = size(I);
    S = I;
    deletion = ones(h, w);
    while isChange
        isChange = false;
        for step = 1: 2
            for i = 2: h - 1
                for j = 2: w - 1
                    P = [S(i, j) S(i - 1, j) S(i - 1, j + 1) S(i, j + 1) S(i + 1, j + 1) S(i + 1, j) S(i + 1,j - 1) S(i,j - 1) S(i - 1,j - 1) S(i - 1,j)];
                    if step == 1
                        cond = (S(i, j) == 1 && sum(P(2: end - 1)) <= 6 && sum(P(2: end - 1)) >=2 && P(2) * P(4) * P(6) == 0 && P(4) * P(6) * P(8) == 0);
                    elseif step == 2
                        cond = (S(i, j) == 1 && sum(P(2: end - 1)) <= 6 && sum(P(2: end - 1)) >=2 && P(2) * P(4) * P(8) == 0 && P(2) * P(6) * P(8) == 0);
                    end
                    if cond
                        A = 0;
                        for k = 2: size(P, 2) - 1
                            if P(k) == 0 && P(k + 1) == 1
                                A = A + 1;
                            end
                        end
                        if A == 1
                            deletion(i, j) = 0;
                            isChange = true;
                        end
                    end
                end
            end
            S = S .* deletion;
        end
    end
end