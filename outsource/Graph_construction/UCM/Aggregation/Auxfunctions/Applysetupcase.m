function options=Applysetupcase(options)
%The function applies the setup options of stpcas. Setup options expicitely
%declared in input are not overwritten

%Standard setup: these settings are applied by default inside the functions
% options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
% options.lttuexp=false; options.lttlambd=1; options.lttsqv=false;
% options.abauexp=false; options.abalambd=13; options.abasqv=false; options.abathmax=true;
% options.sttuexp=false; options.sttlambd=1; options.sttsqv=false;
% options.stasqv=true; options.starefv=0.6; options.staavf=true;
% options.abmrefv=1; options.abmpfour=false;
% options.stmrefv=0.2; options.stmavf=true;
% options.faffinityv=[];
% options.mrgmth='wsum'; options.mrgwgt=ones(1,6);
% options.normalize=true; options.normalisezeroone=true;
% options.vsmethod='affinities';

switch (options.stpcas)
    
    case 'optvlt' %revised, no nrm [0,1], no lmb nrm, vltti
        
        if ( (~isfield(options,'requestedaffinities')) || (isempty(options.requestedaffinities)) )
            options.requestedaffinities={'stt','ltt','aba','abm','stm','sta','vltti'};
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
        
%         if ( (~isfield(options,'vlttiuexp')) || (isempty(options.vlttiuexp)) ), options.vlttiuexp=false; end
%         if ( (~isfield(options,'vlttilambd')) || (isempty(options.vlttilambd)) ), options.vlttilambd=1; end
%         if ( (~isfield(options,'vlttisqv')) || (isempty(options.vlttisqv)) ), options.vlttisqv=false; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='prod'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=false; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=false; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end
        
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
        
    case 'paperopt' %revised
        
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
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=5.0; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=true; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=5.0; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=true; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='prod'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=true; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=true; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end
        
    case 'rpcbest' %max performance from the single RP curves
        
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

        if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) ), options.stalmbd=false; end
        if ( (~isfield(options,'stasqv')) || (isempty(options.stasqv)) ), options.stasqv=true; end
        if ( (~isfield(options,'starefv')) || (isempty(options.starefv)) ), options.starefv=0.6; end
        if ( (~isfield(options,'staavf')) || (isempty(options.staavf)) ), options.staavf=true; end

        if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) ), options.abmlmbd=false; end
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=1; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=false; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=0.2; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=true; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='wsum'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=true; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=true; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end

    case 'bkbbest' %max performance from the Berkeley benchmark
        
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

        if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) ), options.stalmbd=false; end
        if ( (~isfield(options,'stasqv')) || (isempty(options.stasqv)) ), options.stasqv=true; end
        if ( (~isfield(options,'starefv')) || (isempty(options.starefv)) ), options.starefv=1; end
        if ( (~isfield(options,'staavf')) || (isempty(options.staavf)) ), options.staavf=true; end

        if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) ), options.abmlmbd=false; end
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=0.5; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=false; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=0.2; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=true; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='wsum'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=true; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=true; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end

    case 'paper' %setup submitted
        
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

        if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) ), options.stalmbd=false; end
        if ( (~isfield(options,'stasqv')) || (isempty(options.stasqv)) ), options.stasqv=false; end
        if ( (~isfield(options,'starefv')) || (isempty(options.starefv)) ), options.starefv=13; end
        if ( (~isfield(options,'staavf')) || (isempty(options.staavf)) ), options.staavf=true; end

        if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) ), options.abmlmbd=false; end
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=0.5; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=false; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=0.5; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=false; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='prod'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=true; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=true; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end

    case 'default' %this case should not be specified, as the default values are taken from the respective functions
                   %set up to rpcbest
        
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

        if ( (~isfield(options,'stalmbd')) || (isempty(options.stalmbd)) ), options.stalmbd=false; end
        if ( (~isfield(options,'stasqv')) || (isempty(options.stasqv)) ), options.stasqv=true; end
        if ( (~isfield(options,'starefv')) || (isempty(options.starefv)) ), options.starefv=0.6; end
        if ( (~isfield(options,'staavf')) || (isempty(options.staavf)) ), options.staavf=true; end

        if ( (~isfield(options,'abmlmbd')) || (isempty(options.abmlmbd)) ), options.abmlmbd=false; end
        if ( (~isfield(options,'abmrefv')) || (isempty(options.abmrefv)) ), options.abmrefv=1; end
        if ( (~isfield(options,'abmpfour')) || (isempty(options.abmpfour)) ), options.abmpfour=false; end

        if ( (~isfield(options,'stmlmbd')) || (isempty(options.stmlmbd)) ), options.stmlmbd=false; end
        if ( (~isfield(options,'stmrefv')) || (isempty(options.stmrefv)) ), options.stmrefv=0.2; end
        if ( (~isfield(options,'stmavf')) || (isempty(options.stmavf)) ), options.stmavf=true; end

        if ( (~isfield(options,'mrgmth')) || (isempty(options.mrgmth)) ), options.mrgmth='wsum'; end
        
        if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) ), options.normalize=true; end
        if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) ), options.normalisezeroone=true; end
        
        if ( (~isfield(options,'vsmethod')) || (isempty(options.vsmethod)) ), options.vsmethod='affinities'; end

    otherwise
        
        fprintf('Applysetupcase: options unchanged\n');
        
end



function newoptions=Testthiscode(options) %#ok<DEFNU>

newoptions=options;
newoptions.stpcas='paper'; %rpcbest, bkbbest, paper
newoptions=Applysetupcase(newoptions);
