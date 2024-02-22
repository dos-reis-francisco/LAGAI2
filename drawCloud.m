%drawskin.m
function f=drawCloud(TNUAGE,textX,textY,textZ,moyenne,ecartType)

    f=figure; 
    % ligne des X
    line1=[-200;200];
    line2=[0;0];
    line3=[0;0];
    % ligne des Y
    line4=[0;0];
    line5=[-200;200];
    line6=[0;0];
    % line des Z
    line7=[0;0];
    line8=[0;0];
    line9=[-200;200];
    hold all;
    plot3(TNUAGE(:,1),TNUAGE(:,2),TNUAGE(:,3),'o','Color','g');

    % dessin des axes
    plot3(line1,line2,line3,'-','Color','r');
    plot3(line4,line5,line6,'-','Color','m');
    plot3(line7,line8,line9,'-','Color','b');
    text(200,0,0,'+'+textX,'Color','r');
    text(-200,0,0,'-'+textX,'Color','r');
    text(0,200,0,'+'+textY,'Color','m');
    text(0,-200,0,'-'+textY,'Color','m');
    text(0,0,200,'+'+textZ,'Color','b');
    text(0,0,-200,'-'+textZ,'Color','b');

    % dessin des graduations sur les axes
    for i=-1.5:0.75:1.5
        val1=i*ecartType(1)+moyenne(1);
        val1s=compose("%6.1f",val1);
        text(i*100,0,0,val1s,'Color','r');
        val2=i*ecartType(2)+moyenne(2);
        val2s=compose("%6.1f",val2);
        text(0,i*100,0,val2s,'Color','m');
        val3=i*ecartType(3)+moyenne(3);
        val3s=compose("%6.1f",val3);
        text(0,0,i*100,val3s,'Color','b');
    end 
    view(-151,30);     % change the orientation 
    axis equal off    % make the axes equal and invisible
    l = light('Position',[-0.4 0.2 0.9],'Style','infinite');
    lighting gouraud;
    rotate3d on;
    alpha(0.5);

end