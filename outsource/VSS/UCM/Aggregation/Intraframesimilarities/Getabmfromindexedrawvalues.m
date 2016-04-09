function [ABM,Normalizesv,Putinrange]=Getabmfromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
usesquarevalues=true;
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

if ( (isfield(options,'abmrefv')) && (~isempty(options.abmrefv)) )
    abmrefv=options.abmrefv;
else
    abmrefv=1.0;
end

if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) || (options.abmlmbd) ) %default is exp coefficient
    thefactor=abmrefv;
    uselmbd=true;
else
    % thefactor=0.2;
    % thefactor=-log(quantilevalue)/thequantile^2;
    targetvalue=0.5;
    thevalue=maybesquare(abmrefv);
    thefactor=-log(targetvalue)/thevalue;
    uselmbd=false;
end

if ( (isfield(options,'abmpfour')) && (~isempty(options.abmpfour)) )
    usepfour=options.abmpfour;
else
    usepfour=false;
end
if (usepfour)
    maybepfour = @(x) x.^2;
else
    maybepfour = @(x) x.^1;
end

fprintf('abm: refv %d, lmbd %d, usepfour %d\n',abmrefv,uselmbd,usepfour);

Normalizesv = @(x) 1-exp(-thefactor*maybesquare(maybepfour(x)));
% Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
% Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

zerosparsevalue=0.0000001;
onesparsevalue=1;
Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

ABM=sparse(sx,sy, Putinrange( 1 - Normalizesv(sv) ) ,noallsuperpixels,noallsuperpixels);

