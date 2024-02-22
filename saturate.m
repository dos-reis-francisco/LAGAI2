%saturate.m
function M1=saturate(M,minM,maxM)
M1=M;
[li co]=size(M);
for i=1:li
    for j=1:co
        if (M(i,j)<minM) 
            M1(i,j)=minM;
        end
        if(M(i,j)>maxM)
            M1(i,j)=maxM;
        end
    end
end
end
