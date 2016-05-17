function [Y, R, E] = Mapontomanifold(D,manifoldmethod,dimtouse,n_size,saveyre,readyre,filenames,printonscreen,inputoptions)
%manifoldmethod='iso', 'isoii', 'laplacian'
%TODO: this function is outdated and only kept for dealing with D cases
% Getmanifoldandprogressivedistances should be used instead
% function still used in Solvetoycase, GetHomogeneousColours, Gettheclustering
% function commented in Affinityfromsuperpixels



if ( (~exist('inputoptions','var')) || (~isstruct(inputoptions)) )
    inputoptions=struct();
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=6;
end
if ( (~exist('n_size','var')) || (isempty(n_size)) )
    n_size=8;
end
if ( (~exist('saveyre','var')) || (isempty(saveyre)) || (~exist('filenames','var')) || ...
        (~isstruct(filenames)) || (~isfield(filenames,'the_isomap_yre')) )
    saveyre=false;
end
if ( (~exist('readyre','var')) || (isempty(readyre)) || (~exist('filenames','var')) || ...
        (~isstruct(filenames)) || (~isfield(filenames,'the_isomap_yre')) || (~exist(filenames.the_isomap_yre,'file')) )
    readyre=false;
end

options.dims = 1:dimtouse; %10
options.display = 0;
if (~any(options.dims==dimtouse))
    options.dims(numel(options.dims)+1)=dimtouse;
end
if (readyre)
    load(filenames.the_isomap_yre);
    fprintf('Yre loaded\n');
else
    %This check is introduced because this same function is also used for
    %loading the pre-computed Y
    if ( (isempty(D)) || (isempty(manifoldmethod)) )
        fprintf('D or manifoldmethod not defined and Y not precomputed\n');
        Y=[]; R=[]; E=[];
        return;
    end

    if (strcmp(manifoldmethod,'iso'))
        [Y, R, E] = Isomap(D, 'k', n_size, options);
    elseif (strcmp(manifoldmethod,'isoii'))
        options.verbose = 0;
        [Y, R, E] = IsomapII(D, 'k', n_size, options);
    elseif (strcmp(manifoldmethod,'laplacian'))
        options.verbose = 0;
        options.useoneminus=true;
        options.sigma=sqrt(0.5*0.1);
        
        if ( (isfield(inputoptions,'normalisezeroone')) && (~isempty(inputoptions.normalisezeroone)) )
            %Normalize each eigenvector to values in [0,1]
            options.normalisezeroone=inputoptions.normalisezeroone;
        else
            options.normalisezeroone=false; %true in paper
        end
        if ( (isfield(inputoptions,'normalize')) && (~isempty(inputoptions.normalize)) )
            %Normalize the eigenvectors according to the inverse square root of the eigenvalues
            options.normalize=inputoptions.normalize;
        else
            options.normalize=false; %true in paper
        end
        
        [Y, R, E] = Laplacian(D, 'k', n_size, options);
    else
        fprintf('Manifold method not recognised\n');
        return;
    end
    
    if (numel(Y.index)<size(D,1))
        fprintf('%d elements embedded on a total of %d\n',numel(Y.index),size(D,1));
        alltheelements=true(1,size(D,1));
        alltheelements(Y.index)=false;
        Y.missing=reshape(find(alltheelements),[],1);
    end
    if (saveyre)
        save(filenames.the_isomap_yre,'Y','R','E','-v7.3');
    end
end
% mex -O -largeArrayDims dijkstra.cpp

if (printonscreen)
    maxlabel=max(Y.index);
    IDXtmp=ones(maxlabel,1);
    
    %Visualization
    distributecolours=false;
    includenumbers=false;
    Visualiseclusteredpoints(Y,IDXtmp,2,20,distributecolours,includenumbers);
    Visualiseclusteredpoints(Y,IDXtmp,3,22,distributecolours,includenumbers);
end

%Further options for IsomapII
% options.dijkstra=0;
% n_size=1;
% [Y, R, E] = IsomapII(D, 'epsilon', n_size, options);
% XXX=D;
% [Y, R, E] = IsomapII('SparseDFun', 'k', n_size, options);
% options.landmark=700:1000;
% options.landmark=1:300;
% options.landmark=[1:150,1450:1583];


