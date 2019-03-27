function L = label(I, L, labelNum, i, j, h, w)
    if I(i + 1, j) == 1 && L(i + 1, j) == 0
        L(i + 1, j) = labelNum;
        L = label(I, L, labelNum, i + 1, j, h, w);
    end

    if I(i - 1, j) == 1 && L(i - 1, j) == 0
        L(i - 1, j) = labelNum;
        L = label(I, L, labelNum, i - 1, j, h, w);
    end

    if I(i, j + 1) == 1 && L(i, j + 1) == 0
        L(i, j + 1) = labelNum;
        L = label(I, L, labelNum, i, j + 1, h, w);
    end

    if I(i, j - 1) == 1 && L(i, j - 1) == 0
        L(i, j - 1) = labelNum;
        L = label(I, L, labelNum, i, j - 1, h, w);
    end
end
