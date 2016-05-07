function [ affinity_matrix ] = affinity_extract(numi,numsp,seeds, seeds_geo,splist,seeds_color,area,gaussiandis,options )
%AFFINITY_EXTRACT Summary of this function goes here
%   Detailed explanation goes here
cumspn = [0,cumsum(splist)];
numsp = sum(splist);
switch options.type
    case '2d'
        display(['Feature type: geodesic-intensity']);
        geo_hist2d = cell(numi,1);
        for ii=1:numi
            geo_hist2d{ii} = zeros(length(seeds{ii}),options.nGeobins,options.nIntbins);
            for i=1:length(seeds{ii})
                geo_hist2d{ii}(i,:,:)=histwc2D(squeeze(seeds_geo(ii,i,1:splist(ii)))',seeds_color{ii}',area{ii}.*gaussiandis{ii}(i,:),options.nGeobins,options.nIntbins,options.maxGeo,options.maxInt);
            end
        end
        

        affinity_matrix = sparse(zeros(numsp,numsp));
        
        for i=1:numi-1
            hist_dist_o = mypdist2(geo_hist2d{i},geo_hist2d{i+1},options.metric);
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i+1)+1) : cumspn(i+2)) = hist_dist_o;
            affinity_matrix((cumspn(i+1)+1) : cumspn(i+2),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o';
        end

        for i=1:numi
            hist_dist_o = mypdist2(geo_hist2d{i},geo_hist2d{i},options.metric);
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o;
        end

    case '1d'
        display(['Feature type: geodesic']);
        geo_hist1d = cell(numi,1);
        for ii=1:numi
            geo_hist1d{ii} = zeros(length(seeds{ii}),options.nGeobins);
            for i=1:length(seeds{ii})
                geo_hist1d{ii}(i,:)=histwc(squeeze(seeds_geo(ii,i,1:splist(ii)))',area{ii}.*gaussiandis{ii}(i,:),options.nGeobins,options.maxGeo);
            end
        end
        

        affinity_matrix = sparse(zeros(numsp,numsp));
       
        for i=1:numi-1
            hist_dist_o = mypdist2(geo_hist1d{i},geo_hist1d{i+1},options.metric);
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i+1)+1) : cumspn(i+2)) = hist_dist_o;
            affinity_matrix((cumspn(i+1)+1) : cumspn(i+2),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o';
        end

        for i=1:numi
            hist_dist_o = mypdist2(geo_hist1d{i},geo_hist1d{i},options.metric);
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o;
        end
end
end

