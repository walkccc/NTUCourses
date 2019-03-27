function I = readrawRGB(filename)
	disp(['Retrieving image from ', filename]);
    
	fd = fopen(filename, 'rb');
	if (fd == -1)
	  	error("Can't open the input image file\n");
	  	pause
    end

	pixel = fread(fd, inf, 'uchar');
	fclose(fd);
    
    [X, Y] = size(pixel);
    SIZE = (X * Y) / 3;
    N = sqrt(SIZE);
    I = zeros(N, N, 3, 'uint8');
    I(1: SIZE * 3) = pixel(1: SIZE * 3);
    I = permute(I, [2, 1, 3]);
end