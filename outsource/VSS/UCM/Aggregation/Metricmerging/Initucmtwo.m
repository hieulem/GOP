function newucm2=Initucmtwo(framerange,ucm2,includeoversegmentation,mindepth)

if ( (~exist('mindepth','var')) || (isempty(mindepth)) )
    mindepth=1;
end
if ( (~exist('includeoversegmentation','var')) || (isempty(includeoversegmentation)) )
    includeoversegmentation=true; %addition of lower level with all over-segments
end

%Initialisation
newucm2=cell(1,numel(framerange));
for f=framerange
    newucm2{f}=uint8(zeros(size(ucm2{1})));
    if (includeoversegmentation)
        newucm2{f}=newucm2{f}+uint8((ucm2{f}>0)*mindepth);
    end
end

