function ADSP_hw1()
N = 21;                     % N: len(Filter)
k = (N - 1) / 2;      

% Initiallize
A = linspace(1, 1, 12); 
S = zeros(12, 1);    
H = zeros(12, 1);    

% STEP 01
F = [0; 0.05; 0.10; 0.13; 0.16; 0.23; 0.26; 0.29; 0.35; 0.4; 0.45; 0.5];
H = F >= 0.22;              % Get the value of F which are >= 0.22
f = 0: 0.0001: 0.5;
Hd = f >= 0.2;

W = [];
for t = 0: 0.0001: 0.5;
    if t <= 0.18
        W = [W 0.5];
    elseif t >= 0.22
        W = [W 1];
    else
        W = [W 0];
    end
end

E1 = 100;
E0 = 1;

% Start iterating
while E1 - E0 > 0.0001 | E1 - E0 < 0
    % STEP 02
    for i = 1:12
        for j = 1:11
            A(i, j) = cos(2 * pi * (j - 1) * F(i));
        end
        A(i, 12) = (-1)^(i - 1) * 1 / Wf(F(i));
    end
    S = A \ H;      % divide in matrix way

    % STEP 03
    RF = 0;
    for i = 1:11
        RF = RF + S(i) * cos(2 * pi * (i - 1) * f);
    end
    err = (RF - Hd) .* W;   % Do the dot product
    
    % STEP 05
    E1 = E0;
    [maxVal, maxLoc] = findpeaks(err);
    [minVal, minLoc] = findpeaks(-err);
    E0 = max(maxVal, minVal)
    
    % STEP 04
    F = sort([0 (maxLoc - 1) * 0.0001 (minLoc - 1) * 0.0001 0.5]);
    F = F';
end

% STEP 06
h(k + 1) = S(0 + 1);
for i = 1: k
    h(k - i + 1) = S(i + 1) / 2;
    h(k + i + 1) = S(i + 1) / 2;
end

% Plot Frequency Response
subplot(211)
plot(f, RF, 'k', f, Hd, 'b')
title('Frequency Response');
xlabel('freq(Hz)');
x = linspace(0, 20, 21);

% Plot Impulse Response
subplot(212)
stem(x, h)
title('Impulse Response');
xlabel('n');
xlim([-1 21])

function w = Wf(F)
if F >= 0.22
    w = 1;
elseif F <= 0.18
    w = 0.5;
else
    w = 0;
end
