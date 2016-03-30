function Savesegs(filename,allthesegmentations,theframe)
%The function is used to save the variable with the ucm2 name

numberofsegmentations=numel(allthesegmentations);
segs=cell(1,numberofsegmentations);
for i=1:numberofsegmentations
    segs{i}=allthesegmentations{i}(:,:,theframe); %double, variable was already converted with Uintconv
end
save(filename,'segs');


%load([inDir,filenames.casedirname,num2str(f),'segs.mat'])