function [ geo_hist2d ] = compute_affinitymatrix( sp,edge,grayimg,splist)
%COMPUTE_AFFINITYMATRIX Summary of this function goes here
%   Detailed explanation goes here
numi = size(grayimg,3);
geo_hist2d = cell(numi,1);
seeds=cell(numi,1);
area=cell(numi,1);
pos =cell(numi,1);
seeds_color=cell(numi,1);
seeds_geo =cell(inp.numi,1);



for ii=1:inp.numi
    Z = spAffinities_vu(sp(:,:,ii),edge(:,:,ii));
    Z(Z<0) =0 ;Z = sparse(double(Z));
    nsp = splist(ii);
    area =zeros(1,nsp);
    for k =1:nsp
        area{ii}(k) = sum(sum(sp(:,:,ii) == k))/(h*w);
    end
    seeds{ii}(:) = 1:nsp;
    for i=1:length(seeds{ii})
        seeds_geo{ii}(i,:) = geocompute(Z,seeds{ii}(i));
        seeds_color{ii}(i,:) = rgb_mean(itsimage,sp(:,:,ii),i);
        pos{ii}(i,:) = computesppos(sp(:,:,ii),i);
    end;
    gaussiandis = pdist2(pos{ii},pos{ii},'euclidean');  gaussiandis = exp(-gaussiandis/10);
    for i=1:length(seeds{ii})
      %  geo_hist{ii}(i,:)=histwc(seeds_geo{ii}(i,:),area{ii}.*gaussiandis(i,:),geo_hist_bin,max(max(seeds_geo{ii})));
        geo_hist2d{ii}(i,:,:)=histwc2D(seeds_geo{ii}(i,:),seeds_color{ii},area{ii}.*gaussiandis(i,:),9,13,5,255);
    end
    
end


end




