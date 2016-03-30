function [Y]=Getmanifoldandtreestructureprogressivemerge(similarities,dimtouse,n_size,...
    manifoldmethod,filenames,saveyre,options)

if ( (~exist('options','var')) || (~isstruct(options)) )
    options=struct();
end
if ( (~exist('manifoldmethod','var')) || (isempty(manifoldmethod)) )
    manifoldmethod='isoii'; %'iso','isoii','laplacian'
end
if ( (~exist('n_size','var')) || (isempty(n_size)) )
    n_size=0; %default is 7, 0 when neighbours have already been selected
end
if ( (~exist('saveyre','var')) || (isempty(saveyre)) )
    saveyre=false; %if the variable is not saved, it is not loaded either
end
if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=3;
end
if ( strcmp(manifoldmethod,'isoii') || strcmp(manifoldmethod,'laplacian') )
    usesparse=true;
else
    usesparse=false;
end
printonscreeninsidefunction=false;


D=Dfromsimilarities(similarities,usesparse);
forcezerodiagonal=true;
D=Forcezerodiagonal(D,usesparse,forcezerodiagonal);



readyre=true;
[Y, R, E] = Mapontomanifold(D,manifoldmethod,dimtouse,n_size,saveyre,readyre,filenames,printonscreeninsidefunction,options); %#ok<NASGU,ASGLU>






