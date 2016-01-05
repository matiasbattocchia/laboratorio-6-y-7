%%% hough.m %%%
%
% Procesa la película actual. Similar a mostar_hough.m con la
% particularidad de que salva los resultados sin visualizar
% el proceso. Principalmente funciona como subrutina
% de procesar.m.

total_frames = size(frames);
total_frames = total_frames(4);
results = zeros(total_frames, 6);

for i = 1:total_frames
    frame = frames(:,:,:,i);

    % Convertimos la imagen a blanco y negro. El fondo y la marca quedan
    % blancos y la duela, negra.
    bw_frame = im2bw(frame, umbral_binarizacion);

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

    results(i, :) = [disk_center disk_radii mark_center mark_radii];
end
