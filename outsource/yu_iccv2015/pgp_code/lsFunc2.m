%lsFunc2.m
%
%creates the m equations for nonlinear least-squares to run, 2 param wbl

function F = lsFunc2(x,y,param, howMany)
%
% temp = param(1)*wblpdf3(x,param(2),param(4),0);
% temp2 = (1-param(1))*wblpdf3(x,param(3),param(5),param(6));
% temp3 = [temp,temp2]';
% maxP = max(temp3)';
%
% F = y-maxP;
if howMany == 2
    F = y-(param(1)*wblpdf(x,param(2),param(4))+(1-param(1))*wblpdf(x,param(3),param(5)));
else
    F = y-wblpdf(x,param(1),param(2));
end