function [similarities,framebelong]=Case_eight_frames_long_term(includenoise,temporalsmoothing)
%[similarities,framebelong]=Case_eight_frames_long_term();

if ( (~exist('temporalsmoothing','var')) || (isempty(temporalsmoothing)) )
    temporalsmoothing=false;
end
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
%lt
similarities(1,9)=am;
similarities(1,13)=am;
similarities(1,17)=am;
similarities(1,21)=am;
similarities(1,25)=am;
similarities(1,29)=am;
similarities(5,13)=am;
similarities(5,17)=am;
similarities(5,21)=am;
similarities(5,25)=am;
similarities(5,29)=am;
similarities(9,17)=am;
similarities(9,21)=am;
similarities(9,25)=am;
similarities(9,29)=am;
similarities(13,21)=am;
similarities(13,25)=am;
similarities(13,29)=am;
similarities(17,25)=am;
similarities(17,29)=am;
similarities(21,29)=am;


%component 2
similarities(4,8)=am;
similarities(8,12)=am;
similarities(12,16)=am;
similarities(20,16)=am;
similarities(20,24)=am;
similarities(24,28)=am;
similarities(32,28)=am;
%lt
similarities(4,12)=am;
similarities(4,16)=am;
similarities(4,20)=am;
similarities(4,24)=am;
similarities(4,28)=am;
similarities(4,32)=am;
similarities(8,16)=am;
similarities(8,20)=am;
similarities(8,24)=am;
similarities(8,28)=am;
similarities(8,32)=am;
similarities(12,20)=am;
similarities(12,24)=am;
similarities(12,28)=am;
similarities(12,32)=am;
similarities(16,24)=am;
similarities(16,28)=am;
similarities(16,32)=am;
similarities(20,28)=am;
similarities(20,32)=am;
similarities(24,32)=am;


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
%
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
%lt
%toleft
similarities(2,10)=am;
similarities(2,14)=am;
similarities(2,18)=pm;
similarities(2,19)=pm;
similarities(2,22)=am;
similarities(2,26)=am;
similarities(2,30)=am;
similarities(3,11)=am;
similarities(3,15)=am;
similarities(3,18)=pm;
similarities(3,19)=pm;
similarities(3,23)=am;
similarities(3,27)=am;
similarities(3,31)=am;
%toright
similarities(6,14)=pm;
similarities(6,15)=pm;
similarities(6,18)=am;
similarities(6,22)=pm;
similarities(6,23)=pm;
similarities(6,26)=pm;
similarities(6,27)=pm;
similarities(6,30)=pm;
similarities(6,31)=pm;
similarities(7,14)=pm;
similarities(7,15)=pm;
similarities(7,19)=am;
similarities(7,22)=pm;
similarities(7,23)=pm;
similarities(7,26)=pm;
similarities(7,27)=pm;
similarities(7,30)=pm;
similarities(7,31)=pm;
%toleft
similarities(10,18)=pm;
similarities(10,19)=pm;
similarities(10,22)=am;
similarities(10,26)=am;
similarities(10,30)=am;
similarities(11,18)=pm;
similarities(11,19)=pm;
similarities(11,23)=am;
similarities(11,27)=am;
similarities(11,31)=am;
%toleft
similarities(14,22)=am;
similarities(14,26)=am;
similarities(14,30)=am;
similarities(15,23)=am;
similarities(15,27)=am;
similarities(15,31)=am;
%toright
similarities(18,26)=pm;
similarities(18,27)=pm;
similarities(18,30)=pm;
similarities(18,31)=pm;
similarities(19,26)=pm;
similarities(19,27)=pm;
similarities(19,30)=pm;
similarities(19,31)=pm;
%toleft
similarities(22,30)=am;
similarities(23,31)=am;

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

nototframes=max(framebelong);
if (temporalsmoothing)
    for i=1:nototframes
        atframei=find(framebelong==i);
        for j=i+2:nototframes
            
            atframej=find(framebelong==j);
            
            for ki=atframei
                for kj=atframej
                    if (similarities(ki,kj)>0)
                        similarities(ki,kj)=similarities(ki,kj)/(j-i);
                        similarities(kj,ki)=similarities(kj,ki)/(j-i);
%                         fprintf('*');
                    end
                end
            end
            
        end
    end
%     fprintf('Smoothed\n');
end %endif

