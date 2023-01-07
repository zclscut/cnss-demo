%sigDm:解调后信号 pcm:用于比对的pcm码 cutBg:原模拟信号截取起始点 sigOriCut:原模拟信号截取出的一段
%fs: 原模拟信号采样频率 smooth:每个载波周期的数据点数 ds:下采样率 DmMethod:调制解调方式名称 bj:是否绘制对比图
function err=part4(sigDm,pcm,cutBg,sigOriCut,fs,smooth,ds,DmMethod,bj)
    sigRe=rebuild(sigDm,smooth);%sigRe:恢复成pcm码
    err=errorcnt(pcm,sigRe);
    err=roundn(err*100,-2);%err:百分制误码率
    
    sigDq=dquantization(sigRe);%sigDq:去量化，恢复成采样信号
    
    cutPoint=length(sigOriCut);
    t1=ds:ds:cutPoint;t2=1:cutPoint;
    sigIp=interp1(t1,sigDq(floor(cutBg/ds)+1:floor((cutBg+cutPoint)/ds)),t2,'linear');%sigIp:线性内插，恢复成模拟信号
    if bj==1
        figure;
        plot(t2/fs,sigIp,'-.',t2/fs,sigOriCut);%前后模拟信号对比图
        title(DmMethod);xlabel('t');ylabel('Amplitude');legend('ReceiveMusic','OriginMusic');
        annotation('textbox',[.9 .5 .1 .2],'String',['Error Rate=',newline,num2str(err),'%'],'EdgeColor','none');
    end
