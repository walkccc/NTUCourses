function writerawRGB(I, filename)
    disp(['Writing image to ', filename]);
    
    fd = fopen(filename, 'wb');
    if (fd == -1)
        error("Can't open the output image file\n");
        pause
    end
 
    I = permute(I, [2, 1, 3]);
    fwrite(fd, I, 'uchar');
    fclose(fd);
end