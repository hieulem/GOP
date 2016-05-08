function [ output_args ] = ev( sv_map,ppm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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

er = 100*sum(molecular)/denominator;

stat = er;

end

