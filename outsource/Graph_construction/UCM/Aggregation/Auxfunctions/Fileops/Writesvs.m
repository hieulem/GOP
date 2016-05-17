function Writesvs()
% Writesvs();

filename='UCMtmp.m'; %'UCMtmp.m', 'SVStmp.m'

fid = fopen(filename);

nocases=0;
currentcase=''; %this should never be used
while (true)
    
    tline = fgetl(fid);
    
    if ( (numel(tline)==1) && (tline==-1) )
%         fprintf('End of file reached\n');
        break;
    end
        
    if ( (numel(tline)>3) && (strcmp(tline(1:3),'%%%')) ) %three % denote a new case name
        currentcase=tline(4:end);
        
        writefilename=['Cluster',filesep,sprintf('%s',currentcase),'.m'];
        
        fidwrite = fopen(writefilename,'wt');
        
        fprintf(fidwrite,'function %s()\n',currentcase);
        Writeheader(fidwrite);
        
        writecase=true;
        while(writecase)
            fprintf(fidwrite,'%s\n',tline);
            tline = fgetl(fid);
        
            if ( (numel(tline)>19) && (strcmp(tline(1:19),'    Doallprocessing')) )
                fprintf(fidwrite,'%s\n',tline);
                writecase=false;
            end
        end
        fclose(fidwrite);        
        
        nocases=nocases+1;
    end
    
        
end
fclose(fid);

fprintf('No cases written %d\n',nocases);


function Writeheader(fid)

fprintf(fid,'Setthepath();\n');
fprintf(fid,'if (ispc)\n');
fprintf(fid,'    basedrive=[''D:'',filesep];\n');
fprintf(fid,'else\n');
fprintf(fid,'    if (exist([filesep,''BS'',filesep,''galasso_proj_spx'',filesep,''work'',filesep],''dir''))\n');
fprintf(fid,'        basedrive=[filesep,''BS'',filesep,''galasso_proj_spx'',filesep,''work'',filesep];\n');
fprintf(fid,'    else\n');
fprintf(fid,'        basedrive=[filesep,''media'',filesep,''Data'',filesep];\n');
fprintf(fid,'    end\n');
fprintf(fid,'end\n');
fprintf(fid,'\n');











