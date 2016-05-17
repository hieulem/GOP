function Addcase()
% Addcase();

filename='SVS.m'; %'UCM.m', 'SVS.m', 'UCMal.m'
outfilename='Tmp.m';

fid = fopen(filename);
fidout = fopen(outfilename,'wt');

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
                
        fprintf(fidout,'    case ''%s''\n',currentcase);
        
        nocases=nocases+1;
    end
    
    fprintf(fidout,'%s\n',tline);
end
fclose(fid);
fclose(fidout);        

fprintf('No cases written %d\n',nocases);



