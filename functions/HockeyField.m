function HockeyField(LV1,LV2)


xlim([-20 LV2+20])
ylim([-20 LV1+20])
rectangle('Position',[0 0 LV2 LV1]);    %Spielfeld
rectangle('Position',[LV2/4 0 0 LV1]); % Viertellinie
rectangle('Position',[LV2*3/4 0 0 LV1]); % Viertellinie

rectangle('Position',[14.63 LV1/2-1.83 0 3.66]); %Liniensegment li
rectangle('Position',[LV2-14.63 LV1/2-1.83 0 3.66]); %Liniensegment re

rectangle('Position',[-3 LV1/2-1.83 3 3.66]); %Tor li
rectangle('Position',[LV2 LV1/2-1.83 3 3.66]); %Tor re

hold on

CircleSeg(pi/2,0,0,LV1/2+1.83,14.63)    % Kreissegmente li
CircleSeg(0,-pi/2,0,LV1/2-1.83,14.63)

CircleSeg(pi,pi/2,LV2,LV1/2+1.83,14.63)    % Kreissegmente re
CircleSeg(pi*3/2,pi,LV2,LV1/2-1.83,14.63)

end

