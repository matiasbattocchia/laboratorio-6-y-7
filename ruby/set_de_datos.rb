### set_de_datos.rb ###
#
# Unifica los archivos generados por MATLAB en uno solo.
# Cambia las unidades en píxeles a unidades físicas.

require 'csv'

dir = '../../resultados/'
archivos = Dir[dir + '*.csv']

# origen: Y | X | R | y | x | r
# objetivo: fecha | concentración | brecha | lanzamiento | t | x | y | ángulo | v_x | v_y

meses = {'Sep' => '09', 'Jun' => '06'}

encabezado = ['fecha', 'concentración [% en masa]', 'brecha [mm]', 'lanzamiento',
              't [s]', 'x', 'y', 'ángulo [rad]', 'v_x', 'v_y']

nombre_del_archivo_regep = /([^\/]*)\.csv/
desgloce_del_nombre_regep = /(\d{2})-(\w{3})-(\d{4})(?:_g(\d{1,2}))?_(?:(\d{2,3})mm|(\d{2})cm|sin)_0{1,2}(\d{1,2})/

# Grupos de desgloce_del_nombre_regep
# $1  Día
# $2  Mes
# $3  Año
# $4  Concentración
#     Si $4 == nil entonces concentración glicerol igual a 0% (agua)
#     -> Escalas
#     Agua 631 px = 400 mm
#     Glicerol 626 px = 390 mm
# $5  Brecha en mm -> 100 FPS
# $6  Brecha en cm ->  50 FPS
#     Si $5 o $6 == nil entonces brecha igual a 240 mm ("sin")
#     -> 50 FPS para agua, 100 FPS para el resto
# $7  Número de lanzamiento

def parsear número
  if número == 'NaN'
    Float::NAN
  else
    número.to_f
  end
end

total = archivos.length

CSV.open(dir + 'resultados.csv', 'wb') do |csv|

  csv << encabezado

  archivos.each_with_index do |archivo, i|
    nombre = nombre_del_archivo_regep.match(archivo).to_s

    puts "(#{i}/#{total}) #{nombre}"

    d = desgloce_del_nombre_regep.match(nombre)

    desgloce = ["#{d[3]}-#{meses[d[2]]}-#{d[1]}", # Fecha
                (d[4] or 0), # Concentración
                (d[5] or (d[6] and (d[6].to_i * 10)) or 240), # Brecha
                d[7]] # Lanzamiento

    # Cuadros por segundo
    fps = if d[5] # Series mm
            100
          elsif d[6] # Series cm
            50
          else # Series 'sin'
            if d[4] # Glicerol
              100
            else # Agua
              50
            end
          end

    # Escala
    escala = if d[4] # Glicerol
               390.fdiv 626
             else # Agua
               400.fdiv 631
             end

    x_anterior = 0
    y_anterior = 0

    CSV.foreach(archivo).each_with_index do |fila, i|
      # Columnas fila
      # 0  Y Disco negro
      # 1  X
      # 2  R
      # 3  y Disco blanco
      # 4  x
      # 5  r

      x = parsear(fila[1]) * escala
      y = parsear(fila[0]) * escala
      x_mueca = parsear(fila[4]) * escala
      y_mueca = parsear(fila[3]) * escala

      csv << desgloce + [i.fdiv(fps), # t
                         x, y, # x, y
                         Math::atan2(y_mueca - y, x_mueca - x), # ángulo
                         (x - x_anterior) * fps, (y - y_anterior) * fps] # v_x, v_y

      x_anterior = x
      y_anterior = y
    end
  end
end
