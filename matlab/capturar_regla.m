%%% capturar_regla.m %%%
%
% Toma una fotografía y la guarda en el disco. Esta rutina es útil para
% fotografiar elementos de referencia (como una regla).

img = getsnapshot(vid);
imwrite(img, strcat(directorio_de_trabajo, date, '_', infijo, '_', 'regla', '.png'));
