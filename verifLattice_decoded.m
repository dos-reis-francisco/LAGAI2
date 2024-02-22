% verifLattice_decoded.m

function verifLattice_decoded(filename,n,name_data,name_y, seed)
    Y1=[1 0];Y2=[0 1];
    L=1;
    L1=L;
    L2=L;
    Es=210000;  % Elasticity modulus
    
    mat_lin=readHdf5Lattice(filename,name_data,n,seed);
    size_data=5;
    y=h5read(filename,name_y,(n-1)*size_data+1,size_data);

    [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed);

    nbeams=numel(Tb);
    
    Elast=Es*ones(1,nbeams) ; % matrix size (1 x nbeams)Value of elastic modulus

    PlotLattice(nodes,nbeams,Ob,Eb,Tb,delta1,delta2,L1,L2)
    
    nnodes=numel(nodes)/2;
    
    [MExtracted,MS4,rho]=homogenization(Tb,L1,L2,Y1,Y2,...                   
    nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,Elast);
    mech=mechanic_moduli(MS4);
    y_decoded=[mech([1,2,3,6]),rho];
    disp(["y decoded :",y_decoded]);
    error=y'-y_decoded;
    errorPerCent=sum((error./y')*100);
    if (errorPerCent<1e-3)
        disp(["No error on lattice ",n]);
    else
        disp(['errors :',errorPerCent,"on lattice",n]);
    end
end