function y = IdealFilter(x, fs, fpass, fstop)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

fl = fpass;
fh = fstop;
wp=[fl/(fs/2) fh/(fs/2)];
N=128; 
b=fir1(N,wp,blackman(N+1)); 
y = filtfilt(b,1,x); 
end

