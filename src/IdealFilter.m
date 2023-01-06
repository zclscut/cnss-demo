function y = IdealFilter(x, fs, fpass, fstop)
%IdealFilter 用于设计带通滤波器
%   x: 输入信号; fs: 采样率; fpass: 通带起始频率; fstop: 通带截止频率

fl = fpass;
fh = fstop;
wp=[fl/(fs/2) fh/(fs/2)];
N=128; 
b=fir1(N,wp,blackman(N+1)); 
y = filtfilt(b,1,x); 
end

