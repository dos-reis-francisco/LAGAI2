% ExtractLayer.m
% extract data from hdf5 and disembed lattice
% save datas disembedded in hdf5 file and .csv files 
% outputDirectory : Directory output
% filename : name of the file to be decoded
% n : index of datas to be decoded 
% name_data : name of the data in the hdf5 file
% seed : base seed to calculate the datas format 
% nFilter : number of layers saved 
function sizeMat=ExtractLayer(outputDirectory,filename,n,name_data, seed,nFilter)
    Y1=[1 0];Y2=[0 1];
    L=1;
    L1=L;
    L2=L;
    Es=210000;  % Elasticity modulus
    
    matLins=readHdf5Lattice2(filename,name_data,n,seed,nFilter);
    matLins=matLins/nFilter;
    sizeMat=numel(matLins)/nFilter;
    dirDisembeddedCsv=outputDirectory;

    for i=1:nFilter
        mat_lin=matLins(sizeMat*(i-1)+1:sizeMat*i);
        dirDisembeddedCsv2=outputDirectory+string(i);
        
        mkdir(dirDisembeddedCsv2);
        dirDisembeddedCsv2=dirDisembeddedCsv2+"/";
        [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed);
        nbeams=numel(Tb);
        nnodes=length(nodes);
        Material=Es*ones(nbeams,1);
      
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"L1.csv",L1);
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"L2.csv",L2);
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"Y1.csv",Y1');
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"Y2.csv",Y2');
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"Material.csv",Material);
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"Tb.csv",Tb);
        SaveDenseFloatMatrix(dirDisembeddedCsv2+"nodes.csv",nodes);
        SaveDenseIntMatrix(dirDisembeddedCsv2+"Ob.csv",Ob);
        SaveDenseIntMatrix(dirDisembeddedCsv2+"Eb.csv",Eb);
        SaveDenseIntMatrix(dirDisembeddedCsv2+"delta1.csv",delta1);
        SaveDenseIntMatrix(dirDisembeddedCsv2+"delta2.csv",delta2);

        nbeams=numel(Tb);
        nnodes=length(nodes);
        set(gcf,'position',[0,0,200,200])
        PlotLattice2(nodes,nbeams,Ob,Eb,Tb,delta1,delta2,L1,L2)
        axis off;
        figFile=dirDisembeddedCsv+"Layer"+string(i);
        saveas(gcf,figFile,'png');
        clf;
    end
end