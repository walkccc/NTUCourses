function G = readraw(filename)
	disp(['Retrieving image from ' filename]);
    
	fd = fopen(filename, 'rb');
	if (fd == -1)
	  	error("Can't open the input image file\n");
	  	pause
    end
    
    row = 256; col = 256;
    G = fread(fd, row * col, 'uchar');
    Z = reshape(G, row, col);
    Z = Z';
    G = Z;
    G = uint8(G);
end
