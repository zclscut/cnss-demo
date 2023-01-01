function output=rebuild(rec,dots)
    k=floor(size(rec,2)/dots/2);
    a=zeros(k,1);
    for i=1:k
        a(i)=rec(1,i*dots*2-dots)*128+rec(2,i*dots*2-dots)*64+rec(3,i*dots*2-dots)*32+rec(4,i*dots*2-dots)*16+...
            rec(1,i*dots*2)*8+rec(2,i*dots*2)*4+rec(3,i*dots*2)*2+rec(4,i*dots*2)*1;
    end
    output=a;