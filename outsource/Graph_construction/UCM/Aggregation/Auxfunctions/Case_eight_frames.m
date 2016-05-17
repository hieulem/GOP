function [similarities,framebelong]=Case_eight_frames(includenoise)
%[similarities,framebelong]=Case_eight_frames();

if ( (~exist('includenoise','var')) || (isempty(includenoise)) )
    includenoise=false;
end


am=0.99; %full match score
nam=0.1; %not a match score, noise term
pm=0.5; %partial match score for segments re-arranging
pmi=0.5; %partial match score for induced connections, see also Getspatialterms


similarities=sparse(32,32);


%component 1
similarities(1,5)=am;
similarities(9,5)=am;
similarities(9,13)=am;
similarities(17,13)=am;
similarities(17,21)=am;
similarities(21,25)=am;
similarities(29,25)=am;


%component 2
similarities(4,8)=am;
similarities(8,12)=am;
similarities(12,16)=am;
similarities(20,16)=am;
similarities(20,24)=am;
similarities(24,28)=am;
similarities(32,28)=am;


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

similarities(14,18)=pm;
similarities(14,19)=pm;
similarities(15,18)=pm;
similarities(15,19)=pm;
similarities(22,18)=pm;
similarities(22,19)=pm;
similarities(23,18)=pm;
similarities(23,19)=pm;
similarities(23,27)=am;
similarities(22,26)=am;
similarities(31,27)=am;
similarities(30,26)=am;


if (includenoise)
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

    similarities(13,18)=nam;
    similarities(16,18)=nam;
    similarities(20,15)=nam;
    similarities(17,14)=nam;
    similarities(23,20)=nam;
    similarities(17,22)=nam;
    similarities(21,18)=nam;
    similarities(24,18)=nam;
    similarities(24,27)=nam;
    similarities(26,21)=nam;
    similarities(22,25)=nam;
    similarities(23,28)=nam;
    similarities(32,27)=nam;
    similarities(26,29)=nam;
    similarities(30,25)=nam;
    similarities(31,28)=nam;
end

%induced terms
% similarities(2,3)=pmi;
% similarities(6,7)=pmi;
% similarities(10,11)=pmi;
% similarities(14,15)=pmi;


%Make the similarities matrix symmetric
similarities=max(similarities,similarities');


%Define framebelong
framebelong=[ones(1,4),2*ones(1,4),3*ones(1,4),4*ones(1,4),5*ones(1,4),6*ones(1,4),7*ones(1,4),8*ones(1,4)];

