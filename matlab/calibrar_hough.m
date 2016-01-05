%%% calibrar_hough.m %%%
%
% Muestra los resultados de la Transformada de Hough
% en base a los parámetros configurados y las condiciones
% experimentales (iluminación, foco, apertura).
%
% Sirve de ayuda para encontrar una sensitividad adecuada
% para imfindcircles() y/o un umbral_binarizacion conveniente.

frame = getsnapshot(vid);

% Convertimos la imagen a blanco y negro. El fondo y la marca quedan
% blancos y la duela, negra.
bw_frame = im2bw(frame, umbral_binarizacion);

imshow(bw_frame);

% Ángulo: disco blanco.
[mark_center, mark_radii, mark_metric] = imfindcircles(bw_frame, [8 15], 'Sensitivity', 0.95);

% Trayectoria: disco negro.
% imfindcircles encuentra partículas blancas sobre
% fondo negro; usamos la opción 'ObjectPolarity' para invertir esta
% mecánica.
[disk_center, disk_radii, disk_metric] = imfindcircles(bw_frame, [8 15], 'ObjectPolarity', 'Dark', 'Sensitivity', 0.95);

if numel(disk_center) ~= 2
  disk_center = [NaN NaN];
  disk_radii = NaN;
end

if numel(mark_center) ~= 2
  mark_center = [NaN NaN];
  mark_radii = NaN;
end

viscircles(mark_center, mark_radii, 'EdgeColor', 'b');
viscircles(disk_center, disk_radii);
