%sigDm:解调后信号 pcm:用于比对的pcm码 sigOriCut:原模拟信号截取出的一段
function [err,sigDq]=part4(sigDm,pcm,cutBg,sigOriCut,smooth,ds)
    sigRe=rebuild(sigDm,smooth);
    err=errorcnt(pcm,sigRe);
    
    sigDq=dquantization(sigRe);
    
    cutPoint=length(sigOriCut);
    t1=ds:ds:cutPoint;t2=1:cutPoint;
    sigIp=interp1(t1,sigDq(floor(cutBg/ds)+1:floor((cutBg+cutPoint)/ds)),t2,'linear');
    figure;
    plot(t2,sigIp,t2,sigOriCut);

