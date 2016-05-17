function Modifyallfilesindir(dirname,strtosearch,strtoreplace)
% dirname='/BS/galasso_proj_spx/work/VideoProcessingTemp/Shared/Benchmark/Bmcsvfallp50poptnrmvid/Input/';

iids = dir(fullfile(dirname,'*.txt'));
if (numel(iids)<1)
    fprintf('Directory empty\n');
    return;
end
fprintf('Modifyed file idx:');
for i = 1:numel(iids)
    inFile = fullfile(dirname, iids(i).name);

    Removethebis(inFile,strtosearch,strtoreplace);
    
    fprintf(' %d',i);
end
fprintf('\n');
