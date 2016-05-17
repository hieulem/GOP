function backmap=Mapitback(themap,nobels)



if ( (~exist('nobels','var')) || (isempty(nobels)) )
    nobels=max(themap(:));
end


backmap=zeros(1,nobels);
backmap(themap)=1:numel(themap);
% backmap=zeros(1,nobels);
% for i=1:numel(themap)
%     backmap(themap(i))=i;
% end



function test() %#ok<DEFNU>

activetracks=[1,4,5];
nobels=5;

backmap=Mapitback(activetracks,nobels);
backmap=Mapitback(activetracks);

nobels=6;
backmap=Mapitback(activetracks,nobels);