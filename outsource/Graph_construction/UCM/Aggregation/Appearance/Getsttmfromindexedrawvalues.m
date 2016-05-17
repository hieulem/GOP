function STA=Getstafromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
% if ( (isfield(options,'stasqv')) && (~isempty(options.stasqv)) )
%     usesquarevalues=options.stasqv;
% else
    usesquarevalues=false;%true;
% end
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

% if ( (isfield(options,'starefv')) && (~isempty(options.starefv)) )
%     starefv=options.starefv;
% else
    starefv=0.3;%0.005;
% end

if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) || (options.stalmbd) ) %default is exp coefficient
    thefactor=starefv;
    uselmbd=true;
else
    % thefactor=0.2;
    % thefactor=-log(quantilevalue)/thequantile^2;
    targetvalue=0.5;
    thevalue=maybesquare(starefv); %3,5 When the distance is thevalue the exponential is targetvalue
    thefactor=-log(targetvalue)/thevalue;
    uselmbd=false;
end



Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
% Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
% Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

zerosparsevalue=0.0000001;
onesparsevalue=1;
Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

if ( (isfield(options,'staavf')) && (~isempty(options.staavf)) )
    staavf=options.staavf;
else
    staavf=true;
end
if (staavf), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end

fprintf('sta: refv %d, sqv %d, lmbd %d, avf %d\n',starefv,usesquarevalues,uselmbd,staavf);



STA=sparse(sx, sy, Putinrange( 1 - Normalizesv(squareroot(sv)) ), noallsuperpixels, noallsuperpixels);

