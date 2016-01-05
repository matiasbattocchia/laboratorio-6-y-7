%%% z_graficar_variables.m %%%
%
% Carga una serie procesada y grafica trayectoria, rotación y velocidad
% de la partícula.

results = csvread(strcat(directorio_de_trabajo, regexprep(archivo.name, '.avi', '.csv')));

ang = atan((results(:,5)-results(:,2))./(results(:,4)-results(:,1)));

arr = vertcat(zeros(1,2), results(:,1:2));
arr = arr(1:size(results,1),:);
arr = (results(:,1:2) - arr) / 50;
arr(1,:) = [NaN NaN];
arr = sqrt(arr(:,1).^2+arr(:,2).^2);

f = figure('visible','off');

subplot(3,1,1)
plot(results(:,1),results(:,2)-100,'Color','red')
title('Trayectoria')
ylabel('y [px]')

subplot(3,1,2)
plot(results(:,1),ang,'Color','blue')
title('Rotacion')
ylabel('a [rad]')

subplot(3,1,3)
plot(results(:,1),arr,'Color','green')
title('Velocidad')
xlabel('x [px]')
ylabel('v [px/seg]')

saveas(f, strcat(directorio_de_trabajo, regexprep(archivo.name, '.avi', '.png')));
