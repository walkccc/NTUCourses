function ADSP_hw2(k)
R_Reso = 300;
[R, X, H, r1, r] = fsFilt(k);

R_pos = (0:(R_Reso - 1)) * (1 / R_Reso);
R_con = fft(circshift([R zeros(1, R_Reso - 2 * k - 1)], [0 -k]));

% Frequency / Impulse Response
% Note that: Using only the real component of complex data.
figure;
subplot(411);
plot(X, imag(H), 'black o', X, imag(H), 'blue', R_pos, imag(R_con), 'red');
title('Frequency Response');
xlabel('frequency(Hz)');

subplot(412);
stem(0: 2*k, real(r1));
title('r1[n]');
xlim([-2*k 2*k]);

subplot(413);
stem(-k:k, real(r));
title('r[n]');
xlim([-2*k 2*k]);

subplot(414);
stem(0:2*k, real(r));
title('h[n]');
xlim([-2*k 2*k]);

function [R, X, H, r1, r] = fsFilt(k)
    X = (0:(2 * k)) * (1 / (1 + 2 * k));
    H = 2 * pi() * j * (X - (X >= 0.5));
    R = circshift(ifft(H), [0 k]);
    r1 = ifft(H);
    % 
    for i = 1:k
        r(i + k + 1) = r1(i);
    end
    for i = (k + 1):(2 * k)
        r(i - k) = r1(i);
    end