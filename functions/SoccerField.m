function SoccerField(LV1,LV2)

xlim([-20 LV2+20])
ylim([-20 LV1+20])
rectangle('Position',[0 0 LV2 LV1]);    %Spielfeld
rectangle('Position',[LV2/2 0 0 LV1]); % Mittellinie
rectangle('Position',[LV2/2-9.15 LV1/2-9.15 18.3 18.3],'Curvature',[1,1]); % Kreis
rectangle('Position',[0 LV1/2-9.16 5.5 18.32]); % 5m li
rectangle('Position',[0 LV1/2-20.16 16.5 40.32]); % Strafraum li
rectangle('Position',[-3 LV1/2-3.66 3 7.32]); %Tor li
rectangle('Position',[LV2-5.5 LV1/2-9.16 5.5 18.32]); % 5m re
rectangle('Position',[LV2-16.5 LV1/2-20.16 16.5 40.32]); % Strafraum re
rectangle('Position',[LV2 LV1/2-3.66 3 7.32]); %Tor re

end
