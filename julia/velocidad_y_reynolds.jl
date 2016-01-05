### velocidad_y_reynolds.jl ###
#
# Obtiene mediante regresión lineal del desplazamiento vertical (y de t) las velocidades
# terminales. A partir de estas calcula el número de Reynolds.

include("común.jl")

# Concentración: % en masa
# Densidad: g/cm3
# Valores para 20 ºC
densidades = DataFrame(concentración=[0,1,2,6,7,8,13,14,15,20,21,22,27,28,29],
                     densidad=[0.99823,1.00060,1.00300,1.01255,1.01495,1.01730,
                               1.02955,1.03200,1.03450,1.04690,1.04950,1.05205,
                               1.06495,1.06755,1.07010])

den = Spline1D(densidades[:concentración], densidades[:densidad])

# Concentración: % en masa
# Viscosidad: centipoises (CGS); mPa*s (SI) = g/(m*s)
# Valores para 20 ºC
viscosidades = DataFrame(concentración=[0,10,20,30,40,50,60,65,67,70],
                          viscosidad=[1.005,1.310,1.760,2.500,3.720,
                                      6.000,10.80,15.20,17.70,22.50])

vis = Spline1D(viscosidades[:concentración], viscosidades[:viscosidad])

# Concentraciones reales de glicerol en agua destilada;
# las concentraciones de 7, 14, 21% son muy cercanas a las
# reales, sin embargo son nominales, para simplificar.
# Concentración: % en masa
con = Dict(0  =>   0.0,
           7  =>  57.8 / 800.3 * 100,
           14 => 112.0 / 801.2 * 100,
           21 => 168.0 / 802.2 * 100)

## Reynolds ##
# No se hacen cambio de unidades porque las unidades de ρ y μ se compensan bien.
# Velocidad: mm/s
# Diámetro discos, longitud característica (L): mm
L = 11
re(ρ, v, L, μ) = ρ * v * L / μ

stacks = Any[]
velocidades = DataFrame(confinamiento=[], concentración=[], velocidad=[], error=[], reynolds=[])

for confinamiento in confinamientos
  plots = Gadfly.Plot[]

  for concentración in concentraciones
    layers = Array[]

    velocidad = 0
    error = 0

    lanzamientos = unique(ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & (3 .<= ds[:y] .<= 385), [:t, :y]]

      ajuste = lm(y ~ t, l)

      velocidad += coef(ajuste)[2]
      error += stderr(ajuste)[2]^2

      push!(layers, layer(l, x=:t, y=:y, Geom.line))
    end

    push!(velocidades,
      [confinamiento,
        string(concentración, "%"),
        velocidad/length(lanzamientos),
        sqrt(error/length(lanzamientos)),
        re(den(con[concentración]),
        velocidad/length(lanzamientos),
        L,
        vis(con[concentración]))])

    plot = Gadfly.plot(layers...,
      Scale.x_continuous(minvalue=0, maxvalue=6),
      Scale.y_continuous(minvalue=0, maxvalue=400),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, plot)
  end

  push!(stacks, hstack(plots...))
end


draw(PDF(string(dir, "series_velocidad.pdf"), 60cm, 80cm), vstack(stacks...))

v = velocidades

p = plot(velocidades,
  x="confinamiento",
  y="velocidad",
  color="concentración",
  Geom.point,
  Geom.line,
  Scale.y_continuous(minvalue=50, maxvalue=200),
  Guide.xlabel("Confinamiento [mm]"),
  Guide.ylabel("Velocidad [mm/s]"),
  Guide.colorkey("Concentración"),
  Stat.xticks(ticks=[0, 40, 60, 120, 240]))

#draw(PNG(string(dir, "velocidad.png"), 16cm, 12cm), p)
draw(PDF(string(dir, "velocidad.pdf"), 12cm, 9cm), p)

p = plot(velocidades,
  x="confinamiento",
  y="reynolds",
  color="concentración",
  Geom.point,
  Geom.line,
  Guide.xlabel("Confinamiento [mm]"),
  Guide.ylabel("Reynolds"),
  Guide.colorkey("Concentración"),
  Stat.xticks(ticks=[0, 40, 60, 120, 240]))

#draw(PNG(string(dir, "reynolds.png"), 16cm, 12cm), p)
draw(PDF(string(dir, "reynolds.pdf"), 12cm, 9cm), p)
