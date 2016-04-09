function sv_list = Listmatchevcompute(sv_map)
% sv_list = Listmatchevcompute(sv_map)
% sv_map: video output segmentation frames encoded into
%   rgb color space, each segment has its unique color
% sv_map: supervoxel index map with size: I_h x I_w x frame_num, which is a
%   3D video volume
% sv_list: supervoxel status list with size: supervoxel number x 
%   (frame number + 1), first column is supervoxel index, following columns
%   are the binary status of each supervoxel in that frame
%   1 - exist, 0 - not exist
%
% modifed by Fabio Galasso
% July 2012

%sv_map coincides with the segmentation video output
%sv_map=video;
noFrames=size(sv_map,3);

%sv_list(:,1) is a list of labels
%sv_list(:,2:noFrames+1) corresponds to the video, it gives the reference to the unique labels of sv_list(:,1)
sv_list = zeros(size(unique(sv_map),1), noFrames+1);
sv_list(:,1) = unique(sv_map);

for i=1:noFrames
    sv_list(:,i+1) = ismember(sv_list(:,1), sv_map(:,:,i));
end