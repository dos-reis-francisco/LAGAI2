function ESOL(nelx,nely,volfrac,er,rmin,ctp)
 %% INITIALIZATION
vol = 1; change = 1; ij = 0;
x = ones(nely,nelx);
%% MATERIAL PROPERTIES
 E0 = 1; nu = 0.3;
 %% PREPARE FINITE ELEMENT ANALYSIS
A11 = [12 3 -6 -3; 3 12 3 0; -6 3 12 -3; -3 0 -3 12];
A12 = [-6 -3 0 3; -3 -6 -3 -6; 0 -3 -6 3; 3 -6 3 -6];
B11 = [-4 3 -2 9; 3 -4 -9 4; -2 -9 -4 -3; 9 4 -3 -4];
B12 = [ 2 -3 4 -9; -3 2 9 -2; 4 9 2 3; -9 -2 3 2];
KE = 1/(1-nu^2)/24*([A11 A12;A12' A11]+nu*[B11 B12;B12' B11]);
nodenrs = reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1,nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
iK = reshape(kron(edofMat,ones(8,1))',64*nelx*nely,1);
jK = reshape(kron(edofMat,ones(1,8))',64*nelx*nely,1);
%% DEFINE LOADS AND SUPPORTS
switch(ctp)
    case 1 % HALF-MBB BEAM
        F = sparse(2,1,-1,2*(nely+1)*(nelx+1),1);
        fixeddofs = union(1:2:2*(nely+1), 2*(nely+1)*(nelx+1));
    case 2 % CANTILEVER
        F = sparse(2*(nely+1)*(nelx+1)-nely,1,-1,2*(nely+1)*(nelx+1),1);
        fixeddofs = (1:2*(nely+1));
    case 3 % HALF-WHEEL
        F = sparse(2*(nely+1)*(nelx/2+1),1,-1,2*(nely+1)*(nelx+1),1);
        fixeddofs = union(2*nely+1:2*(nely+1), 2*(nely+1)*(nelx+1));
end
U = zeros(2*(nely+1)*(nelx+1),1);
alldofs = (1:2*(nely+1)*(nelx+1));
freedofs = setdiff(alldofs,fixeddofs);
%% PREPARE FILTER
iH = ones(nelx*nely*(2*(ceil(rmin)-1)+1)^2,1);
jH = ones(size(iH)); sH = zeros(size(iH)); k =0;
for i1 = 1:nelx
    for j1 = 1:nely
        e1 = (i1-1)*nely+j1;
        for i2 = max(i1-(ceil(rmin)-1),1):min(i1+(ceil(rmin)-1),nelx)
            for j2 = max(j1-(ceil(rmin)-1),1):min(j1+(ceil(rmin)-1),nely)
                e2 = (i2-1)*nely+j2; k = k+1; iH(k) = e1;jH(k) = e2;
                sH(k) = max(0,rmin-sqrt((i1-i2)^2+(j1-j2)^2));
            end
        end
    end
end
H = sparse(iH,jH,sH); Hs = sum(H,2);
%% START ITERATION
while change > 0.001
    ij = ij + 1; vol = max(vol*(1-er), volfrac);
    if ij > 1; olddc = dc; end
    %% FE-ANALYSIS
    sK = reshape(KE(:)*max(1e-9,x(:))'*E0,64*nelx*nely,1);
    K = sparse(iK,jK,sK); K = (K+K')/2;
    U(freedofs) = K(freedofs,freedofs)\F(freedofs);
    %% OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
    ce = reshape(sum((U(edofMat)*KE).*U(edofMat),2),nely,nelx);
    c(ij) = sum(sum((x.*E0).*ce));
    dc = (x.*E0).*ce;
    %% FILTERING/MODIFICATION OF SENSITIVITIES
    dc(:) = H*dc(:)./Hs;
    if ij > 1; dc = (dc+olddc)/2.; end
    %% PRINT RESULTS & PLOT DENSITIES
    if ij > 10; change =abs(sum(c(ij-9:ij-5))-sum(c(ij-4:ij)))/sum(c(ij-4:ij)); end
    fprintf('It.:%3i Obj.:%8.4f Vol.:%4.3f ch.:%4.3f\n',(ij),c(ij),mean(x(:)),change);
    colormap(gray); imagesc(-x); axis equal; axis tight; axis off; pause(1e-6);
    %% OPTIMALITY CRITERIA UPDATE OF DESIGNVARIABLES
    l1 = min(dc(:)); l2 = max(dc(:));
    while (l2-l1)/(l1+l2) > 1.0e-9
        th = (l1+l2)/2.0;
        x = max(0,sign(dc-th)) ;
        if (mean(x(:)) - vol > 0) 
            l1 = th;
        else
            l2 = th;
        end
    end
end
