function Editmathelper(adirectory)
%The function should be launched with directory paths in input
%adirectory=fullfile(basedir,iidss(3).name);

iidss = dir(fullfile(adirectory,'*')); %source files

for i=1:numel(iidss)
    
    if ( (strcmp(iidss(i).name,'.')) || (strcmp(iidss(i).name,'..')) )
        continue;
    end
    
    if (iidss(i).isdir) %Iterate in case of folders
        
        adir=fullfile(adirectory,iidss(i).name);
        fprintf('Dir: %s\n',adir);
        Editmathelper(adir);
        %adirectory=adir;
        
    else %Analyze .mat in case of files
        
        afile=fullfile(adirectory,iidss(i).name);
        [thepath,thename,theext]=fileparts(afile); %#ok<ASGLU>
        
        if (strcmp(theext,'.mat'))
            
            load(afile);
            %fprintf('(%s) ',thename);
            
            for j=1:numel(groundTruth)
                
%                 Init_figure_no(10), imshow(groundTruth{j}.Boundaries);
                
                bmap=groundTruth{j}.Boundaries;
                bmap = logical(bwmorph(bmap, 'thin', Inf));
%                 bmap = double(bwmorph(bmap, 'thin', Inf));
                groundTruth{j}.Boundaries=bmap;
                
%                 Init_figure_no(20), imshow(groundTruth{j}.Boundaries);
                
            end
            
            save(afile,'groundTruth');
            
        else
            
            continue;
            
        end
    end
end
