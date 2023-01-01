function y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% demodulate_16fsk1函数用于对16fsk信号进行相干解调
tao=1/smooth;
t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
Fs=fs;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %通带边界频率
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %阻带边界频率
[n,wn]=buttord(wp,ws,rp,rs,'s'); %滤波器的阶数n和-3dB归一化截止频率Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %双线性变换
y_fsk = zeros(4, length(x_fsk));
symbols = length(x_fsk)/smooth;  %测试信号长度
M = 16;
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % 预置检测信号
    distance = zeros(1,M);              % 解调：距离检测
    for j = 1 : M
        y_ = y.*sin(j*w_fsk*t1);       
        y_=filter(num,den,y_);
        distance(j) = mean(abs(y_));        
    end
    for i = 1 : y_len                
        pos = find(distance == max(distance)); % 择大判决
        detect(i) = pos(1) - 1; % 解调后的符号（十进制）
        y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end
end

