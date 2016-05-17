function options=Adjustcellarrays(options,opname)
% opname='requestedaffinities';
% options.requestedaffinities='{stt,ltt,aba,abm,stm,sta}'

thefop=options.(opname);

% fprintf('options name passed for processing: %s\n',opname);
% fprintf('ischar %d, numel %d, content[[%s]]\n', ischar(thefop), numel(thefop), thefop );


if ( (thefop(1)=='{') && (thefop(end)=='}') )
    thefop(1)=','; thefop(end)=',';
    wherecomas=strfind(thefop,',');
    numberargs=numel(wherecomas)-1;
    
    thenewo=cell(1,numberargs);
    
    for i=1:numberargs
        thenewo{i}=thefop((wherecomas(i)+1):(wherecomas(i+1)-1));
    end
    
    options.(opname)=thenewo;
    
    fprintf('Inserted cell array into options (%d elements):',numel(thenewo)); fprintf(' [[%s]]',thenewo{:}); fprintf('\n');
end

