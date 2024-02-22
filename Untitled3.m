[Kh,Exh,Eyh,nuyxh,nuxyh,muxyh,etaxxyh,etayxyh,etaxyxh,etaxyyh] = mechanic_moduli(MS4(1,:));
mechanic_homogenized=[Kh,Exh,Eyh,nuyxh,nuxyh,muxyh,etaxxyh,etayxyh,etaxyxh,etaxyyh];
save_matrix("mechanic_homogenized.csv",mechanic_homogenized);

basis_vectors=[L1 L2;Y1;Y2];
save_matrix("basis_vectors.csv",basis_vectors);

algorithm_values=[nchromosomes nkeep seed nkmax mutrate ntvalue minc(1,nkmax)];
save_matrix("algorithm_values.csv",algorithm_values);
save_matrix("nodes.csv",nodes);