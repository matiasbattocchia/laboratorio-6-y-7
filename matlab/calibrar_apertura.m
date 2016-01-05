%%% calibrar_apertura.m %%%
%
% Permite escoger la apertura de la lente más adecuada
% para el umbral de binarización elegido (ver configurar.m).

while 1
  pause(0.5);
  imshow(im2bw(getsnapshot(vid), umbral_binarizacion));
end
