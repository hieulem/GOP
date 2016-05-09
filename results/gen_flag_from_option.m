function [ flag ] = gen_flag_from_option( gehoptions )

if gehoptions.useSpatialGrid == 1
    pre_flag = ['Grid',array2str(gehoptions.Grid)];
else
    pre_flag = [];
end


switch gehoptions.type
    case '2d'
       flag = [pre_flag,gehoptions.metric,'_',gehoptions.dataset,'_',num2str(gehoptions.phi),'_' ...
            ,num2str(gehoptions.nGeobins),'_',num2str(gehoptions.nIntbins),'_',num2str(gehoptions.maxGeo),'_',num2str(gehoptions.maxInt),'_',int2str(gehoptions.usingflow)];
    case '1d'
       flag = [pre_flag,gehoptions.metric,'_',gehoptions.dataset,'_',num2str(gehoptions.phi),'_' ...
            ,num2str(gehoptions.nGeobins),'_',num2str(gehoptions.maxGeo),'_',int2str(gehoptions.usingflow),'/'];
end;

end

