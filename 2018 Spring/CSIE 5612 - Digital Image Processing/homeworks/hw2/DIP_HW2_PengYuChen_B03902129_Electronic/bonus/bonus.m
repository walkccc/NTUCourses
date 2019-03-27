function bonus()
    I4 = readraw('./raw/sample4.raw');
    I5 = readraw('./raw/sample5.raw');
    I4_EC = edgeCrispening(I4, 7 * I4, 0.8);
    I5_EC = edgeCrispening(I5, 7 * I5, 0.8);

    figure('Name', 'Bonus: Enhanced images', 'NumberTitle', 'off');
    subplot(2, 2, 1), imshow(I4), title('sample4');
    subplot(2, 2, 2), imshow(I4_EC), title('sample4 enhanced');
    subplot(2, 2, 3), imshow(I5), title('sample5');
    subplot(2, 2, 4), imshow(I5_EC), title('sample5 enhanced');

%     imwrite(I4, '/Users/Jay/Desktop/report/img/I4.png');
%     imwrite(I5, '/Users/Jay/Desktop/report/img/I5.png');
%     imwrite(I4_EC, '/Users/Jay/Desktop/report/img/I4_EC.png');
%     imwrite(I5_EC, '/Users/Jay/Desktop/report/img/I5_EC.png');
end