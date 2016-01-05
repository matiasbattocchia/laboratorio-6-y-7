%%% configurar.m %%%
%
% Par�metros configurables.

% Directorio de trabajo
directorio_de_trabajo = 'C:\Documents and Settings\Roman\Escritorio\Mat�as\';

% Regi�n de inter�s de la c�mara principal
% De -6 a 6 cm.
roi_camara = [0 145 640 200];

% Regi�n de inter�s de la c�mara detector
roi_detector = [260 180 350 40];

% Cuadros por segundo (FPS)
cuadros_por_segundo = 100;

% Velocidad c�mara (en FPS)
% No tocar salvo que se modifique la configuraci�n de la c�mara desde PULNiX_RM-6740CL.ccf.
velocidad_camara = 200;

% Duraci�n video (en segundos)
duracion_video = 8;

% Umbral detector
umbral_detector = 0.01;

% Umbral binarizaci�n
umbral_binarizacion = 0.25;
