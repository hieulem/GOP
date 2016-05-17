function requestedaffinities=Includeconnectivityrequested(requestedaffinities)
%Dependencies in table in Getcombinedsimilarities are here hard coded
%Each affinity request is processed sequenctially



toiterate=true;
while(toiterate) %The process is iterated to account for new dependencies
    affinityadded=false;
    
    %STT dependencies
    if (Isaffinityrequested(requestedaffinities,'stt'))
        if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
            requestedaffinities{numel(requestedaffinities)+1}='aba';
            fprintf('Added requested affinity for dependency: %s\n',requestedaffinities{numel(requestedaffinities)});
            affinityadded=true;
        end
    end
    
    %LTT dependencies
    if (Isaffinityrequested(requestedaffinities,'ltt'))
        if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
            requestedaffinities{numel(requestedaffinities)+1}='aba';
            fprintf('Added requested affinity for dependency: %s\n',requestedaffinities{numel(requestedaffinities)});
            affinityadded=true;
        end
    end
    
    %STA and STM have no connectivity dependencies
    
    %ABA dependencies
    if (Isaffinityrequested(requestedaffinities,'aba'))
        if (~Isaffinityrequested(requestedaffinities,'ltt','stt','stm','sta','vltti'))
            requestedaffinities{numel(requestedaffinities)+1}='ltt';
            fprintf('Added requested affinity for dependency: %s\n',requestedaffinities{numel(requestedaffinities)});
            affinityadded=true;
        end
    end
    
    %ABM dependencies
    if (Isaffinityrequested(requestedaffinities,'abm'))
        if (~Isaffinityrequested(requestedaffinities,'ltt','stt','stm','sta','vltti'))
            requestedaffinities{numel(requestedaffinities)+1}='ltt';
            fprintf('Added requested affinity for dependency: %s\n',requestedaffinities{numel(requestedaffinities)});
            affinityadded=true;
        end
    end
    
    %VLTTI dependencies
    if (Isaffinityrequested(requestedaffinities,'vltti'))
        if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
            requestedaffinities{numel(requestedaffinities)+1}='aba';
            fprintf('Added requested affinity for dependency: %s\n',requestedaffinities{numel(requestedaffinities)});
            affinityadded=true;
        end
    end
        
    if (~affinityadded)
        toiterate=false;
    end
end
