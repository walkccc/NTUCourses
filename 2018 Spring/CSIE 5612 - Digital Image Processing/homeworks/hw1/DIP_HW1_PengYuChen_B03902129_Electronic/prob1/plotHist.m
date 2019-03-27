function plotHist(I)
    disp('Plotting Histogram');
    [h, w] = size(I);
    hist = zeros(256, 1);
    for i = 1: h * w
        hist(I(i) + 1) = hist(I(i) + 1) + 1;
    end
    
    bar(hist);
end