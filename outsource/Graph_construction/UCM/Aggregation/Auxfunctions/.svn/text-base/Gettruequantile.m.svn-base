function qq=Gettruequantile(values,probability)
% values=[1,2,3,4,5,6,7,8,9];
% probability=0.1;
% values=allmagnitude;

[ordvalues]=sort(values,'ascend');

novalues=numel(values);

position=min(max( round(probability*novalues) ,1),novalues);

qq=ordvalues(position);
