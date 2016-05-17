cat("*********************************************************************\n");
#########################################################################
# UCI Musk dataset
# Number of classes 	2
# Number of features	166 (originally 168 but the first not used)
# Number of instances	6598
# 			musks(15.41%)+non(84.59%)
#########################################################################
##if(F){
cat("* UCI Musk (6598)\n");
x<-read.table(file="musk.Rdata",header=FALSE,sep=",",strip.white=FALSE);

x$label<-x$V169;
sp<-matrix(0,nrow(x),1);
sp[x$label=="1"]<-"1";
sp[x$label=="0"]<-"2";

tmp<-c("V1","V2","V169");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];

# To create the prerpocessed data in format usable by MATLAB
if(F){
write.table(x,file="muskr",sep=" ",row.names=FALSE,col.names=FALSE);
}

nc<-2;
cat("*  # Classes=",nc,"\n");
z<-espectral(x,sp,ncluster=nc,166);
##}



#########################################################################
# UCI Magic Gamma dataset
# Number of classes 	2
# Number of features	10
# Number of instances	19020
#			12332	gamma (signal)
#			6688	hardon (background)
#########################################################################
if(F){
cat("* UCI Magic Gamma (19020)\n");
x<-read.table(file="mgamma.Rdata",header=FALSE,sep=",",strip.white=FALSE);
if(F){
tmp<-c("V11");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
write.table(x,file="mgammarpt",sep=" ",row.names=FALSE,col.names=FALSE);
}
x$label<-x$V11;
sp<-matrix(0,nrow(x),1);
sp[x$label=="g"]<-"1";
sp[x$label=="h"]<-"2";

tmp<-c("V11");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
nc<-2;
cat("*  # Classes=",nc,"\n");
z<-espectral(x,sp,ncluster=nc,10);
}



#########################################################################
# UCI Census Income dataset
# Number of classes 	2
# Number of features	40
# Removed feature #26, 27, 28 as too many missing values on these columns
# Number of instances	199523(training)+99762(test)
# (After dropping ?'s)	285779
# Class distribution:   Below(93.80%)+Up(6.20%)
# Note: write.table() will ouput the data in various format
#########################################################################
if(F){
cat("* UCI Census Income(285779)\n");
x<-read.table(file="census-income.all.Rdata",header=FALSE,sep=",",strip.white=FALSE);
x[x[,42]=="- 5000."]<-"1";
x[x[,42]=="5000+."]<-"2";
tmp<-c("V26","V27","V28","V30");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
for(i in 1:38)
{	
	len<-length(x[,1]);
	x<-x[x[,i]!=" ?",];
	if(is.factor(x[,i])==TRUE)
		{ x[,i]<-as.integer(x[,i]); }

}

# To create the prerpocessed data in format usable by MATLAB
if(F){
write.table(x,file="usciallr",sep=" ",row.names=FALSE,col.names=FALSE);
}

x$label<-x$V42;
sp<-matrix(0,nrow(x),1);
sp[x$label=="1"]<-"1";
sp[x$label=="2"]<-"2";

tmp<-c("V42");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
nc<-2;
m<-37;
for(i in 1:m)
{
        if(sd(x[,i])==0) {x[,i]<-0;}
	                else {x[,i]<-(x[,i]-mean(x[,i]))/sd(x[,i]); }
}
cat("*  # Classes=",nc,"\n");
z<-espectral(x,sp,ncluster=nc,37);
}#End of USCI



#########################################################################
# UCI Connect-4 dataset
# Number of classes 	3
# Number of features	42
# Number of instances	67557
# Class distribution:	Win(65.83%)+Loss(24.62%)+Draw(9.55%)	
#########################################################################
if(F){
cat("* UCI Connect-4 (67557)\n");
x<-read.table(file="connect4.Rdata",header=FALSE,sep=",",strip.white=FALSE);
x$label<-x$V43;
sp<-matrix(0,nrow(x),1);
sp[x$label=="win"]<-"1";
sp[x$label=="loss"]<-"2";
sp[x$label=="draw"]<-"3";

tmp<-c("V43");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
for(i in 1:42) {x[,i]<-as.integer(x[,i])};
nc<-3;
m<-42;
for(i in 1:m)
{
        if(sd(x[,i])==0) {x[,i]<-0;}
	        else {x[,i]<-(x[,i]-mean(x[,i]))/sd(x[,i]); }
}
cat("*  # Classes=",nc,"\n");
z<-espectral(x,sp,ncluster=nc,42);
}



#########################################################################
# UCI Poker-Hand dataset
# Number of classes 	10 (==>3 by combining classes other than 0 and 1)
# Number of features	10
# Number of instances 	1000000
# Class distribution:	0(50.12%)+1(42.25%)+rest(7.63%)
#########################################################################
if(F){
cat("* UCI Poker-Hand (1000000)\n");
x<-read.table(file="pokerhand-test.Rdata",header=FALSE,sep=",",strip.white=FALSE);

x$label<-x$V11;
x$label[x$label >"2"]<-"2";
sp<-matrix(0,nrow(x),1);
sp[x$label=="0"]<-"1";
sp[x$label=="1"]<-"2";
sp[x$label=="2"]<-"3";

tmp<-c("V11");
rmcls<-match(tmp,names(x));
x<-x[,-rmcls];
nc<-3;
cat("*  # Classes=",nc,"\n");
z<-espectral(x,sp,ncluster=nc,10);
}
