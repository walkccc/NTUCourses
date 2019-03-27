function plotPSNR

ax1 = subplot(3, 1, 1); % Low-Pass Filter
x1 = [1, 2, 5, 10, 15, 20, 30];
y1 = [41.4883, 33.2315, 40.1584, 38.7482, 39.6454, 40.0507, 40.0775];
plot(ax1, x1, y1)
title(ax1,'PSNR values of RG by Low-Pass Filter')
ylabel(ax1, 'PSNR value (dB)')

ax2 = subplot(3, 1, 2);
x2 = [3, 5, 7, 9, 11, 13, 15];
y2 = [9.2300, 1.6150, -1.4873, -1.7027, -3.3377, -3.5759, -3.9865];
plot(ax2, x2, y2);
title(ax2, 'PSNR values of RS by Square Median Filter')
ylabel(ax2, 'PSNR value (dB)')

ax3 = subplot(3, 1, 3);
x3 = [3, 5, 7, 9, 11, 13, 15];
y3 = [7.2121, 7.2121, 7.2121, 7.2121, 7.2121, 7.2121, 7.2121];
plot(ax3, x3, y3);
title(ax3, 'PSNR values of RS by Cross Median Filter')
ylabel(ax3, 'PSNR value (dB)')
end