%%% z_grabar_proceso.m %%%
%
% Comentando y descomentando líneas esta rutina
% permite guardar películas de las distintas
% etapas del procesamiento de imágenes.

total_frames = size(frames);
total_frames = total_frames(4);
results = zeros(total_frames, 6);

x_0 = 0;

logger = VideoWriter('vid', 'Uncompressed AVI');

%logger.FrameRate = 10;
open(logger);

fig = gcf;

for i = 1:total_frames
    frame = frames(:,:,:,i);

    %bw_frame = im2bw(frame, umbral_binarizacion);

    %imshow(bw_frame);
    %text(50, 310, sprintf('Cuadro %d de %d', i, total_frames));

    %[mark_center, mark_radii, mark_metric] = imfindcircles(bw_frame, [7 15], 'Sensitivity', 0.95);
    %[disk_center, disk_radii, disk_metric] = imfindcircles(bw_frame, [8 15], 'ObjectPolarity', 'Dark', 'Sensitivity', 0.95);

    %if ~isempty(disk_center) && ~isempty(mark_center)
    %    viscircles(mark_center, mark_radii, 'EdgeColor', 'b');
    %    viscircles(disk_center, disk_radii);
    %    results(i, :) = [disk_center disk_radii mark_center mark_radii];
    %end

    %text(50, 90, sprintf('X: %6.2f\nY: %6.2f\nR: %6.2f\nx: %6.2f\ny: %6.2f\nr: %6.2f', results(i, :)), 'FontName', 'FixedWidth');

    writeVideo(logger, frame);
    pause(.05);
end

close(logger);
