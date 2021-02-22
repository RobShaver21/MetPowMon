function [Output]=RoundConvert(Table,roundnr)
% Table: m x n table
% roundnr: n x 1 double with NaN for strings and integer for scalars

for a=1:width(Table)  % round and convert to strings
    if ~isnan(roundnr(a))
        Table(:,a)=varfun(@(var) round(var,roundnr(a)),Table(:,a));
        RoundStr=['%5.' num2str(roundnr(a)) 'f'];
        Output(:,a)=sprintfc(RoundStr,Table{:,a});
    else
        Output(:,a)=Table(:,a);
    end
end

end
