%%1min模拟信号的采样量化
clear all
[x,fs]=audioread('music.wav');
sound(x,fs)%播放原音
N=length(x);
t=0:1/fs:(N-1)/fs;

% noise_high=0.1*sin(2*pi*5000*t)%5kHz高频噪声
% noise_low=sin(2*pi*100*t)%100Hz低频噪声
x1=x(:,1);%抽取x第1声道
start=fs*10;%从第10秒开始播放
inteval=150;%截取长度、
figure
subplot(2,1,1);
plot(x1(start:start+inteval,1));
grid;
subplot(2,1,2);
stem(x1(start:start+inteval,1));%采样量化处理对象
grid;

%%基带调制并显示波形





%%高斯信道传输，信号解调




%%抽样判决，统计误码率



