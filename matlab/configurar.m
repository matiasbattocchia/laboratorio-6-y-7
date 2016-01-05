%%% configurar.m %%%
%
% Parámetros configurables.

% Directorio de trabajo
directorio_de_trabajo = 'C:\Documents and Settings\Roman\Escritorio\Matías\';

% Región de interés de la cámara principal
% De -6 a 6 cm.
roi_camara = [0 145 640 200];

% Región de interés de la cámara detector
roi_detector = [260 180 350 40];

% Cuadros por segundo (FPS)
cuadros_por_segundo = 100;

% Velocidad cámara (en FPS)
% No tocar salvo que se modifique la configuración de la cámara desde PULNiX_RM-6740CL.ccf.
velocidad_camara = 200;

% Duración video (en segundos)
duracion_video = 8;

% Umbral detector
umbral_detector = 0.01;

% Umbral binarización
umbral_binarizacion = 0.25;
