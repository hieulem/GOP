function somemagnitudes=Addquantiledmagnitudes(magnitude,neglectextremapixels)

[ordvalues]=sort(magnitude,'ascend');

novalues=numel(magnitude);

somemagnitudes=ordvalues(neglectextremapixels+1:novalues-neglectextremapixels);

% numel(neglectextremapixels+1:novalues-neglectextremapixels)