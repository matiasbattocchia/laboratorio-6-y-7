%%% z_graficar_proceso.m %%%
%
% Grafica las tres etapas del procesamiento de imágenes:
%   imagen cruda
%   filtro de binarizado
%   reconocimento de círculos

frames=read(VideoReader(strcat(directorio_de_trabajo, '15-Jun-2015_04cm_008.avi')));

total_frames = size(frames);
total_frames = total_frames(4);
results = zeros(total_frames, 6);

i = 90;
f = figure

frame = frames(:,:,:,i);
subplot(3,1,1)

imshow(frame);

title('Imagen cruda')
bw_frame = im2bw(frame, umbral_binarizacion);

subplot(3,1,2)
imshow(bw_frame);
title('Binarizado')

[mark_center, mark_radii, mark_metric] = imfindcircles(bw_frame, [8 15], 'Sensitivity', 0.95);
[disk_center, disk_radii, disk_metric] = imfindcircles(bw_frame, [8 15], 'ObjectPolarity', 'Dark', 'Sensitivity', 0.95);

subplot(3,1,3)
imshow(bw_frame);
viscircles(mark_center, mark_radii, 'EdgeColor', 'b');
viscircles(disk_center, disk_radii);

%results(i, :) = [disk_center disk_radii mark_center mark_radii];

%text(50, 35, sprintf('ROJO  X: %6.2f  Y: %6.2f  R: %6.2f\nAZUL  x: %6.2f  y: %6.2f  r: %6.2f', results(i, :)));
%text(50, 180, sprintf('Cuadro %d de %d', i, total_frames));

title('Transformada de Hough Circular')

xlabel('x')
ylabel('y')

saveas(f, strcat(directorio_de_trabajo, 'proceso.svg'));
