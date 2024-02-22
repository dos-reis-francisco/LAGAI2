% extractPoint.m
% Dos Reis F.
% 04.02.2023

function [Point1, Point2, Point3]=extractPoint(i,TPOINTS,TSEGMENTS,TFACES)

    seg1=TFACES(i,1);
    seg2=TFACES(i,2);
    numPT1=TSEGMENTS(seg1,1);
    numPT2=TSEGMENTS(seg1,2);
    numPT3=TSEGMENTS(seg2,1);
    numPT4=TSEGMENTS(seg2,2);
    
    % remise dans l'ordre des numéro de points 
    % de telle sorte que PT1=PT3 et les deux vecteurs U=(PT1,PT2), V=(PT1,PT4)
    regular=0;
    if ((numPT1==numPT3) || (numPT1==numPT4))
            regular=1;
            if (numPT1==numPT4)
                temp=numPT3; numPT3=numPT4;numPT4=temp;
            end
    end 
    if ((numPT2==numPT3) || (numPT2==numPT4))
            regular=1;
            temp=numPT1; numPT1=numPT2;numPT2=temp;
            if (numPT1==numPT4)
                temp=numPT3; numPT3=numPT4;numPT4=temp;
            end
    end 
    if (regular==0)
        "erreur : points non correspondants dans une face"
    end
    
    % Calculd des deux vecteurs de base 
    Point1=TPOINTS(numPT1,:);
    Point2=TPOINTS(numPT2,:);
    Point3=TPOINTS(numPT4,:);
end