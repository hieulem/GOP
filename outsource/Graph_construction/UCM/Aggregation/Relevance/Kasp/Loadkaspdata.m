function [mldata,mgt,nclusters]=Loadkaspdata(datalocation,nametag)
%Correspondance labels: x mldata, sp mgt, ncluster nclusters

%TODO: write other reading functions
%TODO: remove the reading limitation

if ( (~exist('datalocation','var')) || (isempty(datalocation)) )
    datalocation=['.',filesep];
end

datareduce=Inf; %100000

switch(nametag)
    case 'PokerHand'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % UCI Poker-Hand dataset
        % Number of classes 	10 (==>3 by combining classes other than 0 and 1)
        % Number of features	10
        % Number of instances 	1000000
        % Class distribution:	0(50.12%)+1(42.25%)+rest(7.63%)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        tmpdata=dlmread(fullfile(datalocation,'pokerhand-test.Rdata'),',');
        fprintf('* UCI Poker-Hand (%d,%d)\n',size(tmpdata,1),size(tmpdata,2));
        
        mldata=tmpdata(1:min(size(tmpdata,1),datareduce),1:(end-1)); %x
        mgt=tmpdata(1:min(size(tmpdata,1),datareduce),end); %sp
        % disp(size(mgt)); disp(size(mldata)); disp(unique(mgt));
        
        %Assign all labels larger than 2 the label 2 (so labels are 0:2)
        mgt(mgt>2)=2;
        mgt=mgt+1; %set min label to 1 (so labels are 1:3)
        
        %Compute statistics
        fprintf('* Class distribution: 1(%.2f%%) + 2(%.2f%%) + 3(%.2f%%)\n',100*sum(mgt==1)/numel(mgt),100*sum(mgt==2)/numel(mgt),100*sum(mgt==3)/numel(mgt));
        
        nclusters=numel(unique(mgt));
        
        % x<-read.table(file="pokerhand-test.Rdata",header=FALSE,sep=",",strip.white=FALSE);
        % 
        % x$label<-x$V11;
        % x$label[x$label >"2"]<-"2";
        % sp<-matrix(0,nrow(x),1);
        % sp[x$label=="0"]<-"1";
        % sp[x$label=="1"]<-"2";
        % sp[x$label=="2"]<-"3";
        % 
        % tmp<-c("V11");
        % rmcls<-match(tmp,names(x));
        % x<-x[,-rmcls];
        % nc<-3;
        % cat("*  # Classes=",nc,"\n");
        % z<-espectral(x,sp,ncluster=nc,10);
    otherwise
        fprintf('Requested data not evailable\n');
        mldata=[];
        mgt=[];
        nclusters=[];
end
        
        