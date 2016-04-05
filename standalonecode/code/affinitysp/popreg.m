function [ th ] = popreg( I,se,Z,sp )
%POPREG Summary of this function goes here
%   Detailed explanation goes here
%a= outputs{3};
%seed = outputs{2}(1)
bg_set = unique([sp([1,end],:),sp(:,[1,end])']);
current = geocompute(Z,bg_set(1));
bg_distance =  current;
for i=2:length(bg_set)
    current = geocompute(Z,bg_set(i));
    bg_distance = min([bg_distance;current],[],1);
end
count =0;score=[];thresholds=[];seed_no=[];
for j =1:length(se)    
    seed = se(j);
    if bg_distance(seed) ==0
        continue;
    end;
    fg_distance= geocompute(Z,seed);
    
    dist_ = fg_distance - bg_distance;
    [sorted_d,t] = sort(dist_,2,'ascend');
    sorted_d_gra = [0,sorted_d(2:end) - sorted_d(1:end-1)];
    sorted_d_graL = [0,sorted_d_gra(2:end) - sorted_d_gra(1:end-1)];
    sorted_d_graR = [0,sorted_d_gra(2:end-1) - sorted_d_gra(3:end),0];
    t=0;
    a1=  sorted_d_gra>t;
    a2=  sorted_d_graL>t;
    a3 = sorted_d_graR>t;
    
    picked = a1.*a2.*a3;
    thresholds = [thresholds,sorted_d(find(picked>0))];
    score= [score,sorted_d_gra(find(picked>0))];
    seed_no=[seed_no,ones(1,length(find(picked>0)))*j];
end

[sorted_score,idx] = sort(score,'descend');
count =0;
i=0;
while count<30 && i< length(idx)
    i=i+1;
    seed_num = se(seed_no(idx(i)));
    th(i) = thresholds(idx(i));
    dist_ = geocompute(Z,seed_num) - bg_distance;
    [props,splist] =  pop_im_from_seed(I,sp,th(i),dist_);
    if sum(splist)>size(Z,1)/2
        continue;
    end;
    flag =true;
    for k=1:count
        t= sum(abs(splist-list(k,:)));
        if t<3
            flag =false;
            break;
        end;
    end
    if flag
        count = count+1;
        list(count,:) = splist;
        subplot(5,6,count,'align');
        image(uint8(props));
    end
    
end

% for i=1:10
%     subplot(3,4,i,'align')
%     prop{i} = find(fg_distance< ival*topdk(i));
%     spp = sp*0;
%     for j=1:length(prop{i})
%         
%         spp(sp == prop{i}(j))=1;
%         
%     end
%     
%     
%     image([ uint8(I).*uint8(repmat(spp,[1,1,3]))]);
% end

end

