function evstat = Explainedvariationcompute(sv_map,cim)
% stat = Explainedvariationcompute(sv_map)
%
% sv_map: supervoxel index map with size: I_h x I_w x frame_num, which is a
%   3D video volume
% sv_list: supervoxel status list with size: supervoxel number x 
%   (frame number + 1), first column is supervoxel index, following columns
%   are the binary status of each supervoxel in that frame
%   1 - exist, 0 - not exist
%
% modifed by Fabio Galasso
% July 2012


sv_list = Listmatchevcompute(sv_map);
[I_h, I_w, frame_num] = size(sv_map);
% Printthevideoonscreen(sv_map,true,6,true,[],[],true);

sv_num = size(sv_list,1);

ppm = zeros(I_h,I_w,3,frame_num);
for i=1:frame_num
    ppm(:,:,:,i) = cim{i};
end
ppm = double(ppm);

% global points set
points_set = reshape(ppm(:,:,:,1),I_h*I_w,3);
for i=2:frame_num
    points_set = cat(1, points_set, reshape(ppm(:,:,:,i), I_h*I_w, 3));
end

% global mean
mean_global = mean(points_set);
% denominator
denominator = sum(sum(bsxfun(@minus, points_set, mean_global).^2,2));

% compute for every sv
molecular = zeros(sv_num,1);
sv_points_num = zeros(sv_num,1);
for i=1:sv_num
    subpoints_idx = find(sv_map==sv_list(i,1));
    sv_points_num(i) = size(subpoints_idx,1);
    molecular(i) = sum((mean(points_set(subpoints_idx,:)) - mean_global).^2) * sv_points_num(i);
end

evstat = sum(molecular)/denominator;

