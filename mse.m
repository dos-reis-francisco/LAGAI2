% calculate mse

function D=mse2(A,B)
    sizeA=size(A);
    sizeB=size(B);
    if (sizeA!=sizeB)
        "error size for mse"
    end
    C=A-B;
    D=(C^2)/sizeA;
end

    