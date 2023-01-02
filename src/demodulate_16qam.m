function y_qam = demodulate_16qam(x_qam,fs, w_qam, fp1, fs1, rs, rp, smooth, symbol_rate)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% demodulate_16qam函数用于16QAM信号的解调
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
% %能量归一化,(2,2)归一化模为1
constell_diag=constell_diag./2/sqrt(2);
tao=1/smooth;
t2=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
M = 16;
y_qam = zeros(4, length(x_qam));
symbols = length(x_qam)/smooth;  %测试信号长度
Fs=fs;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %通带边界频率
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %阻带边界频率
[n,wn]=buttord(wp,ws,rp,rs,'s'); %滤波器的阶数n和-3dB归一化截止频率Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %双线性变换
%     [h,w]=freqz(num,den,100,Fs);
%     figure(1)
%     plot(w,abs(h));
%     xlabel('频率/Hz');
%     ylabel('幅值');
%     title('巴特沃斯低通滤波器幅度特性');
%     grid on;
for iter = 1 : symbols
    y = x_qam(1, (iter-1)*length(t2)+1:iter*length(t2));
    y_len = length(y);
    detect = zeros(1,y_len);         % 预置检测信号
    distance = zeros(1,M);              % 解调：距离检测
    I = y.*cos(w_qam*t2)*2;
    Q = -y.*sin(w_qam*t2)*2;
    
    %设计低通滤波器

    I=filter(num,den,I);
    Q=filter(num,den,Q);

    for i = y_len : y_len
        for j = 1 : M
            distance(j) = sqrt((I(i)-constell_diag(j,1))^2 + (Q(i)-constell_diag(j,2))^2); %接收信号到所有星座点的距离
        end
        pos = find(distance == min(distance)); % 最小距离星座点的位置
        detect(i) = pos(1) - 1; % 解调后的符号（十进制）
        y_qam(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end
end

