function y_fsk = demodulate_16fsk2(x_fsk, fs, fc, smooth)
% demodulate_16fsk1 用于对16fsk信号进行非相干解调
% x_fsk: 16fsk调制信号; fs: 采样率; fc: 载波频率; smooth: 单个码元长度

Fs = smooth;
M = 16;
spf = zeros(M, length(x_fsk));
for i = 1 :M
    % 带通滤波
    fpass = fc*i - fc*0.3;
    fstop = fc*i + fc*0.3;
    spf(i, :) = IdealFilter(x_fsk, Fs, fpass, fstop);
    
    %全波整流
    spf(i, :) = abs(spf(i, :));

    %低通滤波
    fpass = fc-fc/2;
    fstop = fc+fc*0.2;
    spf(i, :) = IdealFilter(spf(i, :), Fs, fpass, fstop);
end

% 择大判决
y_fsk = zeros(4, length(x_fsk));

for i = 1 : length(x_fsk)/smooth
    %择多判决
    distance = spf(:, (i-1)*smooth+1:i*smooth);
    num = zeros(1, M);
    for j = 1 : smooth
        pos = find(distance(:, j) == max(distance(:, j)));
        detect = pos(1); % 解调后的符号（十进制）
        
        num(1, detect) = num(1, detect)+1;
    end
    pos = find(num == max(num));
    detect = pos(1) - 1; % 解调后的符号（十进制）
    y_fsk(:, i*smooth) = (dec2bin(detect, 4) - '0')';   
end

end

