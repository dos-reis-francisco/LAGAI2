% verifEmbedding.m

function verifEmbedding(filename,n,seed) 
    Y1=[1 0];Y2=[0 1];
    L1=1;
    L2=1;
    Es=210000;  % Elasticity modulus
    name_data='/train_data';
    name_y='/train_y';
    filesave='embed_layer.txt';
    [mat_lin, y_hdf5]=readHdf5(filename,name_data,name_y,n,seed);
    print_embedded(filesave,seed,mat_lin);
    [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed);

    nbeams=numel(Tb);
    Elast=Es*ones(1,nbeams) ; % matrix size (1 x nbeams)Value of elastic modulus
    
%     % update ct
%     ct=EvaluateCt2(Tb,nodes,nbeams,Ob,Eb,delta1,delta2,L1,L2,rhov);
%     Tb=ct*Tb;
    
    nnodes=numel(nodes)/2;
    
    [MExtracted,MS4]=homogenization(Tb,L1,L2,Y1,Y2,...                   
    nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,Elast);
    mechanic_moduli(MS4)
    y_hdf5
end