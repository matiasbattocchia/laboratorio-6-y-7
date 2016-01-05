%%% cambiar_duracion.m %%%
%
% Esta rutina permite reconfigurar la duración de la adquisición
% sin tener que volver a correr configurar.m e inicializar.m.

duracion_video = 8;

stop(vid);

vid.FrameGrabInterval = round(velocidad_camara / cuadros_por_segundo);
cuadros_por_segundo_posta = velocidad_camara / vid.FrameGrabInterval;
vid.FramesPerTrigger = cuadros_por_segundo_posta * duracion_video;

start(vid);
