function [ x ] = nchbest( fr,final_dist2,sp,splist )
%NCHBEST Summary of this function goes here
%   Detailed explanation goes here
%nspp = sp;
[~,x] = max(final_dist2,[],1);
%nlb = sp(:,:,fr);
%nlb = convertspmap(nlb,1:splist(fr),x);

%nspp(:,:,fr) = nlb;


end

