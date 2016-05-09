function [ newmess] = update_message( me,big_message,my_small_message,neighbor)
k=find(neighbor(me,:));
k(k==me) = [];
message_from_neighbor = big_message(k,:);
newmess = my_old_message;
for i=1:length(k)
    mess_from_ith_neighbor = message_from_neighbor(i,:)  - my_small_message;
    mess_from_ith_neighbor = mess_from_ith_neighbor/ sum(mess_from_ith_neighbor);
    newmess = newmess.*mess_from_ith_neighbor;
end
newmess(newmess == inf) = 0;
newmess(isnan(newmess)) = 0;
newmess = newmess/(sum(newmess));
newmess(isnan(newmess)) = 0;
end

