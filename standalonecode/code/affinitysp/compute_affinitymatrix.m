function [ affinity_matrix,iqrTruncation ] = compute_affinitymatrix( sp,splist,edge,img,options)
%COMPUTE_AFFINITYMATRIX
% sp: sp map 1:splist(i)
% splist=[400,420,400...]
% edge h*w*numi

numi = size(img,4);
cumspn = [0,cumsum(splist)];
numsp = sum(splist);
h= size(img,1);w= size(img,2);
tic
k=max(splist);
seeds_geo = -ones(numi,k,k);
for ii=1:numi
    nsp = splist(ii);
    %  seeds_geo{ii} = zeros(nsp,nsp);
    seeds_color{ii} = zeros(nsp,1);
    seeds{ii} = 1:nsp;
    pos =zeros(nsp,2);
    Z = spAffinities_vu(sp(:,:,ii),edge(:,:,ii));
    Z(Z<0) =0 ;Z = sparse(double(Z));
    
    area{ii} =zeros(1,nsp);
    grimg = rgb2gray(img(:,:,:,ii));
    for k =1:nsp
        area{ii}(k) = sum(sum(sp(:,:,ii) == k))/(h*w);
    end
    
    for i=1:length(seeds{ii})
        
        seeds_geo(ii,i,1:nsp) = geocompute(Z,seeds{ii}(i));
        seeds_color{ii}(i) = rgb_mean(grimg,sp(:,:,ii),i);
        pos(i,:) = computesppos(sp(:,:,ii),i);
    end;
    if (options.phi > 0)
        gaussiandis{ii} = pdist2(pos,pos,'euclidean');
        gaussiandis{ii} = exp(-gaussiandis{ii}/options.phi);
    else
        gaussiandis{ii} = ones(length(seeds{ii}),length(seeds{ii}));
    end;
end

if options.maxGeo ==0
    %% truncation point computation by the IQR rule
    q3 = prctile(seeds_geo(:), 75);
    myIQR = iqr(seeds_geo(:));
    iqrTruncation = q3+1.5*myIQR;  %try to make 1.5 into 3 and see what happens.
    options.maxGeo= iqrTruncation ;
end

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
        
        a=toc;
        display(['Features computed in ',num2str(a)]);
        affinity_matrix = sparse(zeros(numsp,numsp));
        tic
        for i=1:numi-1
            hist_dist_o = mypdist2(geo_hist2d{i},geo_hist2d{i+1},'chisq2d');
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i+1)+1) : cumspn(i+2)) = hist_dist_o;
            affinity_matrix((cumspn(i+1)+1) : cumspn(i+2),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o';
        end
        toc
        tic
        for i=1:numi
            hist_dist_o = mypdist2(geo_hist2d{i},geo_hist2d{i},'chisq2d');
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o;
        end
        toc
    case '1d'
        display(['Feature type: geodesic']);
        geo_hist1d = cell(numi,1);
        for ii=1:numi
            geo_hist1d{ii} = zeros(length(seeds{ii}),options.nGeobins);
            for i=1:length(seeds{ii})
                geo_hist1d{ii}(i,:)=histwc(squeeze(seeds_geo(ii,i,1:splist(ii)))',area{ii}.*gaussiandis{ii}(i,:),options.nGeobins,options.maxGeo);
            end
        end
        
        a=toc;
        display(['Features computed in ',num2str(a)]);
        affinity_matrix = sparse(zeros(numsp,numsp));
        tic
        for i=1:numi-1
            hist_dist_o = mypdist2(geo_hist1d{i},geo_hist1d{i+1},'chisq');
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i+1)+1) : cumspn(i+2)) = hist_dist_o;
            affinity_matrix((cumspn(i+1)+1) : cumspn(i+2),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o';
        end
        toc
        tic
        for i=1:numi
            hist_dist_o = mypdist2(geo_hist1d{i},geo_hist1d{i},'chisq');
            affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_o;
        end
        toc
end
end




