%%% mostrar_hough.m %%%
%
% Procesa la película actual. Similar a hough.m con la
% particularidad de que visualiza el proceso sin salvar
% los resultados. Principalmente funciona como una
% subrutina de principal.m.

total_frames = size(frames);
total_frames = total_frames(4);
results = zeros(total_frames, 6);

for i = 1:total_frames
    frame = frames(:,:,:,i);

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

    results(i, :) = [disk_center disk_radii mark_center mark_radii];

    text(50, 35, sprintf('ROJO  X: %6.2f  Y: %6.2f  R: %6.2f\nAZUL  x: %6.2f  y: %6.2f  r: %6.2f', results(i, :)), 'FontName', 'FixedWidth');
    text(50, 180, sprintf('Cuadro %d de %d', i, total_frames));

    pause(.01);
end
