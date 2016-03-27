
for frame=2:input.numi
    
    frame
    
    
    [InframeConnection,ifdis] = pop_neighbor_matrix(frame,frame,pos,15);
    %ifdis = sparse(ifdis);
    [LabelConnection, lbdis] = pop_neighbor_matrix(frame,frame-1,pos,15);
    Unary = pop_unary_potentials(frame,geo_hist,pos,L_hist,A_hist,B_hist);
   % PairLabel = pop_pair_wise_potentials(frame,geo_hist,pos,L_hist,A_hist,B_hist);
    siz = size(Unary);
    %
    
    
    U = reshape(Unary,1,[]);
    edge = sparse(LabelConnection*0);
    edgec = sparse(LabelConnection*0);
    cumenergy= sparse(LabelConnection*0);
    count =0;
    maxiter = 10000;
    while count<maxiter
        energy = [];
        state=[];
        nblabel=[];
        num_nblb=[];
        vertex=[];
        count=count+1;
        ind = randi(siz(1));
        lable = find(LabelConnection(ind,:));
        if (numel(lable) > 5)
            in = randi(numel(lable),1,5);
        %    [k,kk]= sort(lbdis(count,:),'ascend');
            lable = lable(in);
        end
        if (numel(lable) ==0 )
            [k,kk]= sort(lbdis(count,:),'ascend');
            lable = kk(1:2);
        end
        
        ver = find(InframeConnection(ind,:));
        if (numel(ver) > 5)
            in = randi(numel(ver),1,5);
           % [k,kk]= sort(ifdis(count,:),'ascend');
            ver = ver(in);
        end
        num_nblb=[];
        conf=[];
        
        
        numver =0;
        for i = 1:length(ver)
            nlabeli = find(LabelConnection(ver(i),:));
            
            cset= intersect(lable,nlabeli);
            if numel(cset)>0
                
                numver=numver+1;
                vertex(numver) = ver(i);
                nblabel{numver} = cset;
                nbspi= find(InframeConnection(ver(i),:));
                num_nblb(numver) = numel(nblabel{numver});
                conf(numver) = numel(intersect(nblabel{numver},nlabeli))/numel(nblabel{numver})...
                    * numel(intersect(nbspi,ver))/numel(nbspi);
                
            end;
            
            
        end
        if isempty(num_nblb)
            continue;
        end;
        
        total_case= prod(num_nblb);
        if total_case > 100000
            display('get backkkkkk!!');
            pause();
        end
        state = zeros(maxiter,total_case,2);
        
        
        for i=1:total_case
            ccase = myind2sub(num_nblb,i,length(num_nblb));
            for j=1:length(ccase)
                state(i,j,1)=vertex(j);
                state(i,j,2)=nblabel{j}(ccase(j));
            end
            
            energy(i)=0;
            for isp1 =1:numver
                energy(i) = energy(i)+ Unary(state(i,isp1,1),state(i,isp1,2));
            end
%             for isp1 =1:numver-1
%                 for isp2 =isp1+1:numver
%                     energy(i) = energy(i)+ PairValue(state(i,isp1,1),state(i,isp1,2) ...
%                         ,state(i,isp2,1),state(i,isp2,2),frame,pos);
%                     
%                 end
%             end
        end
        
        [e,optim] = min(energy);
        coptim = myind2sub(num_nblb,optim,length(num_nblb));
        for i=1:length(coptim)
            
            edge(state(optim,i,1),state(optim,i,2)) = conf(i);
            edgec(state(optim,i,1),state(optim,i,2)) = edgec(state(optim,i,1),state(optim,i,2)) +1;
            cumenergy(state(optim,i,1),state(optim,i,2)) = cumenergy(state(optim,i,1),state(optim,i,2))+e;
        end;
    end
    
    [~,b] = max(edge,[],2);
    map{frame} = b;
end
