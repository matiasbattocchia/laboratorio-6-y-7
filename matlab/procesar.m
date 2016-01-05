%%% procesar.m %%%
%
% Bucle principal del procesamiento de datos. Carga y analiza películas;
% salva los datos.

% Infijo es una palabra que caracteriza a la serie de grabaciones.
% Por ejemplo 'alumino', 'pvc', etcétera.
infijo = 'serie_A';
numeracion = 1;

%% Antes de correr esta rutina por primera vez asegurarse de haber ejecutado:
% configuracion

archivos = dir(strcat(directorio_de_trabajo, '*', infijo, '.avi'));

% 'parfor' es un 'for' que seca provecho de los procesadores con
% múltiples núcleos.
parfor j = 1:length(archivos)
    archivo = archivos(j);
    disp(strcat(directorio_de_trabajo, archivo.name));

    % Cargar video.
    video = VideoReader(strcat(directorio_de_trabajo, archivo.name));
    frames = read(video);

    % Analizar video.
    hough

    % Salvar datos.
    csvwrite(strcat(directorio_de_trabajo, regexprep(archivo.name, '.avi', '.csv')), results);
end
