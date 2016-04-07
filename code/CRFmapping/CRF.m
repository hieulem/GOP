addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));

%ASSIGN LABELS FROM source_frame to SP of target_frame i.e. where the SP from F1 should be located in F2
nf=10;
for source_frame =1:5
    %close all
    %source_frame =1;   %label
    Unary =[];dist_matrix=[];edge_index=[];
    target_frame = source_frame+1;   %var
    spi = sp(:,:,source_frame);
    
    dist_matrix = pop_dist_all(geo_hist{target_frame},pos{target_frame},L_hist{target_frame},A_hist{target_frame},B_hist{target_frame},...
        H_hist{target_frame},S_hist{target_frame},V_hist{target_frame},...
        geo_hist{source_frame},pos{source_frame},L_hist{source_frame},A_hist{source_frame},B_hist{source_frame},H_hist{source_frame},S_hist{source_frame},V_hist{source_frame});
    
    phi = 0.3;
    Unary =dist_matrix;
    
    
    % dist_matrix2 = pop_dist_all(geo_hist{source_frame},pos{source_frame},L_hist{source_frame},A_hist{source_frame},B_hist{source_frame},...
    %     H_hist{source_frame},S_hist{source_frame},V_hist{source_frame},...
    %     geo_hist{source_frame},pos{source_frame},L_hist{source_frame},A_hist{source_frame},B_hist{source_frame},H_hist{source_frame},S_hist{source_frame},V_hist{source_frame});
    % %Smooth =  exp(-dist_matrix2/1);
    
    num_label = splist(source_frame);
    num_sp = splist(target_frame);
    
    %exracting edge from 1st frame
    neighbor = sparse(pop_adjacent_matrix(sp(:,:,target_frame)));
    numedges = numel(find(neighbor));
    edge = find(neighbor);
    [from,to] = ind2sub(size(neighbor),edge);
    edge_index = [from,to];
    
    %ASSIGN LABELS FROM target_frame to SP of source_frame i.e. where the SP from F1 should be located in F2
    
    
    
    %Local smooth  function for each edge
    tic;
    smatrix= cell(numedges,1);
    direction = zeros(numedges,2);
    parfor i=1:numedges
        i;
        direction(i,:) = pos{target_frame}(edge_index(i,1),:) - pos{target_frame}(edge_index(i,2),:);
        
        %move each label in direction
        offset_pos =  pos{source_frame} + repmat(direction(i,:),[num_label,1]);
        tmp = pdist2(offset_pos,pos{source_frame}, 'euclidean' );
        tmp = exp (-tmp/20);
        tmp(tmp<1e-5) = 0;
        tmp(logical(eye(size(tmp))))= 0;
        smatrix{i} =repmat(Unary(edge_index(i,1),:),[num_label,1]).*tmp;
    end
    %smatrix(smatrix<1e-5) = 0;
    toc;
    %smatrix = sparse(smatrix);
    
    
    %BP
    all_message = zeros(numedges,num_label);
    new_message =all_message;
    
    %Init
    
    for i=1:num_sp
        index = find(edge_index(:,2,:) == i);
        all_message(index,:) =  repmat(init_message(Unary(i,:),smatrix{i}),[length(index),1]);
    end
    first_mess =all_message;
    count=0;
    while count<5
        %passing
        for i=1:numedges
            tmp= edge_index(i,:);
            f= tmp(1);
            t= tmp(2);
            nbset = find(neighbor(f,:));
            
            nbset(nbset==t) = [];
            nbset(nbset==f) = [];
            
            msset1 = find(edge_index(:,1)==t);
            msset2 = find(edge_index(:,2)==f);
            msset2(msset2==intersect(msset1,msset2)) = [];
            previous_mess=all_message(msset2,:);
            factor = ones(1,num_label);
            
            
            for k=1:length(msset2)
                factor = factor.*previous_mess(k,:);
            end
            %    factor = factor';
            %  factor = repmat(factor,[1,num_label]);
            %   bas_matrix = repmat(Unary(f,:),[num_label,1]).*smatrix{i};
            
            current_mess = smatrix{i}*factor';
            % current_mess = sum(current_mess,2);
            current_mess = current_mess/(sum(current_mess));
            new_message(i,:) = current_mess';
        end
        all_message = new_message;
        count=count+1
    end;
    
    %MAP
    
    for i=1:num_sp
        edset = find(edge_index(:,2)==i);
        
        belief = Unary(i,:);
        for j = 1:length(edset)
            belief = belief.* all_message(edset(j),:);
        end
        [~,MAP{target_frame}(i)] = max(belief);
    end
end;



map{1} =  [[1:splist(1)]',[1:splist(1)]'];
aa=sp(:,:,1:nf);
for i=2:nf 
map{i} = [[1:splist(i)]',MAP{i}'];
map{i} = convertmap2map(map{i},map{i-1});
aa(:,:,i)  = convertspmap(sp(:,:,i),map{i});

end;
% map{3} = [[1:splist(target_frame)]',MAP{target_frame}'];
% aa(:,:,1)  = sp(:,:,2);
% aa(:,:,2)  = convertspmap(sp(:,:,3),map{3});
vn
gen_cl_from_spmap(aa,'fg');
%figure();imagesc(aa);
%figure(); t=uint8((gen_cl_from_spmap(sp_test)));imagesc(t);

