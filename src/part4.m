%sigDm:解调后信号 pcm:用于比对的pcm码 sigOriCut:原模拟信号截取出的一段
function err=part4(sigDm,pcm,sigOriCut)
    sigRe=rebuild(sigDm,500);
    err=errorcnt(pcm,sigRe);
    
    sigDq=dquantization(sigRe);
    
    cutPoint=length(sigOriCut);
    t1=4:4:cutPoint;t2=1:cutPoint;
    sigIp=interp1(t1,sigDq,t2,'linear');
    figure;
    plot(t2,sigIp,t2,sigOriCut);

