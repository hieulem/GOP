function [Y,alldistances, mapping]=Getmanifoldandprogressivedistances(similarities,setclustermethod,dimtouse,n_size,...
    manifoldmethod,filenames,saveyre,manifolddistancemethod,printonscreen)

if ( (~exist('manifolddistancemethod','var')) || (isempty(manifolddistancemethod)) ) %[option for setclustermethod='distances'] 'origd','euclidian'(default),'spectraldiffusion'
    manifolddistancemethod='euclidian'; %default option
end
if ( (~exist('manifoldmethod','var')) || (isempty(manifoldmethod)) )
    manifoldmethod='laplacian'; %'iso','isoii','laplacian'
end
if ( (~exist('setclustermethod','var')) || (isempty(setclustermethod)) )
    setclustermethod='manifoldcl';
end
if ( (~exist('n_size','var')) || (isempty(n_size)) )
    n_size=0; %default is 7, 0 when neighbours have already been selected
end
if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=6;
end
if ( strcmp(manifoldmethod,'isoii') || strcmp(manifoldmethod,'laplacian') )
    usesparse=true;
else
    usesparse=false;
end
if ( (~exist('saveyre','var')) || (isempty(saveyre)) || (~exist('filenames','var')) || ...
        (~isstruct(filenames)) || (~isfield(filenames,'the_isomap_yre')) )
    saveyre=false;
end
if ( (~saveyre) || (~exist(filenames.the_isomap_yre,'file')) ) %case of filenames not existing or not being a struct is included into saveyre
    readyre=false;
else
    readyre=true;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



%This check is introduced because this same function is also used for loading the pre-computed Y
if ( (~readyre) && (isempty(similarities)) )
        fprintf('similarities or manifoldmethod not defined and Y not precomputed\n');
        Y=[]; %R=[]; E=[];
        return;
end



if (readyre)
    
    load(filenames.the_isomap_yre);
    fprintf('Yre loaded\n');
    
else

    if ( (~strcmp(setclustermethod,'manifoldcl')) || (~strcmp(manifoldmethod,'laplacian')) )
        D=Dfromsimilarities(similarities,usesparse);
        forcezerodiagonal=true;
        D=Forcezerodiagonal(D,usesparse,forcezerodiagonal);
    end
    
    
    
    n_fcn='k';
    opts.dims = dimtouse; %1:dimtouse
    opts.display = false;
    opts.overlay = false;
    opts.verbose = false;
    
    if (~any(opts.dims==dimtouse))
        opts.dims(numel(opts.dims)+1)=dimtouse;
    end

    
    
    if (strcmp(manifoldmethod,'iso'))
        
        [Y, R, E] = Isomap(D, n_fcn, n_size, opts);
        
    elseif (strcmp(manifoldmethod,'isoii'))
        
        [Y, R, E] = IsomapII(D, n_fcn, n_size, opts);
        
    elseif (strcmp(manifoldmethod,'laplacian'))
        
        methodofchoice=3;
        [Y,R,E]=Projecttomanifold(similarities,n_size,methodofchoice,n_fcn,opts);
        % Y.coords = [ dimtouse x no_data_points_largest_conn_comp ]
        % Y.index  = [ no_data_points_largest_conn_comp x 1 ] given by find on largest among blocks
        % E same size and sparsity as W, specifying the graph connections
        % R = [ 1 x dimtouse ] residual variance after eigenmapping, to be defined
        
    else
        fprintf('Manifold method not recognised\n');
        return;
    end
    
    
    
    if (numel(Y.index)<size(similarities,1))
        fprintf('%d elements embedded on a total of %d\n',numel(Y.index),size(similarities,1));
        alltheelements=true(1,size(similarities,1));
        alltheelements(Y.index)=false;
        Y.missing=reshape(find(alltheelements),[],1);
    end
    if (saveyre)
        save(filenames.the_isomap_yre,'Y','R','E','-v7.3');
    end
end
% mex -O -largeArrayDims dijkstra.cpp



if (strcmp(setclustermethod,'distances'))
    if ( (saveyre) && (exist(filenames.the_tree_structure,'file')) )
        load(filenames.the_tree_structure);
        fprintf('Tree structure loaded\n');
    else
        [alldistances, mapping]=Computeincreasingdistances(D,Y,dimtouse,manifolddistancemethod);
        %At distance alldistances(i) the following two points are merged
        % point1=mapping(1,i);
        % point2=mapping(2,i);
        
        %Keep only the meaningful merges
        [maxmerges, alldistances, mapping]=Countmaxmerges(alldistances, mapping, size(similarities,1)); %#ok<ASGLU>
        %maxmerges refers to the max usefull merge from the original mapping
        
        if (saveyre)
            save(filenames.the_tree_structure,'alldistances','mapping','maxmerges');
        end
    end
else
    alldistances=[];
    mapping=[];
end



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
% opts.dijkstra=0;
% n_size=1;
% [Y, R, E] = IsomapII(D, 'epsilon', n_size, opts);
% XXX=D;
% [Y, R, E] = IsomapII('SparseDFun', 'k', n_size, opts);
% opts.landmark=700:1000;
% opts.landmark=1:300;
% opts.landmark=[1:150,1450:1583];
