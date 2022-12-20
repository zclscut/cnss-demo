%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%(1).PCM sampling/quantization/encoding of 1min analog signal
% (i).Non-uniform quantization is performed with A-rate
% (ii).A-rate quantization encoding gives an 8bit code
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
[x,fs]=audioread('music.wav');
% sound(x,fs)%play the music before processing
N=length(x);
t=0:1/fs:(N-1)/fs;

% noise_high=0.1*sin(2*pi*5000*t)%5kHz high frequency noise
% noise_low=sin(2*pi*100*t)%100Hz low frequency noise
x1=x(:,1);%extract the 1st sound track of x
start=fs*10;%play from the very 10s
inteval=150;%the length of interval of the what "plot" function displays
% figure
% subplot(2,1,1);
% plot(x1(start:start+inteval,1));
% grid;
% subplot(2,1,2);
% stem(x1(start:start+inteval,1));
% %what we process in the sampling and quantization actually
% grid;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%(2).Baseband modulation/display waveform
%1.16FSK/16QAM modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


test_in=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1];
cut=4;%group every 4 numbers without overlapping
test_in=reshape(test_in,cut,[]);%[]Automatically calculates dimension sizes
fsk16=[];
t=0:0.01:1;
symbols=8;%display 1~8 symbols
w_fsk=2*pi;%1 is the period of sin function if \omega=2*pi
for i = 1:symbols
    num=bin2dec(num2str(test_in(:,i)'));%4-bit array transfered into decimal number，then we modulate the 16-bit information by 16fsk/16qam
    fsk16=[fsk16,sin((num+1)*w_fsk*t)];%frequency modulation by (num+1)
end

figure
subplot(2,1,1)
carrier=repmat(sin(w_fsk*t)',symbols,1);
plot(carrier);
title('载波波形')
subplot(2,1,2)
plot(fsk16);%display 16fsk waveform
title('16fsk调制波形')


%16QAM constellation diagram
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
%energy normalization, the norm of (2,2) is transfered into 1
constell_diag=constell_diag./2/sqrt(2);
qam16=[];
t=0:0.01:1;
w_qam=2*pi*4;%period is 1/4,for better displayment，we set anolog period×4=symbol period
symbols=4;%display the 1~4 symbols
for i = 1:symbols
    num=bin2dec(num2str(test_in(:,i)'));%4-bit array transfered into decimal number，then we modulate the 16-bit information by 16fsk/16qam
    qam_sig=constell_diag(num+1,1)*cos(w_qam*t)+constell_diag(num+1,2)*sin(w_qam*t);
    qam16=[qam16,qam_sig];
end

figure
subplot(2,1,1)
carrier=repmat(cos(w_qam*t)',symbols,1);
plot(carrier);
title('载波波形')
subplot(2,1,2)
plot(qam16);%display QAM16 waveform
title('16qam调制波形')





%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%(3).Gaussian channel transmission, signal demodulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%




















%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%(4).Sampling judgment/calculate the error rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%



























