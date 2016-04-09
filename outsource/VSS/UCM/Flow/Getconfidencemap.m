function [confidencemap,validity]=Getconfidencemap(theflow,backwardflow,useinterp,printonscreen)


[Ubackwarped,validtopu]=Getawarpedsingleimage(theflow,backwardflow(:,:,1),useinterp,[],printonscreen);
[Vbackwarped,validtopv]=Getawarpedsingleimage(theflow,backwardflow(:,:,2),useinterp,[],printonscreen);

rows=size(Ubackwarped,1);
cols=size(Ubackwarped,2);
[U,V]=meshgrid(1:cols,1:rows); %pixel coordinates

confidencemap=sqrt( (Ubackwarped-U).^2 + (Vbackwarped-V).^2 );
validity=validtopu&validtopv;

confidencemap(~validity)=-1;

if (printonscreen)
    Init_figure_no(58), imagesc(confidencemap); title('Confidence map in pixels');
    Init_figure_no(59), imagesc(validity); title('Confidence map validity');
end

