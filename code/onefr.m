%mergetest;
%inp.numi=5;
addpath('./eval_code');
phi=1;
%c = spMerge(uint8(I(:,:,:,1)), double(sp(:,:,1)), percentile, lowerBound, colorSpace, modelSelection, optMethod, 0);
map{1} = [[1:splist(1)]',[1:splist(1)]'];
sp2=sp;
total = 0;
sf = 1;
ef =16;
for frame=1:inp.numi-1
    frame1= frame+1;
    frame2 = frame ;
    dist_matrix = pop_dist_all(geo_hist{frame1},geo_hist2d{frame1},pos{frame1},L_hist{frame1},A_hist{frame1},B_hist{frame1}, H_hist{frame1},S_hist{frame1},V_hist{frame1},...
    geo_hist{frame2},geo_hist2d{frame2},pos{frame2},L_hist{frame2},A_hist{frame2},B_hist{frame2},H_hist{frame2},...,
    S_hist{frame2},V_hist{frame2});

 %dist_matrix = pdist2(geo_hist2d{frame1},geo_hist2d{frame2},'chisq2d');

    [score,x] =sort(dist_matrix,2,'descend');
%   [x,~] = hungarian(-dist_matrix);
   % x((score(:,1)-score(:,2)) <0.1) = 0;
  %  x(score(:,1) <0.1) = 0;
    
    map{frame1} = [[1:splist(frame1)]' ,x(:,1)];

  %  map{frame1}(score(:,1)<0.5,:) =[];

end
   

vn = ['heree', video_name];



%m{1} = [[1:splist(sf)]',[1:splist(sf)]'];
%m{2} = map{ef};

sp2 = applymap(sp,splist,map);
gen_cl_from_spmap(sp2,vn);

num = evaluation_segtrackV2(vn,gtpath)
allnum = [allnum;num]
%imagesc([sp2(:,:,1), sp2(:,:,2)]);
%post_process
%gen_color




%sp2(:,:,1) = convertspmap(sp2(:,:,1),1:splist(1),map{1});


%en_color;
