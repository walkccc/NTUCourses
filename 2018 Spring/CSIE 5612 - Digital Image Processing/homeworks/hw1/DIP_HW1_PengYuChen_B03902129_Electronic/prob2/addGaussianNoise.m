function G = addGaussianNoise(I, sigma, mu)
    G = double(I) + randn(size(I)) * sigma + mu;
    G = uint8(G);
end