function [Uflow,Vflow]=Rerangeflows(Uflow,Vflow,newmin,newmax,usetanh,usemeanstd,phasedifference,usemagnitudemin,usemagnitudemax,printonscreen)
%The function reranges the magnitude of Uflow and Vflow
%Input paramters are explained in Rerangeimage

if ( (~exist('usemagnitudemin','var')) || (isempty(usemagnitudemin)) )
    usemagnitudemin=[];
end
if ( (~exist('usemagnitudemax','var')) || (isempty(usemagnitudemax)) )
    usemagnitudemax=[];
end
if ( (~exist('newmin','var')) || (isempty(newmin)) )
    newmin=0;
end
if ( (~exist('newmax','var')) || (isempty(newmax)) )
    newmax=1;
end
if ( (~exist('usetanh','var')) || (isempty(usetanh)) )
    usetanh=false;
end
if ( (~exist('usemeanstd','var')) || (isempty(usemeanstd)) )
    usemeanstd=false;
end
if ( (~exist('phasedifference','var')) || (isempty(phasedifference)) )
    phasedifference=0; %Change phase in the process, to align flowplus and minus
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

magnitude=sqrt(Uflow.^2+Vflow.^2);
theta=atan2(Vflow,Uflow);

% r = abs(z)
% theta = atan2(imag(z),real(z))
% z = r *exp(i *theta)

%Compute normalized magnitude to raqnge [0,1]
newmagnitudemin=0;
newmagnitudemax=1;
magnitude=Rerangeimage(magnitude,newmagnitudemin,newmagnitudemax,usetanh,usemeanstd,usemagnitudemin,usemagnitudemax,printonscreen);

%The new theoretical min (min(magnitude(:))) and max (max(magnitude(:))) of magnitude are 0 and 1

Uflow=0.5*magnitude.*cos(theta+phasedifference)+0.5;
Vflow=0.5*magnitude.*sin(theta+phasedifference)+0.5;

%The new theoretical min (min(Uflow(:))) and max (max(Uflow(:))) of Uflow are 0 and 1

%Normalize the Uflow and Vflow images to [newmin,newmax]
Uflow= Uflow * (newmax-newmin) + newmin;
Vflow= Vflow * (newmax-newmin) + newmin;


function Checkcorrespondence(Uflow,Vflow) %#ok<DEFNU>

Init_figure_no(304), imagesc(Uflow), title('U flow');
Init_figure_no(305), imagesc(Vflow), title('V flow');

magnitude=sqrt(Uflow.^2+Vflow.^2);
theta=atan2(Vflow,Uflow);

Uflow=magnitude.*cos(theta);
Vflow=magnitude.*sin(theta);

Init_figure_no(306), imagesc(Uflow), title('U flow');
Init_figure_no(307), imagesc(Vflow), title('V flow');
