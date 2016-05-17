function Writeallscripts()
% Writeallscripts();

filename='UCM.m'; %'UCM.m', 'SVS.m', 'UCMal.m'
outfilename=['Cluster',filesep,'Allscripts'];

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
                
        fprintf(fidout,'./run_UCM.sh /BS/opt/local/MATLAB_Compiler_Runtime/v714 "%s"\n',currentcase);
        
        nocases=nocases+1;
    end
    
end
fclose(fid);
fclose(fidout);

fprintf('No cases written %d\n',nocases);


%ssh submit-lenny
%source /n1_grid/current/inf/common/settings.sh
%commands2arrayjob.sh Allscripts
%cd ~/.mcrCache7.14/
%qstat
%cd Cluste1/
%ls -lah

%echo "mcc -R -singleCompThread -m Clusterscript.m -v -a ./ ; quit" | /usr/bin/matlab -nojvm -nosplash -nodisplay
%./run_Clusterscript.sh /BS/opt/local/MATLAB_Compiler_Runtime/v714
%"AnInputString"