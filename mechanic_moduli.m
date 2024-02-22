function  obtenu= mechanic_moduli(MS)

Ex=1/MS(1,1);
Ey=1/MS(1,2);
nuyx=-MS(1,6)*Ey;

muxy=1/(2*MS(1,3));
etaxxy=MS(1,5)*2*muxy;
etayxy=MS(1,4)*2*muxy;
obtenu=[Ex,Ey,muxy,etayxy,etaxxy,nuyx];
end

