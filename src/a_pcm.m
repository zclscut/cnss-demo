function y=a_pcm(x,a)   
t=1/a;                  
for i=1:length(x)
    if x(i)>=0          
        if (x(i)<=t)
            y(i)=(a*x(i))/(1+log(a));
        else
            y(i)=(1+log(a*x(i)))/(1+log(a)); 
        end
    else
        if (x(i)>=-t)
            y(i)=-(a*-x(i))/(1+log(a));     
        else
            y(i)=-(1+log(a*-x(i)))/(1+log(a));
        end
    end
end
