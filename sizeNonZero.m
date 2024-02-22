% sizeNonZero.m
% Dos Reis F. 
% 10.02.2023
% return the size of the first non zero elements of an array
function n=sizeNonZero(TFACESTRAITEES)
    for n=1:size(TFACESTRAITEES,1)
        if (TFACESTRAITEES(n)==0)
            n=n-1;
            break;
        end
    end

end