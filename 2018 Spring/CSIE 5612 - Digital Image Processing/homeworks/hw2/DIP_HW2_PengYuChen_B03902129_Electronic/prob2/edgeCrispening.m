function E = edgeCrispening(I, L, c)
    I = double(I);
    L = double(L);
    E = c / (2 * c - 1) * I - (1 - c) / (2 * c - 1) * L;
    E = uint8(E);
end