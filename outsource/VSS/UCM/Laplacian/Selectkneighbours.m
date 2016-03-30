function G = Selectkneighbours(G,n_size,N,printthetext,makesymmetric,gisdistance)
% G is a sparse distance matrix
% n_size specifies the maximum number of connectivity for each node. The
% elements on the diagonal, if present, are also considered.
% makesymmetric==false ensures exactly n_size connections for each node
% makesymmetric==true ensures simmetry but the max connectivity is not
% guaranteed to be n_size

if ( (~exist('gisdistance','var')) || (isempty(gisdistance)) )
    gisdistance = true; %by default G is a distance matrix, false indicates affinity
end
if ( (~exist('makesymmetric','var')) || (isempty(makesymmetric)) )
    makesymmetric = true;
end
if ( (~exist('printthetext','var')) || (isempty(printthetext)) )
    printthetext = false;
end
if ( (~exist('N','var')) || (isempty(N)) )
    N = size(G,1);
end

 if (n_size~=0)
     Di = zeros(N*n_size,1);      Dj = zeros(N*n_size,1);       Ds = zeros(N*n_size,1); %upper bound for the required memory
     counter = 0; 
     [a,b,c] = find(G); 
     tic; 
     for i=1:N
         l = find(a==i);
         if (n_size<numel(l))
             if (gisdistance)
                 [g,f] = sort(c(l),'ascend');
             else
                 [g,f] = sort(c(l),'descend');
             end
             Di(counter+(1:n_size)) = i; 
             Dj(counter+(1:n_size)) = b(l(f(1:n_size))); 
             Ds(counter+(1:n_size)) = g(1:n_size); 
             counter = counter+n_size; 
         else %no need to sort in this case
             Ki=numel(l);
             Di(counter+(1:Ki),1) = i; 
             Dj(counter+(1:Ki),1) = b(l(1:Ki)); 
             Ds(counter+(1:Ki),1) = c(l(1:Ki)); 
%              Di(counter+(1:Ki),1) = i; 
%              Dj(counter+(1:Ki),1) = b(l(f(1:Ki))); 
%              Ds(counter+(1:Ki),1) = g(1:Ki); 
             counter = counter+Ki;
         end
         if ((printthetext) && (rem(i,1000) == 0)) 
              disp([' Iteration: ' num2str(i) '     Estimated time to completion: ' num2str((N-i)*toc/60/50) ' minutes']); tic; 
         end
     end
     if (makesymmetric)
         G = sparse(Di(1:counter), Dj(1:counter), Ds(1:counter), N, N);
         if (gisdistance)
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
 end %when n_size==0 G does not have to be changed

 
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