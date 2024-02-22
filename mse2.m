% calculate mse

function D=mse2(A,B)
    sizeA=length(A);
    sizeB=length(B);
    if (sizeA~=sizeB)
        "error size for mse"
    end
    normA=sqrt(sum(A.^2));
    normB=sqrt(sum(B.^2));
    A=A/normA;
    B=B/normB;
    C=A-B;
    D=sum((C.^2)/sizeA);
end

    