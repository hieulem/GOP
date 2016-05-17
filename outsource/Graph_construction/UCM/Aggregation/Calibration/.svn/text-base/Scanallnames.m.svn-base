function allvideonames=Scanallnames(iids)

allvideonames=cell(0);
for i = 1:numel(iids)
    
    [thepath, thename, theext] = fileparts(iids(i).name); if (~isempty(thepath)), fprintf('This dir name %s should be empty\n', thepath); end %#ok<NASGU>
    
%     inFile= fullfile(theDir, iids(i).name); %[thename, theext]

    [thevideoname]=Findthecaseandaffinity(thename); %,theaffinity
    
    [allvideonames]=Addfindname(allvideonames,thevideoname); %,thevpos
    
end
