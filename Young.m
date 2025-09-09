% Carga de la imagen
A = imread('D140.jpeg');

% Imagen a escala de grises
if size(A, 3) == 3
    A_gray = rgb2gray(A);
else
    A_gray = A;
end

% Muestra la imagen para la calibracion
figure(1);
imshow(A_gray);
title('Clic en marca inicial y en la marca a 10mm');

% Seleccion de dos puntos en la graduacion
disp('Clic en marca inicial y en la marca a 10mm');
[x_cal, y_cal] = ginput(2);

% Calcula la distancia en pixeles entre los dos puntos
distancia_pixeles = sqrt((x_cal(2) - x_cal(1))^2 + (y_cal(2) - y_cal(1))^2);

% Factor de conversión (píxeles por milímetro)
% 10 mm equivalen a la distancia_pixeles
factor_conversion = 10 / distancia_pixeles; % mm/píxel

% Trace la linea del perfil de intensidad sobre el patron
figure(1);
title('Trace la linea para el perfil de intensidad.');
disp('Trace la linea para el perfil de intensidad sobre el patrón de interferencia.');
[x_line, y_line, P] = improfile;

% Convierte la distancia en pixeles del perfil a milimetros
distancia_mm = 0:factor_conversion:((length(P)-1) * factor_conversion);

% Asegurate de que los vectores tengan el mismo tamaño
if length(distancia_mm) > length(P)
    distancia_mm = distancia_mm(1:length(P));
elseif length(P) > length(distancia_mm)
    P = P(1:length(distancia_mm));
end

% Grafica el perfil de intensidad
figure(2);
plot(distancia_mm, P);
xlabel('Distancia (mm)');
ylabel('Intensidad de Píxel');
title('Perfil de Intensidad vs. Distancia en mm');
grid on;

% Encuentra los picos (maximos) en el perfil de intensidad
% 'P' es el vector de intensidades
% El segundo argumento (opcional) 'MinPeakDistance' se puede usar para
% discriminar picos cercanos, en este caso, se establece una distancia minima
% de 50 pixeles como ejemplo. Ajustar segun el patron de interferencia.
[pks, locs] = findpeaks(P, 'MinPeakDistance', 35);

% Convierte la ubicacion de los picos de indices de vector a distancia en mm
ubicacion_picos_mm = (locs - 1) * factor_conversion;

% Muestra los resultados
disp(' ');
disp('Ubicaciones de los maximos (picos) en el patron de interferencia:');
for i = 1:length(pks)
    fprintf('Maximo #%d: Intensidad = %.2f, Ubicacion = %.4f mm\n', i, pks(i), ubicacion_picos_mm(i));
end
