%judgement
function [B,m1,n1]=judge(I,m,n)
if I>=m&&I<(m+n)/2
    B='0';
    m1=m;
    n1=(m+n)/2;
else
    B='1';
    m1=(m+n)/2;
    n1=n;
end