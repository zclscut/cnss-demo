%sigDm:解调后信号 pcm:用于比对的pcm码 sigOriCut:原模拟信号截取出的一段
function err=part4(sigDm,pcm,cutBg,sigOriCut,fs,smooth,ds,DmMethod)
    sigRe=rebuild(sigDm,smooth);
    err=errorcnt(pcm,sigRe);
    err=roundn(err*100,-2);
    
    sigDq=dquantization(sigRe);
    
    cutPoint=length(sigOriCut);
    t1=ds:ds:cutPoint;t2=1:cutPoint;
    sigIp=interp1(t1,sigDq(floor(cutBg/ds)+1:floor((cutBg+cutPoint)/ds)),t2,'linear');
    figure;
    plot(t2/fs,sigIp,'-.',t2/fs,sigOriCut);
    title(DmMethod);xlabel('t');ylabel('Amplitude');legend('ReceiveMusic','OriginMusic');
    annotation('textbox',[.9 .5 .1 .2],'String',['Error Rate=',newline,num2str(err),'%'],'EdgeColor','none');


