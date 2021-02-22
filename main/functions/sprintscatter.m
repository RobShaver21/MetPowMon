function [xx,yy]=sprintscatter(Vec,shift)
% img = plot, xx/yy = merged x/y-vector
% hold on

for bb=1:length(Vec)
    x=Vec{bb};
    y=(zeros(size(x))+bb+shift)*(-1);
    % img=scatter(x,y,'.');
    % xlim([0 S]);
    % ylim([-length(LfdNr) 0]);
    if bb==1
        xx=x;
        yy=y;
    else
        xx=[xx; x];
        yy=[yy; y];
    end
end
hold off
end
