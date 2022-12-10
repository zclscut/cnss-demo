function signal = dquantization( pcm_code )
C=[0 1/256 1/128 1/64 1/32 1/16 1/4 1/2 1];
for i=1:length(pcm_code)
    code = pcm_code(i);
    code = dec2bin(code, 8);
    segment_code = [code(2),code(3),code(4)];
    segment = bin2dec(segment_code); 
    inner_segment_code = [code(5),code(6),code(7),code(8)];
    inner_segment = bin2dec(inner_segment_code);
    data = C(segment+1)+(C(segment+2)-C(segment+1))/16*inner_segment;
    if code(1)=='0'
        data = -data;
    end
    signal(i) = data;
    
end


end

