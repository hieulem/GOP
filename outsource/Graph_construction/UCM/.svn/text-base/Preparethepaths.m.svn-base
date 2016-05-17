function [allregionpaths,correspondentPath,totPaths]=Preparethepaths(similarities,allregionsframes,filenames)
%if any option is selected wrongly the function return all three variables 
%set to zero, so other parts of the program have to check that
%allregionpaths and correspondentPath are cell arrays

%method
method=input('Please select if you want\n(1[default]) to use a forward/backward dynamic programming or (2) a backward: ');
if (isempty(method)||(method==1))
    method=1; %Forward and backward dynamic programming
elseif (method~=2)
    allregionpaths=0;
    correspondentPath=0;
    totPaths=0;
    return
end

%method_sum_log
method_sum_log=input('(1[default]) to sum the similarities or (2) to sum their logarithms (multiply): ');
if (isempty(method_sum_log)||(method_sum_log==1))
    method_sum_log=1; %Forward and backward dynamic programming
elseif (method_sum_log~=2)
    allregionpaths=0;
    correspondentPath=0;
    totPaths=0;
    return
end

%what to scramble with
scramblewithmap=input('(1[default]) to use a map or (2) the path length: ');
if (isempty(scramblewithmap)||(scramblewithmap==1))
    scramblewithmap=1; %map
elseif (scramblewithmap~=2)
    allregionpaths=0;
    correspondentPath=0;
    totPaths=0;
    return
end

if (method==1)&&(scramblewithmap==1)&&(method_sum_log==1)
    filename=filenames.filename_forward_backward_with_scrambled_map; %bi-directional map correspondentPath
elseif (method==1)&&(scramblewithmap==2)&&(method_sum_log==1)
    filename=filenames.filename_forward_backward_with_length_map; %bi-directional length correspondentPath
elseif (method==2)&&(scramblewithmap==1)&&(method_sum_log==1)
    filename=filenames.filename_backward_with_scrambled_map; %mono-directional map correspondentPath
elseif (method==2)&&(scramblewithmap==2)&&(method_sum_log==1)
    filename=filenames.filename_backward_with_length_map; %mono-directional length correspondentPath
elseif (method==1)&&(scramblewithmap==1)&&(method_sum_log==2)
    filename=filenames.filename_forward_backward_with_scrambled_map_log; %bi-directional map correspondentPath
elseif (method==1)&&(scramblewithmap==2)&&(method_sum_log==2)
    filename=filenames.filename_forward_backward_with_length_map_log; %bi-directional length correspondentPath
elseif (method==2)&&(scramblewithmap==1)&&(method_sum_log==2)
    filename=filenames.filename_backward_with_scrambled_map_log; %mono-directional map correspondentPath
else %(method==2)&&(scramblewithmap==2)&&(method_sum_log==2)
    filename=filenames.filename_backward_with_length_map_log; %mono-directional length correspondentPath
end


noFrames=size(allregionsframes,2);
if (exist(filename,'file'))
    %whether to use a precomputed file
    loadChoice=input('(1[default]) to load a saved file or (2) to compute new data: ');
    if (isempty(loadChoice)||(loadChoice==1))
        load(filename);
        if (scramblewithmap==1)
            totPaths=numel(allregionpaths.totalLength);
        else
            totPaths=noFrames;
        end
        return
    elseif (loadChoice~=2)
        allregionpaths=0;
        correspondentPath=0;
        totPaths=0;
        return
    end
end

%whether to save after the computation
saveChoice=input('(1[default]) to save the file after the computation or (2) not to save: ');
if (isempty(saveChoice)||(saveChoice==1))
    saveChoice=1;
elseif (saveChoice~=2)
    allregionpaths=0;
    correspondentPath=0;
    totPaths=0;
    return
end

if (scramblewithmap==1)
    %whether to use saved map, if possible
    if (exist(filenames.filename_map,'file'))
        loadMap=input('(1[default]) to use a saved map, if possible, or (2) to compute a new one: ');
        if (isempty(loadMap)||(loadMap==1))
            loadMap=1;
        elseif (loadMap~=2)
            allregionpaths=0;
            correspondentPath=0;
            totPaths=0;
            return
        end
    else
        loadMap=2;
    end

    %whether to save map afterwards, if it was recomputed
    nosaveMap=input('(1[default]) to not save the map or (2) save it, if recomputed: ');
    if (isempty(nosaveMap)||(nosaveMap==1))
        nosaveMap=1;
    elseif (nosaveMap~=2)
        allregionpaths=0;
        correspondentPath=0;
        totPaths=0;
        return
    end
else
    loadMap=2;
    nosaveMap=1;
end

if (method_sum_log==1)
    chosenSimilars=Getpaths(similarities); %backward dynamic programming
else
    chosenSimilars=Get_probability_paths(similarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
end
if (method==1)
    %in the forward/backward dynamic programming the forward similarities
    %and the output of a forward dynamic programming are need
    forwardSimilarities=Invertsimilarities(similarities);
    if (method_sum_log==1)
        chosenforwardSimilars=Getpaths(forwardSimilarities);
    else
        chosenforwardSimilars=Get_probability_paths(forwardSimilarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
    end

    for frame=1:fix(noFrames/2)
        tmp=chosenforwardSimilars{frame};
        chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
        chosenforwardSimilars{noFrames-frame+1}=tmp;
    end
    % for frame=1:fix(noFrames/2) %reinvert the forwardSimilarities so as to have them in the right direction
    %     tmp=forwardSimilarities{frame};
    %     forwardSimilarities{frame}=forwardSimilarities{noFrames-frame+1};
    %     forwardSimilarities{noFrames-frame+1}=tmp;
    % end

    if (method_sum_log==1)
        allregionpaths=Getbidirectionalpaths(chosenSimilars,chosenforwardSimilars,similarities);
    else
        allregionpaths=Get_bidirectional_dp_with_probabilities(chosenSimilars,chosenforwardSimilars,similarities); %equivalent of Getbidirectionalpaths,
                                                                                %but initialising with 0 and taking sum of logarithms (product of probabilities)
    end
    fprintf('Forward/backward paths computed\n');
else
    %in the backward dynamic programming the backward similarities
    %are sufficient and splitting is decided according to similarity (not
    %to a forward dynamic programming
    if (method_sum_log==1)
        allregionpaths=Getmonodirectionalpaths(chosenSimilars);
    else
        fprintf('Backward dynamic programming and sum of logarithms not yet implemented\n');
        allregionpaths=0;
        correspondentPath=0;
        totPaths=0;
        return
    end
    fprintf('Backward paths computed\n');
end

if (scramblewithmap==1)
    totPaths=numel(allregionpaths.totalLength);
    if (loadMap==1)
        load(filenames.filename_map);
        if (size(map,2)>=totPaths)
            fprintf('Using saved map\n');
        else
            clear map;
            loadMap=2; %this is done to not save if the present map file was already valid
        end
    end
    if (~exist('map','var'))
        map=Scramble(totPaths);
        fprintf('New map generated\n');
    end
    if ((loadMap~=1)&&(nosaveMap~=1))
        save(filenames.filename_map, 'map','-v7.3');
        fprintf('New map saved\n');
    end
else
    totPaths=noFrames;
    map=allregionpaths.totalLength;
end

correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
fprintf('Correspondences computed\n');

if (saveChoice==1)
    save(filename, 'allregionpaths', 'correspondentPath', 'totPaths', '-v7.3');
    fprintf('Paths and correspondences saved\n');
end


function to_run_for_the_probability_paths()
%some notes:
%- normalising the probabiliy does not really improve on the already
%computed result
%- it is to consider the improvements given by using the product instead of
%the sum
%- it is worth trying to multiply the prior times the similarities, not
%normalising


%using normalisedsimilaritiesnnf (not pre-normalised before the prior) and products (sums of logarithms)
load(filenames.filename_allregionsframes_all)
load('D:\normalisedsimilaritiesprior.mat')
%loads normalisedsimilaritiesnnf

forwardSimilarities=Invertsimilarities(normalisedsimilaritiesnnf);
chosenSimilars=Get_probability_paths(normalisedsimilaritiesnnf); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
chosenforwardSimilars=Get_probability_paths(forwardSimilarities);
noFrames=size(chosenforwardSimilars,2);
for frame=1:fix(noFrames/2)
    tmp=chosenforwardSimilars{frame};
    chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
    chosenforwardSimilars{noFrames-frame+1}=tmp;
end
allregionpaths=Get_bidirectional_dp_with_probabilities(chosenSimilars,chosenforwardSimilars,normalisedsimilaritiesnnf); %equivalent of Getbidirectionalpaths,
                                                                                                        %but initialising with 0 and taking sum of logarithms (product of probabilities)
totPaths=numel(allregionpaths.totalLength);

load(filenames.filename_map)
% map=Scramble(totPaths);

correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
save('D:\newregpath_all.mat', 'allregionpaths', 'correspondentPath', '-v7.3');
% load('D:\newregpath_all.mat');
correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);

[flows,allregionsframes,normalisedsimilarities]=getMenu(cim,ucm2,flows,allregionsframes,normalisedsimilaritiesnnf,allregionpaths,correspondentPath);
frame=1;
level=35;
[frame,level]=getclusteringmenu(frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath);

minLength=2;
load(filenames.filename_flows)
filter_flow=false;
[trajectories,mapPathToTrajectory]=Gettrajectories(ucm2,flows,allregionsframes,allregionpaths,minLength,filter_flow);
save('D:\newtraj_all.mat', 'trajectories','mapPathToTrajectory','-v7.3');
fprintf('Saved to file\n');




%using normalisedsimilarities and products (sums of logarithms)
load(filenames.filename_allregionsframes_all)
load('D:\normalisedsimilaritiesprior.mat')
%loads normalisedsimilarities

forwardSimilarities=Invertsimilarities(normalisedsimilarities);
chosenSimilars=Get_probability_paths(normalisedsimilarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
chosenforwardSimilars=Get_probability_paths(forwardSimilarities);
noFrames=size(chosenforwardSimilars,2);
for frame=1:fix(noFrames/2)
    tmp=chosenforwardSimilars{frame};
    chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
    chosenforwardSimilars{noFrames-frame+1}=tmp;
end
allregionpaths=Get_bidirectional_dp_with_probabilities(chosenSimilars,chosenforwardSimilars,normalisedsimilarities); %equivalent of Getbidirectionalpaths,
                                                                                                        %but initialising with 0 and taking sum of logarithms (product of probabilities)
totPaths=numel(allregionpaths.totalLength);

load(filenames.filename_map)
% map=Scramble(totPaths);

correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
save('D:\newregpath_all.mat', 'allregionpaths', 'correspondentPath', '-v7.3');
% load('D:\newregpath_all.mat');
correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);

[flows,allregionsframes,normalisedsimilarities]=getMenu(cim,ucm2,flows,allregionsframes,normalisedsimilarities,allregionpaths,correspondentPath);
frame=1;
level=35;
[frame,level]=getclusteringmenu(frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath);

minLength=2;
load(filenames.filename_flows)
filter_flow=false;
[trajectories,mapPathToTrajectory]=Gettrajectories(ucm2,flows,allregionsframes,allregionpaths,minLength,filter_flow);
save('D:\newtraj_all.mat', 'trajectories','mapPathToTrajectory','-v7.3');
fprintf('Saved to file\n');


% % % %using normalised similarities and sums - normalised similarities do not
% % % %seem to work
% % % load(filenames.filename_allregionsframes_all)
% % % load(filenames.filename_normalisedsimilarities_all)
% % % 
% % % forwardSimilarities=Invertsimilarities(normalisedsimilarities);
% % % chosenSimilars=Getpaths(normalisedsimilarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
% % % chosenforwardSimilars=Getpaths(forwardSimilarities);
% % % noFrames=size(chosenforwardSimilars,2);
% % % for frame=1:fix(noFrames/2)
% % %     tmp=chosenforwardSimilars{frame};
% % %     chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
% % %     chosenforwardSimilars{noFrames-frame+1}=tmp;
% % % end
% % % allregionpaths=Getbidirectionalpaths(chosenSimilars,chosenforwardSimilars,normalisedsimilarities); %equivalent of Getbidirectionalpaths,
% % %                                                                                                         %but initialising with 0 and taking sum of logarithms (product of probabilities)
% % % totPaths=numel(allregionpaths.totalLength);
% % % 
% % % load(filenames.filename_map)
% % % % map=Scramble(totPaths);
% % % 
% % % correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
% % % save('D:\newregpath_all.mat', 'allregionpaths', 'correspondentPath', '-v7.3');
% % % % load('D:\newregpath_all.mat');
% % % correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);
% % % 
% % % [flows,allregionsframes,normalisedsimilarities]=getMenu(cim,ucm2,flows,allregionsframes,normalisedsimilarities,allregionpaths,correspondentPath);
% % % frame=1;
% % % level=35;
% % % [frame,level]=getclusteringmenu(frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath);
% % % 
% % % minLength=2;
% % % load(filenames.filename_flows)
% % % filter_flow=false;
% % % [trajectories,mapPathToTrajectory]=Gettrajectories(ucm2,flows,allregionsframes,allregionpaths,minLength,filter_flow);
% % % save('D:\newtraj_all.mat', 'trajectories','mapPathToTrajectory','-v7.3');
% % % fprintf('Saved to file\n');


% % % %using normalised similarities and products (sums of logarithms) - normalised similarities do not
% % % %seem to work
% % % load(filenames.filename_allregionsframes_all)
% % % load(filenames.filename_normalisedsimilarities_all)
% % % 
% % % forwardSimilarities=Invertsimilarities(normalisedsimilarities);
% % % chosenSimilars=Get_probability_paths(normalisedsimilarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
% % % chosenforwardSimilars=Get_probability_paths(forwardSimilarities);
% % % noFrames=size(chosenforwardSimilars,2);
% % % for frame=1:fix(noFrames/2)
% % %     tmp=chosenforwardSimilars{frame};
% % %     chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
% % %     chosenforwardSimilars{noFrames-frame+1}=tmp;
% % % end
% % % allregionpaths=Get_bidirectional_dp_with_probabilities(chosenSimilars,chosenforwardSimilars,normalisedsimilarities); %equivalent of Getbidirectionalpaths,
% % %                                                                                                         %but initialising with 0 and taking sum of logarithms (product of probabilities)
% % % totPaths=numel(allregionpaths.totalLength);
% % % 
% % % load(filenames.filename_map)
% % % % map=Scramble(totPaths);
% % % 
% % % correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
% % % save('D:\newregpath_all.mat', 'allregionpaths', 'correspondentPath', '-v7.3');
% % % % load('D:\newregpath_all.mat');
% % % correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);
% % % 
% % % [flows,allregionsframes,normalisedsimilarities]=getMenu(cim,ucm2,flows,allregionsframes,normalisedsimilarities,allregionpaths,correspondentPath);
% % % frame=1;
% % % level=35;
% % % [frame,level]=getclusteringmenu(frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath);
% % % 
% % % minLength=2;
% % % load(filenames.filename_flows)
% % % filter_flow=false;
% % % [trajectories,mapPathToTrajectory]=Gettrajectories(ucm2,flows,allregionsframes,allregionpaths,minLength,filter_flow);
% % % save('D:\newtraj_all.mat', 'trajectories','mapPathToTrajectory','-v7.3');
% % % fprintf('Saved to file\n');



%programs to run:
%forward/backward dynamic programming
% load D:\regframe_1to70.mat
% load D:\similars_1to70.mat
% forwardSimilarities=Invertsimilarities(similarities);
% chosenSimilars=Getpaths(similarities);
% chosenforwardSimilars=Getpaths(forwardSimilarities);
% noFrames=size(chosenforwardSimilars,2);
% for frame=1:fix(noFrames/2)
%     tmp=chosenforwardSimilars{frame};
%     chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
%     chosenforwardSimilars{noFrames-frame+1}=tmp;
% end
% % for frame=1:fix(noFrames/2) %reinvert the forwardSimilarities so as to have them in the right direction
% %     tmp=forwardSimilarities{frame};
% %     forwardSimilarities{frame}=forwardSimilarities{noFrames-frame+1};
% %     forwardSimilarities{noFrames-frame+1}=tmp;
% % end
% allregionpaths=Getbidirectionalpaths(chosenSimilars,chosenforwardSimilars,similarities);
% totPaths=numel(allregionpaths.totalLength);
% map=Scramble(totPaths);
% correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
% correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);
% load d:\filename.mat
% [flows,allregionsframes,similarities]=getMenu(cim,ucm2,flows,allregionsframes,similarities,allregionpaths,correspondentPath);
% usetotpaths=0;
% [flows,allregionsframes,similarities]=getMenu(cim,ucm2,flows,allregionsframes,similarities,allregionpaths,correspondentlengthpath,usetotpaths);

% %forward/backward dynamic programming with sums of logarithms
% forwardSimilarities=Invertsimilarities(similarities);
% chosenSimilars=Get_probability_paths(similarities); %equivalent of Getpaths, but initialising with 0 and taking sum of logarithms (product of probabilities)
% chosenforwardSimilars=Get_probability_paths(forwardSimilarities);
% noFrames=size(chosenforwardSimilars,2);
% for frame=1:fix(noFrames/2)
%     tmp=chosenforwardSimilars{frame};
%     chosenforwardSimilars{frame}=chosenforwardSimilars{noFrames-frame+1};
%     chosenforwardSimilars{noFrames-frame+1}=tmp;
% end
% allregionpaths=Get_bidirectional_dp_with_probabilities(chosenSimilars,chosenforwardSimilars,similarities); %equivalent of Getbidirectionalpaths,
%                                                                             %but initialising with 0 and taking sum of logarithms (product of probabilities)
% totPaths=numel(allregionpaths.totalLength);
% % load(filenames.filename_map)
% map=Scramble(totPaths);
% correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
% correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);

%backward dynamic programming
% load D:\regframe_1to70.mat
% load D:\similars_1to70.mat
% chosenSimilars=Getpaths(similarities);
% allregionpaths=Getmonodirectionalpaths(chosenSimilars);
% totPaths=numel(allregionpaths.totalLength);
% map=Scramble(totPaths);
% correspondentPath=Getcorrespondingbilabel(allregionsframes,allregionpaths,map);
% correspondentlengthpath=Getcorrespondingbilabel(allregionsframes,allregionpaths,allregionpaths.totalLength);
% load d:\filename.mat
% [flows,allregionsframes,similarities]=getMenu(cim,ucm2,flows,allregionsframes,similarities,allregionpaths,correspondentPath);
% usetotpaths=0;
% [flows,allregionsframes,similarities]=getMenu(cim,ucm2,flows,allregionsframes,similarities,allregionpaths,correspondentlengthpath,usetotpaths);

