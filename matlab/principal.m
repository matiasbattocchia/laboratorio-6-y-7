%%% principal.m %%%
%
% Bucle principal de la adquisición de datos. Graba y salva películas.

% Infijo es una palabra que caracteriza a la serie de grabaciones.
% Por ejemplo 'alumino', 'pvc', etcétera.
infijo = 'serie_A';
numeracion = 1;

%% Antes de correr esta rutina por primera vez asegurarse de haber ejecutado en orden:
% configuracion
% inicializacion

%% Acto seguido se recomienda enfocar un disco y correr:
% calibrar_detector
% calibrar_apertura
% calibrar_hough

%% No olvidar guardan una imagen de un elemento de referencia de longitud:
% capturar_regla

%% Rutinas auxiliares:
% cambiar_duracion
% cambiar_roi

%% Subrutinas de esta rutina:
% adquirir_serie
% salvar_serie
% mostrar_hough

%% Después de correr esta rutina ejecutar:
% procesar

%% Rutinas que se usaron para mostrar el funcionamiento
%% del procesamiento (no son requeridas):
% z_graficar_variables
% z_graficar_proceso
% z_grabar_proceso

%%%%

input('presionar alguna tecla para empezar\n', 's');

disp('estamos en un bucle, ctrl+C para salir');
disp('listo!');

while 1
  optical_flow = step(optical, step(detector));

  valor_maximo = max(max(optical_flow));
  pause(.1);

  if( valor_maximo >= umbral_detector )
    disp('duela detectada');

    adquirir

    disp('procesando...');

    % Se puede comentar las dos líneas siguientes para evitar reproducir la
    % grabación antes de decidir guardarla.
    pelicula = implay(frames, cuadros_por_segundo_posta);
    play(pelicula.DataSource.Controls);

    prompt = input('guardar? s/n\n', 's');

    pelicula.close;

    if eq(prompt, 's')
      salvar

      numeracion = numeracion + 1;

      % Se puede comentar la línea siguiente para evitar el control
      % del reconocimiento de círculos.
      mostar_hough
    end

    disp('listo!');
  end
end
