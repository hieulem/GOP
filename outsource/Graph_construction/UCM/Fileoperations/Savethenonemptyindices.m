function Savethenonemptyindices(thefilename,nonemptyindex)
%thefilename=[inDir,'allindices',filenames.casedirname,'.txt'];

fid = fopen(thefilename,'w');

if fid==-1,
    error('Could not open file %s for writing.',thefilename);
end
if (numel(nonemptyindex)>0)
    fprintf(fid,'%10g ', nonemptyindex);
else
    fprintf('nonemptyindex empty\n');
end
fprintf(fid,'\n');

fclose(fid);

% nonemptyindex2 = dlmread([inDir,'allindices',filenames.casedirname,'.txt']);
% isequal(nonemptyindex,nonemptyindex2)