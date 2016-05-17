function col=GiveDifferentColours(no,repratio)
%if repratio is (x+1)/x then 2x different colours maximally spaced are
%produced if x+1 is odd, otherwise half of the colours are produced 
%if repratio == 2*(x+1)/x then exactly x colours are produced

%GiveDifferentColours(1,4/3) outputs [0,0,1] corresponding to blue
%GiveDifferentColours(0,4/3) outputs [1,0,0] corresponding to red
%GiveDifferentColours( 1-similarity , 4/3 ) outputs colours according to matlab notation

if ( (~exist('repratio','var')) || (isempty(repratio)) )
    repratio=11/10; % 46/45 39/38 46/45 86/85 70/69 14/15 26/25
end

angle=no*pi*repratio;
img = computeColor(cos(angle),sin(angle));

col=zeros(1,3);
col(1)=img(1,1,1);
col(2)=img(1,1,2);
col(3)=img(1,1,3);

col=double(col)/255;



function col=GiveDifferentColours_new_compatiblewithvectors(no,repratio) %#ok<DEFNU>
%if repratio is (x+1)/x then 2x different colours maximally spaced are
%produced if x+1 is odd, otherwise half of the colours are produced 
%if repratio == 2*(x+1)/x then exactly x colours are produced

%GiveDifferentColours(1,4/3) outputs [0,0,1] corresponding to blue
%GiveDifferentColours(0,4/3) outputs [1,0,0] corresponding to red
%GiveDifferentColours( 1-similarity , 4/3 ) outputs colours according to matlab notation

if ( (~exist('repratio','var')) || (isempty(repratio)) )
    repratio=11/10; % 46/45 39/38 46/45 86/85 70/69 14/15 26/25
end

if ((size(no,2)~=1)&&(size(no,1)==1))
    no=no';
end

angle=no.*pi.*repratio;
img = computeColor(cos(angle),sin(angle));

col=squeeze(img);
if (numel(no)==1)
    col=col'; %for compatibility
end

col=double(col)/255;





