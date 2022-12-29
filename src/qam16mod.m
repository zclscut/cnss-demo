function waveform= qam16mod(pcm_code,symbol_rate,freq_carrier,smooth,is_figure,plot_start)
    %16QAM星座图
    constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
    %能量归一化,(2,2)归一化模为1
    constell_diag=constell_diag./2/sqrt(2);

    tao=1/smooth;
    l_pcm=length(pcm_code);
    t2=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
    w_qam=2*pi*freq_carrier;%周期为
    qam16=zeros(1,l_pcm*(1/tao)*2);
    for i=0:l_pcm-1
        binstr= dec2bin(pcm_code(i+1),8);%254='11111110'
        num=bin2dec(binstr(1:4));%'1111'=15
        qam16(i*(1/tao*2)+1:(i+0.5)*(1/tao*2))=constell_diag(num+1,1)*cos(w_qam*t2)-constell_diag(num+1,2)*sin(w_qam*t2);%用(num+1)进行频率调制
        num=bin2dec(binstr(5:8));%'1110'=14
        qam16((i+0.5)*(1/tao*2)+1:(i+1)*(1/tao*2))=constell_diag(num+1,1)*cos(w_qam*t2)-constell_diag(num+1,2)*sin(w_qam*t2);%用(num+1)进行频率调制
    end
    
    if is_figure
        figure;
        i=plot_start;
        t2=0:tao/symbol_rate:1/symbol_rate*4-tao/symbol_rate;
        plot(t2,qam16(i*(1/tao*2)+1:(i+2)*(1/tao*2)));
        xlabel('时间/s')
        title('16QAM调制')
        pcm_code(i+1:i+2)
    end
    waveform=qam16;
end
