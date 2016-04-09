function Addcurrentcaseformceach(score,filenames,additionalname)

if ( (~exist('additionalname','var')) || (isempty(additionalname)) )
    additionalname='Cstltifeff';
end



[thebenchmarkdir,theDir,isvalid,theDirf,isvalidf] = Benchmarkcreatemanifoldclusterdirs(filenames, additionalname); %#ok<NASGU,ASGLU>
% rmdir(theDir,'s')
% rmdir(thebenchmarkdir,'s')

%Write output to files
thefilename=sprintf('%s_atc_%g.txt',filenames.casedirname,score(1));
fname = fullfile(theDir,thefilename);
fid = fopen(fname,'w');
if fid==-1,
    error('Could not open file %s for writing.',fname);
end
if (size(score,2)>17)
    if (size(score,1)>1)
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:12,:),score(17:19,:)]');
    else
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:12),score(17:19)]');
    end
else
    if (size(score,1)>1)
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', score(1:12,:)');
    else
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', score(1:12)');
    end    
end
fclose(fid);

%Write output to files in theDirf
%Exaplined variation is only reported in this file
thefilename=sprintf('%s_atc_%g.txt',filenames.casedirname,score(1));
fname = fullfile(theDirf,thefilename);
fid = fopen(fname,'w');
if fid==-1,
    error('Could not open file %s for writing.',fname);
end
if (size(score,2)>17)
    if (size(score,1)>1)
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:2,:),score(22,:),score(13:16,:),score(23,:),score(9:12,:),score(17,:),score(20:21,:)]');
    else
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:2),score(22),score(13:16),score(23),score(9:12),score(17),score(20:21)]');
    end
else
    if (size(score,1)>1)
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:3,:),score(13:16,:),score(8:12,:),score(17,:)]');
    else
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n', [score(1:3),score(13:16),score(8:12),score(17)]');
    end
end
fclose(fid);
