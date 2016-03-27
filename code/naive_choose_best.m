
[~,x] = min(final_dist2,[],2);
nlb = sp(:,:,2);
nlb = convertspmap(nlb,1:splist(2),x);

sp(:,:,2) = nlb;
