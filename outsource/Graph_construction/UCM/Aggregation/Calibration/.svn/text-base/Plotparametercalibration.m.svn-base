function Plotparametercalibration(outDir)


%List of files in Output
iids = dir(fullfile(outDir,'*.txt'));
if (numel(iids)<1)
    fprintf('Statistics to be computed\n');
    return;
end
for i = 1:numel(iids)
    
    [thepath, theaffinityname, theext] = fileparts(iids(i).name); if (~isempty(thepath)), fprintf('This dir name %s should be empty\n', thepath); end %#ok<NASGU>
    
    inFile= fullfile(outDir, iids(i).name); %[thename, theext]

    thescore = dlmread(inFile);
    posbin=thescore(:,1)';
    negbin=thescore(:,2)';
    
    figurenumber=10*i;
    Plotaffinityplots([negbin;posbin],[],theaffinityname,{'false','true'},figurenumber);
    
end

