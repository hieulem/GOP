function [bincentersout,casefound]=Transformtheaffinities(bincenters,thiscase)

casefound=true;
switch(thiscase)
    case 'stmnew2'
        
        usesquarevalues=true;
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end

        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.1; %* 0.3, p:0.5
        thevalue=maybesquare(0.5);
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);
        
        avoidfour=false; %* true, p:false
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end %* p:no_avoid_squareroot

        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) ); %* p:no_avoid_squareroot
        
    case 'stanew2'
        
        usesquarevalues=true; %* true, p:false
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end



        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.3;
        thevalue=maybesquare(5); %* p:13,3,5 When the distance is thevalue the exponential is targetvalue
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));



        %Output results
        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

        avoidfour=true;
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end
        
        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) );
        
    case 'stanew'
        
        usesquarevalues=true; %* true, p:false
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end



        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.1;
        thevalue=maybesquare(5); %* p:13,3,5 When the distance is thevalue the exponential is targetvalue
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));



        %Output results
        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

        avoidfour=false;
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end
        
        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) );
        
    case 'stmnew'
        
        usesquarevalues=true;
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end

        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.2; %* 0.3, p:0.5
        thevalue=maybesquare(0.5);
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);
        
        avoidfour=true; %* true, p:false
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end %* p:no_avoid_squareroot

        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) ); %* p:no_avoid_squareroot
        
    case 'abmnew'
        
        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

        usesquarevalues=true;
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end

        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.5;
        thevalue=maybesquare(0.5);
        thefactor=-log(targetvalue)/thevalue;
        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));

        bincentersout=Putinrange( 1 - Normalizesv(bincenters) );
        
    case 'abanew'
        bincentersout=bincenters;
    case 'lttnew'
        bincentersout=bincenters;
    case 'sttnew'
        bincentersout=bincenters;

    
    
    %Transformation from the paper
    case 'sta'
        
        usesquarevalues=false; %* true, p:false
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end



        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.5;
        thevalue=maybesquare(13); %* p:13,3,5 When the distance is thevalue the exponential is targetvalue
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));



        %Output results
        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

        avoidfour=true;
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end
        
        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) );
        
    case 'stm'
        
        usesquarevalues=true;
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end

        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.5; %* 0.3, p:0.5
        thevalue=maybesquare(0.5);
        thefactor=-log(targetvalue)/thevalue;

        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));
        % Normalizesv = @(x) tanh((x-themean)/thestd)/2+0.5;
        % Normalizesv = @(x) min(onesparsevalue,max(zerosparsevalue, (x-themin)/(themax-themin) ));

        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);
        
        avoidfour=false; %* true, p:false
        if (avoidfour), squareroot = @(x) sqrt(x); else squareroot = @(x) (x); end %* p:no_avoid_squareroot

        bincentersout=Putinrange( 1 - Normalizesv(squareroot(bincenters)) ); %* p:no_avoid_squareroot
        
    case 'abm'
        
        zerosparsevalue=0.0000001;
        onesparsevalue=1;
        Putinrange = @(x) min(max(x,zerosparsevalue),onesparsevalue);

        usesquarevalues=true;
        if (usesquarevalues)
            maybesquare = @(x) x.^2;
        else
            maybesquare = @(x) x.^1;
        end

        % thefactor=0.2;
        % thefactor=-log(quantilevalue)/thequantile^2;
        targetvalue=0.5;
        thevalue=maybesquare(0.5);
        thefactor=-log(targetvalue)/thevalue;
        Normalizesv = @(x) 1-exp(-thefactor*maybesquare(x));

        bincentersout=Putinrange( 1 - Normalizesv(bincenters) );
        
    case 'aba'
        bincentersout=bincenters;
    case 'ltt'
        bincentersout=bincenters;
    case 'stt'
        bincentersout=bincenters;
    otherwise
        fprintf('Case not specified\n');
        bincentersout=bincenters;
        casefound=false;
end

