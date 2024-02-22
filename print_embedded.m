%print_embedded.m
% print an embedded lattice in a formatted text file 
% matrix_embedded.txt

function print_embedded(filename, seed,embeddedLattice)
    dim=seed*2+4;   
    fileID = fopen(filename,'w');
    for lay=1:12    
        fprintf(fileID,"layer : %d\n",lay);
        for li=1:dim
            for col=1:dim
                fprintf(fileID,"%+1.2f ",embeddedLattice((li-1)*dim*12+(col-1)*12+lay)); % CHG
            end
            fprintf(fileID,"\n");
        end
    end
    
end
