function G = Selectkneighboursnodiagonal(G,n_size,printthetext,makesymmetric,gisdistance,neglectdiagonal)
% G is a sparse distance or diagonal matrix
% n_size specifies the maximum number of connectivity for each node. The
% elements on the diagonal, if present, are also considered.
% makesymmetric==false ensures exactly n_size connections for each node
% makesymmetric==true ensures simmetry but the max connectivity is not
% guaranteed to be n_size

if ( (~exist('neglectdiagonal','var')) || (isempty(neglectdiagonal)) )
    neglectdiagonal = true; %by default the diagonal matrix is not considered
end
if ( (~exist('gisdistance','var')) || (isempty(gisdistance)) )
    gisdistance = true; %by default G is a distance matrix, false indicates affinity
end
if ( (~exist('makesymmetric','var')) || (isempty(makesymmetric)) )
    makesymmetric = true;
end
if ( (~exist('printthetext','var')) || (isempty(printthetext)) )
    printthetext = false;
end



%Do not change G when n_size==0
if (n_size==0)
    return;
end 



N = size(G,1);



%Save diagonal and replace it with zeros
if (neglectdiagonal)
    origdiag= spdiags(G,0);
%     if (gisdistance)
%         G = spdiags(ones([N,1]).*Inf,0,G);
%     else
        G = spdiags(zeros([N,1]),0,G); %Since matrices are sparse, Inf for distances is also 0
%     end
end



%Select k neighbors
Di = zeros(N*n_size,1);      Dj = zeros(N*n_size,1);       Ds = zeros(N*n_size,1); %upper bound for the required memory
counter = 0; 
[a,b,c] = find(G); 
loctimeid=tic;
if (gisdistance) %sorting is done once for all values
    [c,idx] = sort(c,'ascend');
else
    [c,idx] = sort(c,'descend');
end
a=a(idx); b=b(idx); %indexes are arranged according to sorting
for i=1:N
    l = find(a==i,n_size,'first'); %Find at most n_size elements connected to the i-th superpixel
    Ki=numel(l);
    Di(counter+(1:Ki),1) = i;
    Dj(counter+(1:Ki),1) = b(l);
    Ds(counter+(1:Ki),1) = c(l);
    counter = counter+Ki;
    if ((printthetext) && (rem(i,1000) == 0)) 
        disp([' Iteration: ' num2str(i) '     Estimated time to completion: ' num2str( ((N-i)*toc(loctimeid)/i) / 60 ) ' minutes']);
    end
end
if (makesymmetric)
    if (gisdistance)
        G = sparse(Di(1:counter), Dj(1:counter), Ds(1:counter), N, N);
        G = max(G,G');    %% Make sure distance matrix is symmetric
    else %in case of affinities, min should be used if both entries are non zero
        %The following does the average when both entries are non-zero or chooses one, safer
        G1 = sparse(Di(1:counter), Dj(1:counter), Ds(1:counter), N, N);
        G2 = sparse(Dj(1:counter), Di(1:counter), Ds(1:counter), N, N);
        [G]=Getcombinedsimilaritieswithmethod(G1,G2,'wsum',[],0.5,0.5);
    end
else
    G = sparse(Di(1:counter), Dj(1:counter), Ds(1:counter), N, N);
end
if (counter<numel(a))
    fprintf('%d elements entered into the sparse matrix instead of %d\n',counter,numel(a));
end



%Restore diagonal values
if (neglectdiagonal)
    G = spdiags(origdiag,0,G);
end








function test()

Gfaff=[1,0,0.6,0,0.2;0,1,0,0.1,0.3;0.6,0,1,0.5,0.6;0,0.1,0.5,1,0.1;0.2,0.3,0.6,0.1,1]
Gfdist=1.01-Gfaff;
Gfdist(Gfdist>=1)=0
G=sparse(Gfdist);
Gaff=sparse(Gfaff);

printthetext=true;
makesymmetric=true;
gisdistance=true;
n_size=3;
Gback = full(Selectkneighbours(G,n_size,5,printthetext,makesymmetric,gisdistance))

printthetext=true;
makesymmetric=true;
gisdistance=false;
n_size=3;
Gbackaff = full(Selectkneighbours(Gaff,n_size,5,printthetext,makesymmetric,gisdistance))

numberofsuperpixels=sum(  numberofsuperpixelsperframe);

[r,c,v]=find(STA);
STA=sparse(r,c,v,numberofsuperpixels,numberofsuperpixels);

STT4(71087,:)
STT3(69046,:)

STT=STT+STT';

sparse([1,2,2],[2,3,3],[1,2,3],3,3);



NENLARGE=8;
Gfaff=[1,0,0.6,0,0.2;0,1,0,0.1,0.3;0.6,0,1,0.5,0.6;0,0.1,0.5,1,0.1;0.2,0.3,0.6,0.1,1];
for i=1:NENLARGE
    Gfaff=[Gfaff*0.1,Gfaff*0.5;Gfaff*0.9,Gfaff*1];
end
Gaff=sparse(Gfaff);
printthetext=true;
makesymmetric=true;
gisdistance=false;
n_size=6;
tic
Gbackaff = full(Selectkneighbours(Gaff,n_size,5,printthetext,makesymmetric,gisdistance));
toc
tic
Gbackaff2 = full(Selectkneighbours_backup_speed(Gaff,n_size,5,printthetext,makesymmetric,gisdistance));
toc
isequal(Gbackaff,Gbackaff2)


