function labelledpoints=Normalizedcutbisect(W,nclusters,nrepresentative)
%This function implements the Normalized Cut algorithm
%The NCut is equivalent to solving the following generalized eigen system
%	(D-W)y=rDy
%with the constraints that y(i) \in {1,-b} and y'D1=0, where the constraint
%y'D1=0 is automatically satisfied for the generalized eigen system.
%We shall follow the notations used in Shi and Malik
%Mar 26th, 2008

%variable name correspondance: n nrepresentative, cluster nclusters

%Number of remaining points to NCut
nrepresentativeleft=nrepresentative;
%Vector to maintain the indices of NCutted points
rvec=zeros(nrepresentative,1);
%The similarity matrix left after each round of NCut
Wremaining=W;

iloop=0;
labelledpoints=zeros(nrepresentative,1);
while(iloop<nclusters)
    
	iloop=iloop+1;

	fprintf('Iteration %d\n',iloop);

	%For the last piece, no further NCut will be performed
    %Assign to output vector labelledpoints
    if (iloop==nclusters) 
        fprintf('iloop = %d\n',iloop); fprintf('Current assignments:'); fprintf(' %d',rvec); fprintf('\n');
        labelledpoints(rvec)=iloop;
        continue;
    end

	%Prepare for generalized eigen analysis
	diagonalelements=ones(nrepresentativeleft,1);
	
    if (iloop~=1)
        %Eliminate cutted out points from Wremaining
        Wremaining(:,cuttedoutpoints)=[];
        Wremaining(cuttedoutpoints,:)=[];
    end
    
    %Assign diagonalelements the diagonal elements of Wremaining
	diagonalelements=Wremaining * diagonalelements;
    if (length(diagonalelements)~=nrepresentativeleft)
		fprintf('The length of diagonalelements is %d\n',length(diagonalelements));
		fprintf('The length of diag(D) is %d\n',nrepresentativeleft);
		fprintf('The length of last cuttedoutpoints is %d\n',length(cuttedoutpoints));
		fprintf('The #rows of Wremaining is %d\n',size(Wremaining,1));
		fprintf('The #cols of Wremaining is %d\n',size(Wremaining,2));
		error('Check between length of diagonalelements and nrepresentativeleft');
    end

    %TODO: continue coding from here
    
    
    %Set A to I - D^(-1/2) W D^(-1/2)
    %Set A to the symmetrically normalized graph Laplacian
% 	D=zeros(nrepresentativeleft);
% 	A=-Wremaining; diag(A)=diagonalelements+diag(A);
% 	diagonalelements=1/(sqrt(diagonalelements));
% 	D=kronecker(diagonalelements,t(diagonalelements),FUN='*');
% 	A=A * D;
% 	%B=matrix(0,nrepresentativeleft,nrepresentativeleft);diag(B)=rep(1,nrepresentativeleft);
% 
% 
% 	%Eigen analysis
% 	eigens=eigen(A,symmetric=T);
    %Take eigenvector corresponding to the second smallest eigenvalue
% 	ssvector=eigens$vectors[,nrepresentativeleft-1];
% 	cuttedoutpoints=(1:nrepresentativeleft)[ssvector>=0];
% 
% 	if(F){
% 	browser();
% 	z=matrix(0,1,nrepresentative);
% 	tmpp=1-eigens$values;
% 	tmpp=sort(tmpp,decreasing=TRUE);
% 	for(ii in 1:nrepresentative-2)
% 	{ z[ii]=ii*sum(tmpp[(ii+1):(nrepresentative-1)]);
% 	} 
% 	plot(z[1,1:(nrepresentative-1)]);
% 	}
% 
% 
% 	%We favor the smaller cuttedoutpoints
% 	if(length(cuttedoutpoints)>0.5*nrepresentativeleft) cuttedoutpoints=(1:nrepresentativeleft)[-cuttedoutpoints];
% 	ccut=rvec[cuttedoutpoints];
% 
% 	%Bad things happen, discard the current loop
% 	if((length(cuttedoutpoints)==nrepresentative) || (length(cuttedoutpoints)==0))
% 	{ labelledpoints[ccut]=iloop;discard=1;fprintf('Discard the current loop\n');break;}
% 
% 	%To trace back to the original indices of all points currently NCutted
% 	rvec=rvec[-cuttedoutpoints];
% 	nrepresentativeleft=nrepresentativeleft-length(cuttedoutpoints);
% 	labelledpoints[ccut]=iloop;
% 	if(nrepresentativeleft <1) fprintf('Defective sampling\n');break; end

end%End of while(iloop)


