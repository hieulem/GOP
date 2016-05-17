function [similarities,framebelong]=Case_four_frames()

am=1; %full match score
nam=0.1; %not a match score, noise term
pm=0.5; %partial match score for segments re-arranging
pmi=0.5; %partial match score for induced connections, see also Getspatialterms


similarities=sparse(16,16);


%component 1
similarities(1,5)=am;
similarities(9,5)=am;
similarities(9,13)=am;

%component 2
similarities(4,8)=am;
similarities(8,12)=am;
similarities(12,16)=am;

%component 3
similarities(2,6)=pm;
similarities(2,7)=pm;
similarities(3,6)=pm;
similarities(3,7)=pm;
similarities(10,6)=pm;
similarities(10,7)=pm;
similarities(11,6)=pm;
similarities(11,7)=pm;
similarities(11,15)=am;
similarities(10,14)=am;
%modified
% similarities(2,6)=am;
% similarities(2,7)=nam;
% similarities(3,6)=am;
% similarities(3,7)=nam;
% similarities(10,6)=am;
% similarities(10,7)=nam;
% similarities(11,6)=am;
% similarities(11,7)=nam;

%noise
similarities(1,6)=nam;
similarities(4,6)=nam;
similarities(8,3)=nam;
similarities(5,2)=nam;
similarities(11,8)=nam;
similarities(5,10)=nam;
similarities(9,6)=nam;
similarities(12,6)=nam;
similarities(12,15)=nam;
similarities(14,9)=nam;
similarities(10,13)=nam;
similarities(11,16)=nam;

%induced terms
% similarities(2,3)=pmi;
% similarities(6,7)=pmi;
% similarities(10,11)=pmi;
% similarities(14,15)=pmi;


%Make the similarities matrix symmetric
similarities=max(similarities,similarities');


%Define framebelong
framebelong=[ones(1,4),2*ones(1,4),3*ones(1,4),4*ones(1,4)];

