function G=Selectkglobal(G,maxk,makesimmetric,gisdistance)

if ( (~exist('gisdistance','var')) || (isempty(gisdistance)) )
    gisdistance = true; %by default G is a distance matrix, false indicates affinity
end
if ( (~exist('makesimmetric','var')) || (isempty(makesimmetric)) )
    makesimmetric = true; %This means potentially including more elements than allowed
end


% T=triu(G,1); %Upper triangular matrix, so as to keep the matrix symmetric

[xx,yy,vv]=find(G); %size(vv)



if (maxk>=numel(vv))
    fprintf('Entered all %d edges (including symmetric ones), ignoring global limit of %d\n',numel(vv),maxk);
    return;
end



%Keep k global best neighbors
if (gisdistance)
    [vv,idx] = sort(vv,'ascend');
else
    [vv,idx] = sort(vv,'descend');
end



if (makesimmetric)
    if (gisdistance)
        G=sparse(xx(idx(1:maxk)),yy(idx(1:maxk)),vv(1:maxk),size(G,1),size(G,2));
        G = max(G,G');    %% Make sure distance matrix is symmetric
    else %in case of affinities, min should be used if both entries are non zero
        %The following does the average when both entries are non-zero or chooses one, safer
        G1 = sparse(xx(idx(1:maxk)),yy(idx(1:maxk)),vv(1:maxk),size(G,1),size(G,2));
        G2 = sparse(yy(idx(1:maxk)),xx(idx(1:maxk)),vv(1:maxk),size(G,1),size(G,2));
        [G]=Getcombinedsimilaritieswithmethod(G1,G2,'wsum',[],0.5,0.5);
    end
else
    G=sparse(xx(idx(1:maxk)),yy(idx(1:maxk)),vv(1:maxk),size(G,1),size(G,2));
end



fprintf('Entered %d edges (including symmetric ones) from a total of %d, maxk %d\n',nnz(G),numel(vv),maxk);



function test() %#ok<DEFNU>

%Previous version
[xx,yy,vv]=find(hosimilarities); %#ok<NODEF> %size(vv)
if (mhoptions.mhkeepkglob<numel(vv))
    [vv,idx]=sort(vv,'descend');
    hosimilarities=sparse(xx(idx(1:mhoptions.mhkeepkglob)),yy(idx(1:mhoptions.mhkeepkglob)),vv(1:mhoptions.mhkeepkglob),size(hosimilarities,1),size(hosimilarities,2)); %#ok<NASGU>
    fprintf('Entered all %d edges (including symmetric ones), ignoring global limit of %d\n',numel(vv),mhoptions.mhkeepkglob);
else
    fprintf('Entered all %d edges (including symmetric ones), ignoring global limit of %d\n',numel(vv),mhoptions.mhkeepkglob);
end


%Test the function
NENLARGE=9;
Gfaff=[1,0,0.6,0,0.2;0,1,0,0.1,0.3;0.6,0,1,0.5,0.6;0,0.1,0.5,1,0.1;0.2,0.3,0.6,0.1,1];
for i=1:NENLARGE
    Gfaff=[Gfaff*0.1,Gfaff*0.5;Gfaff*0.9,Gfaff*1];
end
Gaff=sparse(Gfaff);

makesimmetric=true;
gisdistance=false;
maxk=3000005;
tic
Gbackaff = full(Selectkglobal(Gaff,maxk,makesimmetric,gisdistance)); %#ok<NASGU>
toc

