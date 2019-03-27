function G = readraw(filename, row, col)
	disp(['Retrieving image from ' filename]);
    
	fd = fopen(filename, 'rb');
	if (fd == -1)
	  	error("Can't open the input image file\n");
	  	pause
    end
    
    G = fread(fd, row * col, 'uchar');
    Z = reshape(G, row, col);
    Z = Z';
    G = Z;
    G = uint8(G);
end
