function STT=Getsttfromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
if ( (isfield(options,'sttsqv')) && (~isempty(options.sttsqv)) )
    usesquarevalues=options.sttsqv;
else
    usesquarevalues=false;
end
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

if ( (isfield(options,'sttlambd')) && (~isempty(options.sttlambd)) )
    thelambda=options.sttlambd;
else
    thelambda=1;
end

if ( (isfield(options,'sttuexp')) && (~isempty(options.sttuexp)) )
    useexponential=options.sttuexp;
else
    useexponential=false; %false correspond to unchanged cross-correlation output
end
if (useexponential)
    Normalizesv = @(x) 1-exp(-thelambda*maybesquare(1-x));
else
    Normalizesv = @(x) x; %unprocessed cross-correlation output
end



STT=sparse(sx, sy, Normalizesv(sv), noallsuperpixels, noallsuperpixels);
