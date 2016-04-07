function [ newmess] = update_message_1st_time( here,old_message,neighbor)
k=find(neighbor(here,:));
k(k==here) = [];
message_from_neighbor = old_message(k,:);
newmess = sum(message_from_neighbor(k,:),[],2) ;
%newmess = newmess./(sum(newmess));
end

