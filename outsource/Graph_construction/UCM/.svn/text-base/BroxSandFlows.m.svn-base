function BroxSandFlows()

path(path,'UCM\Flow\brox_zip');
path(path,'UCM\Flow\sand_zip');

img1=imread('UCM\Flow\car0.png');
img2=imread('UCM\Flow\car1.png');

[u, v] = optic_flow_brox(img1, img2);
[u, v] = optic_flow_sand( img1, img2 );

data = binornd(20,0.75,100,1); % Simulated data, p = 0.75

[phat,pci] = mle(data,'distribution','binomial',...
                 'alpha',.05,'ntrials',20)
             
             
mu = [0 0];
Sigma = [.25 .3; .3 1];
x1 = -3:.2:3; x2 = -3:.2:3;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
surf(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([-3 3 -3 3 0 .4])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');

MU1 = [1 2];
SIGMA1 = [2 0; 0 .5];
MU2 = [-3 -5];
SIGMA2 = [1 0; 0 1];
X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,1000)];

scatter(X(:,1),X(:,2),10,'.')
hold on
options = statset('Display','final');
obj = gmdistribution.fit(X,2,'Options',options);
h = ezcontour(@(x,y)pdf(obj,[x y]),[-8 6],[-8 6]);

n = 1000; rho = .7;
Z = mvnrnd([0 0],[1 rho; rho 1],n);
U = normcdf(Z);
X = [gaminv(U(:,1),2,1) tinv(U(:,2),5)];

scatterhist(X(:,1),X(:,2))

height = normrnd(50,2,30,1);             % Simulate heights.
[mu,s,muci,sci] = normfit(height)

r = mvnrnd(MU,SIGMA,cases)

mu = [2 3];
SIGMA = [1 1.5; 1.5 3];
r = mvnrnd(mu,SIGMA,100);
plot(r(:,1),r(:,2),'+')






% [muhat,sigmahat,muci,sigmaci] = normfit(data,alpha) returns 100(1 - alpha) % confidence intervals for the parameter estimates, where alpha is a value in the range [0 1] specifying the width of the confidence intervals. By default, alpha is 0.05, which corresponds to 95% confidence intervals. 
% 
% [...] = normfit(data,alpha,censoring) accepts a Boolean vector, censoring, of the same size as data, which is 1 for observations that are right-censored and 0 for observations that are observed exactly. data must be a vector in order to pass in the argument censoring.
% 
% [...] = normfit(data,alpha,censoring,freq) accepts a frequency vector, freq, of the same size as data. Typically, freq contains integer frequencies for the corresponding elements in data, but can contain any nonnegative values. Pass in [] for alpha, censoring, or freq to use their default values.



mu=[3;5];
SIGMA=[1,0.5;0.5,1];
no=1000000;

%matlab functions
tic
r = mvnrnd(mu,SIGMA,no);
figure(2), set(gcf, 'color', 'white');
plot(r(:,1),r(:,2),'+')
cov(r)
toc

[muhat,sigmahat] = normfit(r);

phat = mle(r,'distribution','normal'); %'frequency'

%written functions
tic
y=genGauss(SIGMA,mu,no);
% y=mvg(mu,SIGMA,no);
cov(y)
toc





MU1 = [1 2];
SIGMA1 = [2 0; 0 .5];
MU2 = [-3 -5];
SIGMA2 = [1 0; 0 1];
X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,1000)];

scatter(X(:,1),X(:,2),10,'.')
hold on
options = statset('Display','final');
obj = gmdistribution.fit(X,2,'Options',options);

h = ezcontour(@(x,y)pdf(obj,[x y]),[-8 6],[-8 6]);
hold off

