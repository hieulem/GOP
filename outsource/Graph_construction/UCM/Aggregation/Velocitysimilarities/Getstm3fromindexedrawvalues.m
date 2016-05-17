function STM=Getstmfromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
usesquarevalues=false;%true;
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

if ( (isfield(options,'stmrefv')) && (~isempty(options.stmrefv)) )
    stmrefv=options.stmrefv;
else
    stmrefv=1.0;
end

if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) || (options.stmlmbd) ) %default is the use of lambda coefficient
    thefactor=stmrefv;
    uselmbd=true;
else
    % thefactor=0.2;
    % thefactor=-log(quantilevalue)/thequantile^2;
    targetvalue=0.5;
    thevalue=maybesquare(stmrefv);
    thefactor=-log(targetvalue)/thevalue;
    uselmbd=false;
end

Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
% Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
% Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

zerosparsevalue=0.0000001;
onesparsevalue=1;
Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

if ( (isfield(options,'stmavf')) && (~isempty(options.stmavf)) )
    stmavf=options.stmavf;
else
    stmavf=true;
end
if (stmavf), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end

fprintf('stm: refv %d, lmbd %d, avf %d\n',stmrefv,uselmbd,stmavf);



STM=sparse(sx, sy, Putinrange( 1 - Normalizesv(squareroot(sv)) ), noallsuperpixels, noallsuperpixels);
