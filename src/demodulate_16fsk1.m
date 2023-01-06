function y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate)
% demodulate_16fsk1 用于对16fsk信号进行相干解调
% x_fsk: 输入的16fsk调制信号; fs: 采样率; w_fsk: 载波信号的角频率; fp1: 低通滤波器通带截止频率; 
% fs1:低通滤波器阻带截止频率; rs,rp: 滤波器参数; smooth: 单个码元长度; symbol_rate: 码元速率

tao=1/smooth;
t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
Fs=fs;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %通带边界频率
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %阻带边界频率
[n,wn]=buttord(wp,ws,rp,rs,'s'); %滤波器的阶数n和-3dB归一化截止频率Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %双线性变换
y_fsk = zeros(4, length(x_fsk));
symbols = length(x_fsk)/smooth;  %码元数目
M = 16;
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % 预置检测信号
    distance = zeros(1,M);              % 解调：储存该频率下的平均振幅
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

