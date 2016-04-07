% map=[];
% 
% for frame=1:20
%     map{frame} = [[1:length(MAP{frame})]',MAP{frame}'];
% end
% 

allsp =double(0);
%map{1} = [[1:splist(1)]',[1:splist(1)]'];
sp2 = sp;
for frame=1:20
    numsp = double(splist(frame));  
    ind=map{frame}(:,2)==0 ;
    map{frame}= map{frame}  + allsp;
     map{frame}(:,2) = map{frame}(:,2) + numsp;
     if ~isempty(ind)
        map{frame}(ind,2) = 0;
     end
    
    sp2(:,:,frame) = sp2(:,:,frame) + allsp;
    allsp = allsp +numsp;
    %map{frame} = convertmap2map(map{frame},map{frame-1});
%    convertmap2map(map{frame},map{frame-1});
end

map{21} = [[(allsp+1):(allsp+splist(21))]',[(allsp+1):(allsp+splist(21))]'];
for frame=20:-1:1
    map{frame} = convertmap2map(map{frame},map{frame+1});
end