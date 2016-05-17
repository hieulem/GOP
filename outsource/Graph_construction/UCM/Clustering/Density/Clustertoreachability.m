function thecorrtable=Clustertoreachability(theclusters,RD,order,printonscreen,printonscreenforgraphs)
% thecorrtable=Clustertoreachability(theclusters,RD,order,true);
% theclusters=[1,3,4,1000,5,2,100]; theclusters=theclusters';

if ( (~exist('printonscreenforgraphs','var')) || (isempty(printonscreenforgraphs)) )
    printonscreenforgraphs=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;


%Introduce dummy npoints+1 to ease computation
neworder=[order,max(order)+1];
newrd=[RD,max(RD)+1];
%so that acluster==1 corresponds to Rdordered(1)
% [class,numberofclusters]=Labelwiththreshold(order,RD,Rdsorted(thepos),npoints,printonscreen)

Rdordered=newrd(neworder);

npoints=numel(newrd);

if (printonscreenforgraphs)
    Init_figure_no(10),bar(1:npoints,Rdordered)
    pause(5);
end

[Rdsorted]=sort(newrd,'descend');

[sortedclusters,clusteridx]=sort(theclusters,'ascend'); %clusteridx is used to unsort thecorrtable 

% Init_figure_no(10),scatter3(x(:,1),x(:,2),class')

thepos=1;
nreqclusters=numel(sortedclusters);
thecorrtable=zeros(nreqclusters,3);
for i=1:nreqclusters
    acluster=sortedclusters(i);
    [bestclass,thepos,bestnclusters,reachednpoints]=Determineclassthandbias(neworder,newrd,Rdsorted,acluster,npoints,thepos,printonscreeninsidefunction);

    if (printonscreenforgraphs)
        Init_figure_no(10), bar(1:npoints,bestclass(neworder),'y')
        hold on, plot(1:npoints,repmat(Rdsorted(thepos),1,npoints),'r'), hold off;
        hold on, bar(1:npoints,Rdordered,'b'), hold off;
        title(['Clusters ',num2str(bestnclusters),' pos ',num2str(thepos),' (reachednpoints ',num2str(reachednpoints),')']);
        pause(5);
    end

    if (reachednpoints)
        remainingclusters=sortedclusters(i:end);
        thecorrtable(i:end,:)= [  reshape(remainingclusters,[],1)  ,  repmat( [bestnclusters,Rdsorted(thepos)],numel(remainingclusters),1 )  ];
        break;
    else
        thecorrtable(i,:)=[acluster,bestnclusters,Rdsorted(thepos)];
    end
    % aclsuter the requested number of clusters
    % bestnclusters the closest number of clusters achievable
    % rdvalue=Rdsorted(thepos)
    %   ( [bestclass,thepos,bestnclusters]=Labelwiththreshold(neworder,newrd,rdvalue,npoints,printonscreen); )
end

backmapclusters=Mapitback(clusteridx);
thecorrtable=thecorrtable(backmapclusters,:);

if (printonscreen)
    fprintf('%10g %10g %10g\n',thecorrtable');
end



%test case
% thepos=100;
% acluster=5;
% [bestclass,thepos,bestnclusters]=Determineclassthandbias(neworder,newrd,Rdsorted,acluster,npoints,thepos,printonscreen);






function Otherfunctions(printonscreen) %#ok<DEFNU>



amargin=0.00001; %#ok<NASGU>

th=10;
class=Labelwiththreshold(order,RD,th,npoints); %amargin is subtracted before comparison in the function
numberofclusters=numel(unique(class))-any(class==(-1));
fprintf('Number of clusters %d (outlier present %d)\n',numberofclusters,any(class==(-1)));


acluster=3;
class=Labelwiththreshold(order,RD,Rdsorted(acluster),npoints); %amargin is subtracted before comparison in the function
numberofclusters=numel(unique(class))-any(class==(-1));
fprintf('Number of clusters %d (outlier present %d)\n',numberofclusters,any(class==(-1)));

% Init_figure_no(10),scatter3(x(:,1),x(:,2),class')

if (printonscreen)
    Init_figure_no(10),bar(1:npoints,class(order))
end

% Labelwiththreshold(order,RD,Rdsorted(acluster),npoints) returns acluster clusters

