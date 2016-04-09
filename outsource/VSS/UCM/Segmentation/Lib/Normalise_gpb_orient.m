function [pb_norm] = Normalise_gpb_orient(pb)

[tx, ty] = size(pb);
pb_norm = max(0, min(1, 1.2*pb));

%contrast change with sigmoid 
beta = [-2.6433; 10.7998];
pb_norm = pb_norm(:);
x = [ones(size(pb_norm)) pb_norm]';
pb_norm = 1 ./ (1 + (exp(-x'*beta)));
pb_norm = (pb_norm-0.0667) / 0.9333;
pb_norm = reshape(pb_norm, [tx ty]);
