function options=Applysetupcase(options)

switch (options.stpcas)
    
        
    case 'paperoptnrm' %revised, no nrm [0,1], no lmb nrm
        
        if ( (~isfield(options,'requestedaffinities')) || (isempty(options.requestedaffinities)) )
            options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
        end
        
        if ( (~isfield(options,'lttuexp')) || (isempty(options.lttuexp)) ), options.lttuexp=false; end
        if ( (~isfield(options,'lttlambd')) || (isempty(options.lttlambd)) ), options.lttlambd=1; end
        if ( (~isfield(options,'lttsqv')) || (isempty(options.lttsqv)) ), options.lttsqv=false; end

        if ( (~isfield(options,'abauexp')) || (isempty(options.abauexp)) ), options.abauexp=false; end
        if ( (~isfield(options,'abalambd')) || (isempty(options.abalambd)) ), options.abalambd=13; end
        if ( (~isfield(options,'abasqv')) || (isempty(options.abasqv)) ), options.abasqv=false; end
        if ( (~isfield(options,'abathmax')) || (isempty(options.abathmax)) ), options.abathmax=true; end

        if ( (~isfield(options,'sttuexp')) || (isempty(options.sttuexp)) ), options.sttuexp=false; end
        if ( (~isfield(options,'sttlambd')) || (isempty(options.sttlambd)) ), options.sttlambd=1; end
        if ( (~isfield(options,'sttsqv')) || (isempty(options.sttsqv)) ), options.sttsqv=false; end

        if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) ), options.stalmbd=true; end
        if ( (~isfield(options,'stasqv')) || (isempty(options.stasqv)) ), options.stasqv=true; end
        if ( (~isfield(options,'starefv')) || (isempty(options.starefv)) ), options.starefv=0.005; end
        if ( (~isfield(options,'staavf')) || (isempty(options.staavf)) ), options.staavf=true; end

        if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) ), options.abmlmbd=true; end
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=1.0; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=true; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=1.0; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=true; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='prod'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=false; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=false; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end
        
    otherwise
        
        fprintf('Applysetupcase: options unchanged\n');
        
end

