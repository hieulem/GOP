function [Xw_1,Xw_2, Xa1_1,Xa1_2, Xa2, Xa_2, indw_1,indw_2, inda1_1,inda1_2, inda2, inda_2] = getFeatures_test_new(STT,LTT,ABA,ABM,STM,STA,STM3,STA3,SD,STT_max,STT_mean,Dspx,CTR,noallsuperpixels,framebelong, options)

  if options.new_features
  [~,~,v_stm3] = find(STM3);
  clear STM3
  [~,~,v_sta3] = find(STA3);
  clear STA3
  
  [i_std,j_std,v_std] = find(SD); 
  [~,i5]=sort(i_std);
  clear SD 
  
  [i_ds,j_ds,v_ds] = find(Dspx); 
  [~,i7]=sort(i_ds);
  clear Dspx  
  
  [i_text,j_text,v_text_max] = find(STT_max);
  [~,i6]=sort(i_text);
  clear STT_max
  [~,~,v_text_mean] = find(STT_mean);
  clear STT_mean
  
  end   
  [i_stt,j_stt,v_stt] = find(STT); 
  [~,i1]=sort(i_stt);
  clear STT
  [i_sta,j_sta,v_sta] = find(STA);
  [~,i2]=sort(i_sta);
  clear STA
  [~,~,v_stm] = find(STM);
  clear STM
  [i_aba,j_aba,v_aba] = find(ABA);
  [~,i3]=sort(i_aba);
  clear ABA
  [~,~,v_abm] = find(ABM);
  clear ABM
  [i_ltt,j_ltt,v_ltt] = find(LTT);
  [~,i4]=sort(i_ltt);
  clear LTT
  [~,~,v_ctr] = find(CTR);
  clear CTR
  
  
if options.new_features
   
[Xw_1,Xw_2, Xa1_1,Xa1_2, Xa2, Xa_2, indw_1,indw_2, inda1_1,inda1_2, inda2, inda_2]=Getfeatures_cpp_new(noallsuperpixels,v_stt(i1),i_stt(i1),j_stt(i1),v_stm(i2),v_sta(i2),i_sta(i2),j_sta(i2),v_abm(i3),v_aba(i3),i_aba(i3),j_aba(i3),v_ctr(i4),v_ltt(i4),i_ltt(i4),j_ltt(i4),v_std(i5),v_stm3(i2),v_sta3(i2),framebelong, v_text_max(i6),v_text_mean(i6),i_text(i6),j_text(i6),v_ds(i7),i_ds(i7),j_ds(i7),i_std(i5),j_std(i5));

% else   
% 
% [Xw, Xa1, Xa2, Xa_2, indw, inda1, inda2, inda_2]=Getfeatures_cpp(noallsuperpixels,v_stt(i1),i_stt(i1),j_stt(i1),v_stm(i2),v_sta(i2),i_sta(i2),j_sta(i2),v_abm(i3),v_aba(i3),i_aba(i3),j_aba(i3),v_ctr(i4),v_ltt(i4),i_ltt(i4),j_ltt(i4),framebelong);

end

end




