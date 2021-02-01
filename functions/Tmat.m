function AllRef=Tmat(AllRef);
%%
for a=1:length(AllRef)
    for b=1:length(AllRef{1,a}{1,3})
        
        
        P0=AllRef{1,a}{1,3}(b).P(:,1);
        P1=AllRef{1,a}{1,3}(b).P(:,2);
        P2=AllRef{1,a}{1,3}(b).P(:,3);
        
        V1=P1-P0;                       % new vector for base exchange
        V2=P2-P0;                       % V1: y-vec, V2: x-vec
        
        arclenV1=distance(P0(1),P0(2),P1(1),P1(2));
        arclenV2=distance(P0(1),P0(2),P2(1),P2(2));
        
        LV1=deg2km(arclenV1)*1000;  %length Vector 1 in [m]
        LV2=deg2km(arclenV2)*1000;  %length Vector 2 in [m]
        
        B1=[1 0;0 1];                   % old base
        B2=[V1,V2];                     % new base
        
        T=B2\B1;                   % transformation matrix
        
        AllRef{1,a}{1,3}(b).T=T;
        AllRef{1,a}{1,3}(b).LV1=LV1;
        AllRef{1,a}{1,3}(b).LV2=LV2;
    end
end
%%
end
%%
