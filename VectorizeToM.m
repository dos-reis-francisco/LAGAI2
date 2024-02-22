%% VectoriseToM.m
% function to vectorise homogenization algorithm

%A=zeros(1,5); % matrice à obtenir
%B=[1 2 5 7 13 11 85]; % matrice contenant les n valeurs à additionner 
%M=zeros(5,7); % matrice de multiplication
%C=[2 5 1 2 2 4 3]; % matrice contenant les références dans la matrice A
%for i=1:7   % on boucle sur les n valeurs 
%    M(C(i),i)=1;    % on construit la matrice 
%end

function M=VectorizeToM(TME,TMF,TMD,VCL,VCC,DIM):
I=eye(TME);

if DIM==1               % square case
    nl=TMF*TME;         % nombre de lignes
    
elseif DIM==2           % linear case

    M=sparse(zeros(TME*TMF,TME*TMD));
end    

end