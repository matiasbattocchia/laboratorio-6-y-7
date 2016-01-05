%%% salvar_serie.m %%%
%
% Guarda la película actual en el disco. Esta es una subrutina de principal.m.

archivo = strcat(directorio_de_trabajo, date, '_', infijo, '_', sprintf('%03d', numeracion));

disp(archivo);

logger = VideoWriter(archivo, 'Grayscale AVI');

% Ver configurar.m para entender de dónde sale el frame rate.
logger.FrameRate = cuadros_por_segundo_posta;
open(logger);

for i = 1:vid.FramesPerTrigger
  writeVideo(logger, frames(:,:,:,i));
end

close(logger);
