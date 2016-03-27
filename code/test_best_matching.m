%mergetest;
%input.numi=5;
phi=1;
map{1} = [[1:splist(1)]',[1:splist(1)]'];
for frame=1:input.numi-1
    frame1= frame;
    frame2 = frame +1;
    dist_matrix = pop_dist_all(geo_hist{frame},pos{frame},L_hist{frame},A_hist{frame},B_hist{frame},...
                        H_hist{frame},S_hist{frame},V_hist{frame},...
    geo_hist{frame2},pos{frame2},L_hist{frame2},A_hist{frame2},B_hist{frame2},H_hist{frame2},...,
    S_hist{frame2},V_hist{frame2});

    [score,x] =max(dist_matrix,[],2);
    score;
    
    
    map{frame1} = [[1:splist(frame1)]',x];

     %map{frame1}(score<0.001,2) =0;
   % map{frame1}(score<0.1,2) =0;
 %   map{frame}(score<0.9) = 
  %  map{frame} = convertmap2map(map{frame},map{frame-1});
    
    
end
%post_process
gen_color




%sp2(:,:,1) = convertspmap(sp2(:,:,1),1:splist(1),map{1});


%en_color;
