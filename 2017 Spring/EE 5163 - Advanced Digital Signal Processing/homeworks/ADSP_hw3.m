function ADSP_hw3(score, beat, name, major, sec, fs)

voice = [];                   % Create an empty voice vector
if nargin < 4
    sec = 0.5;                
    fs = 8192;
    freq = 440.00;            % C major
elseif nargin >= 4            % major is specified
    switch major
        case 'C'
            freq = 440.00;
        case 'D'
            freq = 493.88;
        case 'E'
            freq = 523.25;
        case 'F'
            freq = 587.31;
        case 'G'
            freq = 659.26;
        case 'A'
            freq = 739.99;
        case 'B'
            freq = 830.61;
    end
    if nargin < 5
        sec = 0.5;
        fs = 8192;
    elseif nargin < 6
        fs = 8192;
    else
    end 
end

p = [60, 62, 64, 65, 67, 69, 71];  % CDEFGAB 
for i = 1:21
    p(i + 7) = p(i) + 12;
end

for i = 1:length(score)
    time = linspace(0, beat(i) * sec, fs * beat(i) * sec);
    f = freq * 2^((p(score(i)) - 69) / 12);
    y = sin(2 * pi * f * time);
    voice = [voice y];
end

audiowrite(strcat(name, '.wav'), voice, fs);
sound(voice, fs);