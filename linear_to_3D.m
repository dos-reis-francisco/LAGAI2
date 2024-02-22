function Mat3D=linear_to_3D(mat_lin,seed)
% convert a 1D Matrix to 3D Matrix  
    Mat3D=zeros((seed*2+4),(seed*2+4),12);
    size_c=12; size_l=(seed*2+4)*12;
    
    for l=1:(seed*2+4)    
        for c=1:(seed*2+4)
            il=l-1; ic=c-1;
            base=il*size_l+ic*size_c+1;
            Mat3D(l,c,:)=mat_lin(base:(base+11));
        end
    end
end