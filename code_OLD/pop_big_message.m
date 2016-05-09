function [ mess] = pop_big_message( my_init_belief,me,small_message_from_others,neighbor)
k= size(smooth,1);
mess = repmat(my_init_belief,[k,1]);
mess = mess.*smooth;
nnb = find(neighbor(me,:));
for i=1:length(nnb)
    mess= mess.*small_message_from_others(nnb(i),:);
end
%mess = sum(mess,1);

end

