% VerifLattice_decoded2.m
% extract data from hdf5 and disembed lattice
% save datas disembedded in hdf5 file and .csv files 
% outputDirectory : Directory output
% filename : name of the file to be decoded
% n : index of datas to be decoded 
% name_data : name of the data in the hdf5 file
% seed : base seed to calculate the datas format 
% axisOn : indicates if axis are on (true) or not
%   if on, saved as svg
%   if off, saved as png
function y_decoded=verifLattice_decoded2(outputDirectory,filename,n,name_data, seed,axisOn)
    Y1=[1 0];Y2=[0 1];
    L=1;
    L1=L;
    L2=L;
    Es=210000;  % Elasticity modulus
    
    mat_lin=readHdf5Lattice(filename,name_data,n,seed);

    [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed);
    nbeams=numel(Tb);
    nnodes=length(nodes);

    

    %% save the same datas in csv format
    %% TODO ajouter la sauvegarde de 	MATf* Material = new MATf();
	% MATf* Y1 = new MATf();
	% MATf* Y2 = new MATf();
	% float L1,L2;
    dirDisembeddedCsv=outputDirectory;
    Material=Es*ones(nbeams,1);
  
    SaveDenseFloatMatrix(dirDisembeddedCsv+"L1.csv",L1);
    SaveDenseFloatMatrix(dirDisembeddedCsv+"L2.csv",L2);
    SaveDenseFloatMatrix(dirDisembeddedCsv+"Y1.csv",Y1');
    SaveDenseFloatMatrix(dirDisembeddedCsv+"Y2.csv",Y2');
    SaveDenseFloatMatrix(dirDisembeddedCsv+"Material.csv",Material);
    SaveDenseFloatMatrix(dirDisembeddedCsv+"Tb.csv",Tb);
    SaveDenseFloatMatrix(dirDisembeddedCsv+"nodes.csv",nodes);
    SaveDenseIntMatrix(dirDisembeddedCsv+"Ob.csv",Ob);
    SaveDenseIntMatrix(dirDisembeddedCsv+"Eb.csv",Eb);
    SaveDenseIntMatrix(dirDisembeddedCsv+"delta1.csv",delta1);
    SaveDenseIntMatrix(dirDisembeddedCsv+"delta2.csv",delta2);
    
    if (axisOn==1.0)
        set(gcf,'position',[0,0,500,500])
        PlotLattice(nodes,nbeams,Ob,Eb,Tb,delta1,delta2,L1,L2)
        axis on;
        saveas(gcf,dirDisembeddedCsv+"LatticeBase","svg")
    else
        set(gcf,'position',[0,0,200,200])
        PlotLattice(nodes,nbeams,Ob,Eb,Tb,delta1,delta2,L1,L2)
        axis off;
        saveas(gcf,dirDisembeddedCsv+'LatticeBase','png')
    end

    clf;    % clear figure
    
    nnodes=numel(nodes)/2;

    Elast=Es*ones(1,nbeams) ; % matrix size (1 x nbeams)Value of elastic modulus
    [MExtracted,MS4,rho]=homogenization(Tb,L1,L2,Y1,Y2,...                   
    nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,Elast);
    mech=mechanic_moduli(MS4);
    y_decoded=[mech([1,2,3,6]),rho];

    fileID = fopen(dirDisembeddedCsv+"decoded_results.txt",'w');
    fprintf(fileID,"Homogenized values\n");
    fprintf(fileID,"[   Ex   ,     Ey  ,   Gxy   ,  nuyx   ,   rho*  ]\n");
    fprintf(fileID," %8.2f,",y_decoded);
    disp(["y decoded:",y_decoded]);
    fclose(fileID);
end