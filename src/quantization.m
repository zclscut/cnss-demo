function pcm_code = quantization(m)
C=[0 1/256 1/128 1/64 1/32 1/16 1/4 1/2 1];
for i=1:length(m)
    if m(i)>0 % polarity bit
        B1='1';
    else
        B1='0';
    end
    m(i)=abs(m(i));
    for j=1:length(C);
        if m(i)>=C(j) && m(i)<=C(j+1)
            L=j-1;
            L1=dec2bin(L,3);
            % segments bits
            B2=L1(1);
            B3=L1(2);
            B4=L1(3);
            break;
        end
    end
    a=C(L+1);
    b=C(L+2);
    % inner segments bits
    [B5,a1,b1]=judge(m(i),a,b);
    [B6,a2,b2]=judge(m(i),a1,b1);
    [B7,a3,b3]=judge(m(i),a2,b2);
    [B8,a4,b4]=judge(m(i),a3,b3);
    code = [B1,B2,B3,B4,B5,B6,B7,B8];
    code_dec = bin2dec(code);
    pcm_code(i) = code_dec;
end
end

