function Removethebis(filename,strtosearch,strtoreplace,newfilename)
% filename='/BS/galasso_proj_spx/work/VideoProcessingTemp/Shared/Benchmark/Bmcsvfallp50poptnrmvid/Input/C9_carseightnowrp.txt';
% strtosearch='bis';
% strtoreplace='';

if ( (~exist('newfilename','var')) || (isempty(newfilename)) )
    newfilename=filename;
end

if (~exist(filename,'file'))
    fprintf('%s: file not found\n',filename);
    return;
end

fid = fopen(filename,'r');

thelines=cell(0);
i=0;
while (true)
    tmp=fgetl(fid);
    if (tmp==-1)
        break;
    end
    i=i+1;
    thelines{i}=tmp;
%     disp(thelines{i});
end

fclose(fid);

nlines=i;



strwasfound=false;
for i=1:nlines
    k=strfind(thelines{i},strtosearch);
    if (isempty(k))
        continue;
    else
        strwasfound=true;
        tmp=thelines{i};
        thelines{i}=tmp(1:(k-1));
        thelines{i}=[thelines{i},strtoreplace];
        thelines{i}=[thelines{i},tmp((k+numel(strtosearch)):end)];
    end
end
if (~strwasfound)
    fprintf('%s: string %s not found\n',filename,strtosearch);
    return;
end



fid = fopen(newfilename,'w');

for i=1:nlines
    fprintf(fid,'%s\n',thelines{i});
end

fclose(fid);



if (~strcmp(filename,newfilename))
    delete(filename);
end
