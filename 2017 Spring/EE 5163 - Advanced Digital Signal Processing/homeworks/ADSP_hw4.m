function [Fx, Fy] = ADSP_hw4(x,y)
    z = x + y * 1i;
    Fz = fft(z);
    FlipFz = fliplr(Fz);
    Fx = (Fz + conj(circshift(FlipFz, [0 1]))) / 2;
    Fy = (Fz - conj(circshift(FlipFz, [0 1]))) / (2 * 1j);