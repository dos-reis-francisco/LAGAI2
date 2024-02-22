% VerifLattice_decoded3.m
% extract data from hdf5 and disembed lattice
% filename : name of the file to be decoded
% n : index of datas to be decoded 
% name_data : name of the data in the hdf5 file
% seed : base seed to calculate the datas format 
%
function y_decoded=verifLattice_decoded3(filename,n,name_data, seed)
    Y1=[1 0];Y2=[0 1];
    L=1;
    L1=L;
    L2=L;
    Es=210000;  % Elasticity modulus
    
    mat_lin=readHdf5Lattice(filename,name_data,n,seed);

    [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed);
    nbeams=numel(Tb);
    nnodes=length(nodes);
    
    nnodes=numel(nodes)/2;

    Elast=Es*ones(1,nbeams) ; % matrix size (1 x nbeams)Value of elastic modulus
    [MExtracted,MS4,rho]=homogenization(Tb,L1,L2,Y1,Y2,...                   
    nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,Elast);
    mech=mechanic_moduli(MS4);
    y_decoded=[mech([1,2,3,6]),rho];
end