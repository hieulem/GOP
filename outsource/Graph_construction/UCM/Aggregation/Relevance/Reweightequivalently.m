function Wnew=Reweightequivalently(W,normpertrack,maxnotracks)
%Reweight the affinity matrix W according to the multiplicity specified by normpertrack



if ( (~exist('maxnotracks','var')) || (isempty(maxnotracks)) )
    maxnotracks=numel(normpertrack);
end



if (issparse(W))



    %Find edges in W
    [rr,cc,rcv]=find(W);
    fprintf('Mean similarity value orig %.8f\n',mean(rcv));



    %Eliminate diagonal elements from W's decomposing elements
    diagonalelements= (rr==cc);
    rr(diagonalelements)=[];
    cc(diagonalelements)=[];
    rcv(diagonalelements)=[];



    %Transform the elements on the diagonal
    Z=1;
    USEMEX=true;
    if (USEMEX)
        
        sizew=size(W,1);
        [rrd,ccd,rcvd]=Reweightequivalentlynewloopmex(rr,cc,rcv,normpertrack,maxnotracks,Z,sizew);
        
    else
        
        rrd=zeros(maxnotracks,1); ccd=zeros(maxnotracks,1); rcvd=zeros(maxnotracks,1);
        
        %Pre-compute the sum
        sizew=size(W,1);
        allrcvsums=zeros(sizew,1);
        allrcvandnormsums=zeros(sizew,1);
        for i=1:numel(rr)
            allrcvsums(rr(i))=allrcvsums(rr(i)) + rcv(i);
            allrcvandnormsums(rr(i))=allrcvandnormsums(rr(i)) + rcv(i)*normpertrack(cc(i));
        end
        
        for i=1:maxnotracks

            rrd(i)=i;
            ccd(i)=i;

            % g_i is given by numel(find(.)) on vector corrsupertracks(i,:), number of subcomponents of node i (finer touched superpixels)
            % w(e_{ij}) is given by rcv, in paticular i=rr(k), j=cc(k), w(e_{ij})=rcv(k)
            % set of j~=i with an edge to i is find( rr==i )
            % w(e_{ij}) for all j~=i is rcv( rr==i )
            % j's edged to i, i~=j are cc( rr==i )
            % g_j is therefore normpertrack( cc( rr==i )  )

            rcvd(i)=...
            (normpertrack(i)-1) * ...   %g_i
            ...
            ( ...
            ...
            Z*allrcvsums(i) ... %sum( Zw(e_{ij}) )
            ...
            - ...
            ...
            allrcvandnormsums(i)... %sum( g_j  w(e_{ij}) )
            ...
            );
            %Formulation with sum computed inside the loop
            % rcvd(i)=...
            % (normpertrack(i)-1) * ...   %g_i
            % ...
            % ( ...
            % ...
            % Z*sum( rcv( rr==i ) ) ... %sum( Zw(e_{ij}) )
            % ...
            % - ...
            % ...
            % sum( ... %sum( g_j  w(e_{ij}) )
            % rcv( rr==i ) .* ... 
            % normpertrack( cc( rr==i )  )...
            % )...
            % ...
            % );

            %%%Compute diagonal elements assuming there are diagonal elements in W
            % g_i is given by numel(find(.)) on vector corrsupertracks(i,:), number of subcomponents of node i (finer touched superpixels)
            % w(e_{ij}) is given by rcv, in paticular i=rr(k), j=cc(k), w(e_{ij})=rcv(k)
            % set of j~=i with an edge to i is find( (rr==i) & (cc~=i) )
            % w(e_{ij}) for all j~=i is rcv( (rr==i) & (cc~=i) )
            % j's edged to i, i~=j are cc( (rr==i) & (cc~=i) )
            % g_j is therefore normpertrack( cc( (rr==i) & (cc~=i) )  )
            %
        %     rcvd(i)=...
        %     (normpertrack(i)-1) * ...   %g_i
        %     ...
        %     ( ...
        %     ...
        %     Z*sum( rcv( (rr==i) & (cc~=i) ) ) ... %sum( Zw(e_{ij}) )
        %     ...
        %     - ...
        %     ...
        %     sum( ... %sum( g_j  w(e_{ij}) )
        %     rcv( (rr==i) & (cc~=i) ) .* ... 
        %     normpertrack( cc( (rr==i) & (cc~=i) )  )...
        %     )...
        %     ...
        %     );
        end
        
%         sizew=size(W,1);
%         [rrd2,ccd2,rcvd2]=Reweightequivalentlynewloopmex(rr,cc,rcv,normpertrack,maxnotracks,Z,sizew);
%         if ( (~isequal(rrd2,rrd)) || (~isequal(ccd2,ccd)) || (~isequal(rcvd2,rcvd)) ), fprintf('\n\n\n\n\n\nSpotted difference\n\n\n\n\n\n'); end
    end



    %Transform the non-diagonal elements
    rcv=rcv.*normpertrack(rr).*normpertrack(cc);
    %Transform the non-diagonal elements (assuming there are diagonal elements)
    % nondiagonalelements= ( rr~=cc );
    % rcv(nondiagonalelements)=rcv(nondiagonalelements).*normpertrack(rr(nondiagonalelements)).*normpertrack(cc(nondiagonalelements));



    %Reweight edges
    % rcv= rcv.*(normpertrack(rr)+normpertrack(cc)-1); %\delta=(normpertrack(rr)+normpertrack(cc))
    [modercv,freqrcv]=mode(rcv);
    [modercvd,freqrcvd]=mode(rcvd);
    fprintf('Similarities multiplied (just off diagonal values) mean %.8f, min %.8f, max %.8f, med %.8f, mode %.8f (freq %d)\n',mean(rcv),min(rcv),max(rcv),median(rcv),modercv,freqrcv);
    fprintf('Similarities multiplied (diagonal values) mean %.8f, min %.8f, max %.8f, med %.8f, mode %.8f (freq %d)\n',mean(rcvd),min(rcvd),max(rcvd),median(rcvd),modercvd,freqrcvd);



    %Normalize rcv to [0,1]
    % rcv=rcv./(max(rcv(:)));
    % fprintf('Mean similarity value reweighted %.8f\n',mean(rcv));



    %Recombine W
    Wnew=sparse([rr;rrd],[cc;ccd],[rcv;rcvd],maxnotracks,maxnotracks);
    % newsimilarities20=sparse(rr,cc,rcv,maxnotracks,maxnotracks);



else



	%weight of internal nodes
	Z=1;

	%working copy
    Wnew=W;
	Wtmp=W;

	%re-weight elements off the diagonal
	Wnew= Wnew .* repmat(normpertrack,1,maxnotracks) .* repmat(normpertrack',maxnotracks,1);
    
    Wtmp(logical(eye(size(Wtmp,1))))=0;

	%re-weight elements on the diagonal
    for i = 1:maxnotracks
		Wnew(i,i)=...
			(normpertrack(i)-1) *...
			(...
				Z * sum(Wtmp(i,:))...
				-...
				sum( Wtmp(i,:) .* normpertrack' )...
			);
    end

    
    
end

