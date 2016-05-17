function Kasp()
%TODO: in Loadkaspdata
%TODO: debug reweighting
%TODO: debug initial kmeans

Setthepath();



datasetcase='PokerHand'; %PokerHand, Musk, MagicGamma, Connect4, USCI



%%%SETUP
datalocation=[filesep,'BS',filesep,'galasso_proj_spx',filesep,'work',filesep,'Kasp',filesep];

[mldata,mgt,nclusters]=Loadkaspdata(datalocation,datasetcase);
%Correspondance labels: x mldata, sp mgt, ncluster nclusters

[alpha,sigma]=Loadkaspsetup(datasetcase);

ndatapoints=size(mldata,1);	%The % of observations
nfeatures=size(mldata,2);

infty=10^12; %TODO: this should be Inf

fprintf('* Data points = %d\n',ndatapoints);
fprintf('* Features = %d\n',nfeatures);

nrepresentative=floor(ndatapoints/alpha);
fprintf('* Representative data points = %d, data reduction ratio=1/%d\n',nrepresentative,alpha);
fprintf('*********************************************************************\n');
fprintf('Finished data loading......\n');



%%%Initial k-means
% Run two-stage K-means if there are more than 20000 points else run single K-means
nameaddition='sampled'; %used to generate different study cases
kmoutputfilesaved=[filesep,'BS',filesep,'galasso_proj_spx',filesep,'work',filesep,'Kasp',filesep,datasetcase,'_case',nameaddition,'_',num2str(alpha),'.mat'];
LOADANDSAVE=true;
OVERWRITESAVED=false;
if ( (exist(kmoutputfilesaved,'file')) && LOADANDSAVE && (~OVERWRITESAVED) )
    load(kmoutputfilesaved);
    fprintf('Representative points loaded\n');
else
    if (ndatapoints>20000)
        %The sampling ratio for the 1st round of K-means 0.05 for dataset size larger than 300000
        %this ratio can be even smaller for still larger dataset
        if (ndatapoints<300000)
            nsubsample=ndatapoints*0.1;
        else
            nsubsample=ndatapoints*0.05;
        end

        idxsubsample = randperm(ndatapoints,nsubsample);
        subsampleddata=mldata(idxsubsample,:);

        fprintf('Start of coarse K-means\n');

        %The maximum number of iterations and the number of re-starts can both be 
        %adjusted depending on the data. Same applies to other invocations of 
        %K-means 
        noreplicates=20;
        [kmcenterssubsampled,kmidxsubsampled] = vl_kmeans(subsampleddata',nrepresentative,'NumRepetitions',noreplicates,'Initialization','randsel','Algorithm','elkan'); %,Energy
        kmcenterssubsampled=kmcenterssubsampled';
        kmidxsubsampled=kmidxsubsampled';
        % disp(size(kmcenterssubsampled)); disp(size(kmidxsubsampled));
    % 	xxkms=kmeans(subsampleddata',nrepresentative, 'iter.max = 200', 'nstart = 20', 'algorithm = Hartigan-Wong'); %

        fprintf('Start of fine K-means\n');
        noreplicates=1;
        [kmidx,kmcenters] = kmeans(mldata,size(kmcenterssubsampled,1), 'start',kmcenterssubsampled,'replicates',noreplicates);
        % disp(size(kmcenters)); disp(size(kmidx));
    % 	xkms=kmeans(mldata,'centers=xxkms$centers', 'iter.max = 200', 'nstart = 1', 'algorithm = Hartigan-Wong');
    else
        fprintf('Start of K-means\n');
        noreplicates=20;
        %xkms=kmeans(mldata(:,1:nfeatures),'centers=nrepresentative', 'iter.max = 200', 'nstart = 20', 'algorithm = Hartigan-Wong');
        [kmcenters,kmidx] = vl_kmeans(mldata',nrepresentative,'NumRepetitions',noreplicates,'Initialization','randsel','Algorithm','elkan'); %,Energy
            %'Initialization','plusplus'
        kmcenters=kmcenters';
        kmidx=kmidx';
        % disp(size(kmcenters)); disp(size(kmidx));
        %kmcenters = [nrepresentive,nfeatures]
        %kmidx=[ndatapoints,1]

    end
    if (LOADANDSAVE)
        save(kmoutputfilesaved,'kmcenters','kmidx','-v7.3');
        fprintf('Representative points saved\n');
    end
end

if (nrepresentative~=size(kmcenters,1))
    fprintf('N representatives changed from %d to %d\n',nrepresentative,size(kmcenters,1));
    nrepresentative=size(kmcenters,1);
end

%Compute upper bound performance
upperassignmentrate=Evaluateupperbound(kmidx,mgt,nclusters,ndatapoints,nrepresentative);


%Commpute similarity matrix among representative points
similarities=zeros(nrepresentative,nrepresentative);
for i=1:nfeatures
    similarities = similarities + (repmat(kmcenters(:,i),1,nrepresentative)-repmat(kmcenters(:,i)',nrepresentative,1)).^2;
end
%similarities(i,j) is the squared distance between center i and j, similarities(i,j)= (norm(i,j))^2
% similarities2=zeros(nrepresentative,nrepresentative);
% for i=1:nrepresentative
%     for j=1:nrepresentative
%         similarities2(i,j)= sum((kmcenters(i,:)-kmcenters(j,:)).^2);
%     end
% end
% isequal(similarities,similarities2)



%Compute the multiplicity of the clustered points, used in the reweighting
normpertrack=zeros(nrepresentative,1);
%dim(multiplicity)
for i=1:ndatapoints
	normpertrack(kmidx(i))=normpertrack(kmidx(i))+1;
end
% sum(normpertrack)==ndatapoints



%%% Iterate this part for training sigma
%%% Comment this part to just execute %%%
% allsigmas=0.1:0.1:10;
% ntrials=10; ntotcomputations=numel(allsigmas)*ntrials;
% allassignmentrates=zeros(numel(allsigmas),1);
% for count=1:ntotcomputations
%     incount=floor((count-1)/ntrials)+1;
%     sigma=allsigmas(incount);
%     fprintf('Count %d (out of %d)\n',count,ntotcomputations);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Compute the affinity matrix W
    % The bandwidth parameter (sigma): this value is to be searched over a range
    % The following, in the form of (reduction ratio, sigma), are examples of good (by no means the best) values based on our experiments.
    % Note even for the same dataset, the optimal sigma varies for different reduction ratios
    % The precomputed values are in Loadkaspsetup
    fprintf('Sigma=%g\n',sigma);
    W=exp(-similarities/sigma);
    % disp(size(W)); disp(mean2(W)); disp(std2(W)); disp(max(W(:))); disp(min(W(:)));


    %Normalize the matrix equivalently
    EQUIVREWEIGHT=false;
    if (EQUIVREWEIGHT)
%         W=Reweightequivalentlyhein(W,normpertrack,nrepresentative);
        W=Reweightequivalently(W,normpertrack,nrepresentative);
    %     W3=full(Reweightequivalently(sparse(W),normpertrack,nrepresentative));
    %     isequal(W2,W3); find(W2-W3); Wprev=W; W=Wprev;
    end


    methodofchoice=3;
    dimtouse=size(W,1)-1; % 10 size(W,1) disp(size(W));
    mappedX=Newlaplacian(W,dimtouse,methodofchoice); %,lambda,L
%     mappedX2=Newlaplacian(sparse(W),dimtouse,methodofchoice); %,lambda,L
%     max(abs(mappedX(:)-mappedX2(:)))
    %mappedX is no_data_points x (nodims+1)


    noreplicates=300;
    [Ctmp,IDXtmp] = vl_kmeans(mappedX',nclusters,'NumRepetitions',noreplicates,'Initialization','randsel','Algorithm','elkan'); %,Energy
            %,'Algorithm','elkan','lloyd'
            %,'Initialization','randsel','plusplus'
    IDX=IDXtmp';
    C=Ctmp';
    %kmcenters = [nrepresentive,nfeatures]   kmidx=[ndatapoints,1]


    %Recover the cluster membership of all data points
    kmidxnew=kmidx;
    for i = 1:nrepresentative
        kmidxnew(kmidx==i)=IDX(i);
    end
    % mgt=ncut(W,nclusters,nrepresentative);

    
    correctassignmentrate=Crate(mgt, kmidxnew, nclusters, ndatapoints);
    %Compute statistics
    % fprintf('Class distribution: 1(%.2f%%) + 2(%.2f%%) + 3(%.2f%%)\n',100*sum(kmidxnew==1)/numel(kmidxnew),100*sum(kmidxnew==2)/numel(kmidxnew),100*sum(kmidxnew==3)/numel(kmidxnew));
    
%%% Comment this part to just execute %%%
%     allassignmentrates(incount)=allassignmentrates(incount)+correctassignmentrate;
% end
% allassignmentrates=allassignmentrates/ntrials;
% % save(['..',filesep,'Kasp_0d1to10ev0d1_nonormnorew.mat'],'allsigmas','allassignmentrates');
% % save(['..',filesep,'Kasp_0d1to10ev0d1_norew.mat'],'allsigmas','allassignmentrates');
% % save(['..',filesep,'Kasp_0d1to10ev0d1_nonormrew.mat'],'allsigmas','allassignmentrates');
% % save(['..',filesep,'Kasp_0d1to10ev0d1_rew.mat'],'allsigmas','allassignmentrates');
% 
% Init_figure_no(1), plot(allsigmas, allassignmentrates);
% figure(1), hold on, plot(allsigmas, allassignmentrates,'c'); hold off;
% figure(1), hold on, plot(allsigmas, allassignmentrates,'g'); hold off;
% figure(1), hold on, plot(allsigmas, allassignmentrates,'r'); hold off;
% % load(['..',filesep,'Kasp_0d1to10ev0d1_norew.mat']);
% % load(['..',filesep,'Kasp_0d1to10ev0d1_nonormrew.mat']);
% % load(['..',filesep,'Kasp_0d1to10ev0d1_rew.mat']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
