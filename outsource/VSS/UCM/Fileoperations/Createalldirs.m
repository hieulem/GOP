function Createalldirs(filenames)

if (~isstruct(filenames))
    fprintf('Variable must be a struct\n');
    return;
end

whichfn = fieldnames(filenames);
nofn=numel(whichfn);
for fn=1:nofn
    
    thefile=filenames.(whichfn{fn});
    
    
%     fprintf('Variable %s\n',whichfn{fn});
    
    
    if (  (~ischar(thefile))  ||  ( (size(thefile,1)>1) && (size(thefile,2)>1) )  )
%         thefile
        continue;
    end
    
    wherefs=strfind(thefile,filesep);
    
    if (~isempty(wherefs))
        thedir=thefile(1:wherefs(end));
        
%         fprintf('To create %s\n',thedir);

        if (exist(thedir,'dir')==0) %if directory does not exist
            status=mkdir(thedir);
            if (status)
                fprintf('Created directory %s\n',thedir);
            else
                fprintf('Could not create directory %s\n',thedir);
            end
        end
    end
end
