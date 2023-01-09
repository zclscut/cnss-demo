clear
pcm1=[1 16];
l_sam=2;
tao=0.01;
t1=0:tao:1-tao;
w_fsk=2*pi*1;%周期为
fsk16=zeros(1,l_sam*(1/tao)*2);
for i=0:l_sam-1
    binstr= dec2bin(pcm1(i+1),8);%254='11111110'
    num=bin2dec(binstr(1:4))%'1111'=15
    fsk16(i*(1/tao*2)+1:(i+0.5)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%用(num+1)进行频率调制
    num=bin2dec(binstr(5:8))%'1110'=14
    fsk16((i+0.5)*(1/tao*2)+1:(i+1)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%用(num+1)进行频率调制
end

i=0;
t1=0:tao:1*4-tao;
plot(t1,fsk16(i*(1/tao*2)+1:(i+2)*(1/tao*2)));
pcm1(i+1:i+2)