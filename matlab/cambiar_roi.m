%%% cambiar_roi.m %%%
%
% Esta rutina permite reconfigurar la región de interés de la cámara
% sin tener que volver a correr configurar.m e inicializar.m.

roi_camara = [0 145 640 200];

stop(vid);

vid.ROIPosition = roi_camara;

start(vid);
preview(vid);
