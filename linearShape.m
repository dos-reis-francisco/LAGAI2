%linearShape.m 
% convert a matrix 3D in MATLAB order to a linear matrix reshapable in
% PYTHON tensorflow order
% li: lines
% co: columns
% la: layers

function Mat2=linearShape(Mat,li,co,la)
% convert a 3D Matrix in 1D Matrix  
    Mat2=zeros(li*co*la,1);    
    
    for l=1:li    
        for c=1:co  
            for p=1:la
                Mat2((l-1)*la*co+(c-1)*la+p)=Mat(l,c,p);
            end
        end
    end
end