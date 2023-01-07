
%slCharacterEncoding('GBK');
%%解决中文乱码问题
%https://www.cnblogs.com/leoking01/p/8269516.html

close all;
clear all;
slCharacterEncoding('UTF-8');

[x,fs_music]=audioread('music.wav');
% sound(x,fs)%播放原音
x1=x(:,1);%抽取x第1声道

cut=10;%截取10s测试
% x1=x1(1:fs_music*cut);
N=length(x);
k=floor(N/cut/fs_music);
err1=0;err2=0;err3=0;
for i=1:k
    [suberr1,suberr2,suberr3]=submain(x1((i-1)*fs_music*cut+1:i*fs_music*cut),i,fs_music);
    err1=err1+suberr1;err2=err2+suberr2;err3=err3+suberr3;
end

err1=err1/k;err2=err2/k;err3=err3/k;
