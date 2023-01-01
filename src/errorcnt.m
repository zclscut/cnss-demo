function ratio=errorcnt(org,rec)
    l_arr=length(org);
    errcnt=0;
    for i=1:l_arr
        if org(i)~=rec(i)
            errcnt=errcnt+1;
        end
    end
    ratio=errcnt/l_arr;