%%% inicializar.m %%%
%
% Instrucciones para activar las cámaras.

warning('off', 'all');

vid = videoinput('dalsa', 1, 'PULNiX_RM-6740CL.ccf');
detector = imaq.VideoDevice('winvideo', 1, 'MJPG_1024x768', 'ROI', roi_detector, 'ReturnedColorSpace', 'grayscale');
optical = vision.OpticalFlow();

vid.ROIPosition = roi_camara;

preview(vid);
preview(detector);

triggerconfig(vid, 'manual');

% La cámara funciona a 200 cuadros por segundo.
% Para adquirir a una tasa menor se "ignoran" cuadros;
% por ejemplo si se ignora un cuadro cada dos se obtiene
% una tasa de 100 cuadros por segundo.
vid.FrameGrabInterval = round(velocidad_camara / cuadros_por_segundo);

cuadros_por_segundo_posta = velocidad_camara / vid.FrameGrabInterval;

vid.FramesPerTrigger = cuadros_por_segundo_posta * duracion_video;

start(vid);

disp('todo bien!');
