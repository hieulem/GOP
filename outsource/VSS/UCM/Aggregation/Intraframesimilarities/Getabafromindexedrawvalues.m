function ABA=Getabafromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
if ( (isfield(options,'abasqv')) && (~isempty(options.abasqv)) )
    usesquarevalues=options.abasqv;
else
    usesquarevalues=false;
end
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

if ( (isfield(options,'abalambd')) && (~isempty(options.abalambd)) )
    thelambda=options.abalambd;
else
    thelambda=13;
end

if ( (isfield(options,'abauexp')) && (~isempty(options.abauexp)) )
    useexponential=options.abauexp;
else
    useexponential=false; %false correspond to unchanged cross-correlation output
end
if (useexponential)
    Normalizesv = @(x) 1-exp(-thelambda*maybesquare(1-x));
else
    Normalizesv = @(x) x; %unprocessed cross-correlation output
end



ABA=sparse(sx, sy, Normalizesv(sv), noallsuperpixels, noallsuperpixels);
