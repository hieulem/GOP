function LTT=Getlttfromindexedrawvalues(sx,sy,sv,noallsuperpixels,options)
% sx=[sxo;syo]; sy=[syo;sxo]; sv=[svo;svo];

%Parameters for convertion into affinity
if ( (isfield(options,'lttsqv')) && (~isempty(options.lttsqv)) )
    usesquarevalues=options.lttsqv;
else
    usesquarevalues=false;
end
if (usesquarevalues)
    maybesquare = @(x) x.^2;
else
    maybesquare = @(x) x.^1;
end

if ( (isfield(options,'lttlambd')) && (~isempty(options.lttlambd)) )
    thelambda=options.lttlambd;
else
    thelambda=1;
end

if ( (isfield(options,'lttuexp')) && (~isempty(options.lttuexp)) )
    useexponential=options.lttuexp;
else
    useexponential=false; %false correspond to unchanged cross-correlation output
end
if (useexponential)
    Normalizesv = @(x) 1-exp(-thelambda*maybesquare(1-x));
else
    Normalizesv = @(x) x; %unprocessed cross-correlation output
end



LTT=sparse(sx, sy, Normalizesv(sv), noallsuperpixels, noallsuperpixels);
