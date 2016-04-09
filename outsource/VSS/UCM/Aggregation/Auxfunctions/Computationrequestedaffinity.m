function isnecessary=Computationrequestedaffinity(theset,anaffinity,options)
%Dependencies between affinities regarding computation
%Each affinity is requested for computation plus those specified in the
%dependencies in the table in Getcombinedsimilarities

%The boolean completion indicates that requestedaffinities is completed
%with the missing affinities for connection
if ( (exist('options','var')) && (isstruct(options)) && (isfield(options,'complrqst')) && (options.complrqst) )
    completion=true;
else
    completion=false;
end

isnecessary=false;
switch (anaffinity)
    
    case 'stt'
        if (Isaffinityrequested(theset,'stt','stm','sta'))
            isnecessary=true;
        end

    case 'ltt'
        if (Isaffinityrequested(theset,'ltt'))
            isnecessary=true;
        end
        if (~completion) %This could also be done with stt
            if (~Isaffinityrequested(theset,'ltt','stt','stm','sta'))
                isnecessary=true;
            end
        end

    case 'sta'
        if (Isaffinityrequested(theset,'sta'))
            isnecessary=true;
        end

    case 'stm'
        if (Isaffinityrequested(theset,'stm'))
            isnecessary=true;
        end

    case 'aba'
        if (Isaffinityrequested(theset,'aba','abm','stm','sta'))
            isnecessary=true;
        end
        if (~completion)
            if (~Isaffinityrequested(theset,'aba','abm','stm','sta'))
                isnecessary=true;
            end
        end

    case 'abm'
        if (Isaffinityrequested(theset,'abm'))
            isnecessary=true;
        end

    otherwise
        fprintf('Computationrequestedaffinity\n');
end

