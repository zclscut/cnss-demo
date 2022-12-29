%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%一、1min模拟信号的PCM采样量化编码
% 1.用a率进行非均匀量化
% 2.量化编码后一个电平得到8bit码字
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
[x,fs]=audioread('music.wav');
% sound(x,fs)%播放原音
N=length(x);
t=0:1/fs:(N-1)/fs;

% noise_high=0.1*sin(2*pi*5000*t)%5kHz高频噪声
% noise_low=sin(2*pi*100*t)%100Hz低频噪声
x1=x(:,1);%抽取x第1声道
start=fs*10;%从第10秒开始播放
inteval=150;%截取长度
% figure
% subplot(2,1,1);
% plot(x1(start:start+inteval,1));
% grid;
% subplot(2,1,2);
% stem(x1(start:start+inteval,1));%采样量化处理对象
% grid;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%二、基带调制并显示波形
%1.16FSK和16QAM调制
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


test_in=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1];
cut=4;%将每4位切片
test_in=reshape(test_in,cut,[]);%[]自动计算维度大小
fsk16=[];
t1=0:0.001:1;
symbols=4;%显示1~8个码字
w_fsk=2*pi*4*10;%周期为1
for i = 1:symbols
    num=bin2dec(num2str(test_in(:,i)'));%读取4位数组转化为十进制，再对16bit信息位进行16fsk调制或者16qam调制
    fsk16=[fsk16,sin((num+1)*w_fsk*t1)];%用(num+1)进行频率调制
end
% 
% figure
% subplot(2,1,1)
% carrier=repmat(sin(w_fsk*t)',symbols,1);
% plot(carrier);
% title('载波波形')
% subplot(2,1,2)
% plot(fsk16);%画出16fsk的波形
% title('16fsk调制波形')


%16QAM星座图
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
%能量归一化,(2,2)归一化模为1
constell_diag=constell_diag./2/sqrt(2);
qam16=[];
t=0:0.005:1;
w_qam=2*pi*4*10;%周期为1/4,为了可视化更好看，使模拟周期×4=码元周期
symbols=4;%显示1~4个码字
for i = 1:symbols   
    num=bin2dec(num2str(test_in(:,i)'));%读取4位数组转化为十进制，再对16bit信息位进行16fsk调制或者16qam调制
    qam_sig=constell_diag(num+1,1)*cos(w_qam*t)-constell_diag(num+1,2)*sin(w_qam*t);
    qam16=[qam16,qam_sig];%用(num+1)进行频率调制
end

% figure
% subplot(2,1,1)
% carrier=repmat(cos(w_qam*t)',symbols,1);
% plot(carrier);
% title('载波波形')
% subplot(2,1,2)
% plot(qam16);%画出16qam的波形
% title('16qam调制波形')





%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%三、高斯信道传输，信号解调
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 高斯信道传输
x_qam = qam16;
x_fsk = fsk16;
SNR_indB = 10;
% x_qam = awgn(x_qam, SNR_indB);
% x_fsk = awgn(x_fsk, SNR_indB);

% 16QAM解调
M = 16;
y_qam = zeros(4, length(x_qam));
for iter = 1 : symbols
    y = x_qam(1, (iter-1)*length(t)+1:iter*length(t));
    y_len = length(y);
    detect = zeros(1,y_len);         % 预置检测信号
    distance = zeros(1,M);              % 解调：距离检测
    I = y.*cos(w_qam*t)*2;
    Q = -y.*sin(w_qam*t)*2;
    
    %设计低通滤波器
    Fs=200;
    fp1=40;fs1=50;rs=30;rp=0.5;
    wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %通带边界频率
    ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %阻带边界频率
    [n,wn]=buttord(wp,ws,rp,rs,'s'); %滤波器的阶数n和-3dB归一化截止频率Wn
    [b,a]=butter(n,wn,'s');
    [num,den]=bilinear(b,a,Fs);  %双线性变换
    I=filter(num,den,I);
    Q=filter(num,den,Q);
    [h,w]=freqz(num,den,100,Fs);
%     figure(1)
%     subplot(4,1,1);
%     plot(w,abs(h));
%     xlabel('频率/Hz');
%     ylabel('幅值');
%     title('巴特沃斯低通滤波器幅度特性');
%     grid on;
    for i = 1 : y_len
        for j = 1 : M
            distance(j) = sqrt((I(i)-constell_diag(j,1))^2 + (Q(i)-constell_diag(j,2))^2); %接收信号到所有星座点的距离
        end
        pos = find(distance == min(distance)); % 最小距离星座点的位置
        detect(i) = pos(1) - 1; % 解调后的符号（十进制）
        y_qam(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end

%16FSK解调
%设计低通滤波器
Fs=1000;
fp1=25;fs1=40;rs=30;rp=0.5;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %通带边界频率
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %阻带边界频率
[n,wn]=buttord(wp,ws,rp,rs,'s'); %滤波器的阶数n和-3dB归一化截止频率Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %双线性变换
y_fsk = zeros(4, length(x_fsk));
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % 预置检测信号
    distance = zeros(1,M);              % 解调：距离检测
    for j = 1 : M
        y_ = y.*sin(j*w_fsk*t1);       
        y_=filter(num,den,y_);
        [h,w]=freqz(num,den,100,Fs);
        distance(j) = mean(abs(y_));        
    end
    for i = 1 : y_len                
        pos = find(distance == max(distance)); % 择大判决
        detect(i) = pos(1) - 1; % 解调后的符号（十进制）
        y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
    

    detect(y_len);
end













%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%四、抽样判决，统计误码率
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%



























