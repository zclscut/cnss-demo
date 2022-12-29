function waveform= fsk16mod(pcm_code,symbol_rate,freq_carrier,smooth,is_figure,plot_start)
    tao=1/smooth;
    l_pcm=length(pcm_code);
    t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
    w_fsk=2*pi*freq_carrier;%周期为
    fsk16=zeros(1,l_pcm*(1/tao)*2);
    for i=0:l_pcm-1
        binstr= dec2bin(pcm_code(i+1),8);%254='11111110'
        num=bin2dec(binstr(1:4));%'1111'=15
        fsk16(i*(1/tao*2)+1:(i+0.5)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%用(num+1)进行频率调制
        num=bin2dec(binstr(5:8));%'1110'=14
        fsk16((i+0.5)*(1/tao*2)+1:(i+1)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%用(num+1)进行频率调制
    end
    
    
    %验证调制正确性
    if is_figure
        figure;
        i=plot_start;%i=1e4
        t1=0:tao/symbol_rate:1/symbol_rate*4-tao/symbol_rate;
        plot(t1,fsk16(i*(1/tao*2)+1:(i+2)*(1/tao*2)));%输出3fc,10fc,5fc,2fc,即对应八进制02941(oct),由于0对应fc
        xlabel('时间/s')
        title('16FSK调制')
        pcm_code(i+1:i+2)%输出 41(dec)=029(oct),65(dec)=041(oct)
    end
    waveform=fsk16;
end