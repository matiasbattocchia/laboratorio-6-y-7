### correlación.jl ###
#
# Analiza la correlación entre las señales θ y x.

include("común.jl")

correlaciones = DataFrame(confinamiento=[], concentración=[], correlación=[])

stacks    = Any[]
stacks_x  = Any[]
stacks_dx = Any[]
stacks_a  = Any[]

plots2 = Gadfly.Plot[]

for confinamiento in confinamientos
  plots    = Gadfly.Plot[]
  plots_x  = Gadfly.Plot[]
  plots_dx = Gadfly.Plot[]
  plots_a  = Gadfly.Plot[]

  for concentración in concentraciones
    layers    = Array[]
    layers_x  = Array[]
    layers_dx = Array[]
    layers_a  = Array[]
    x = DataArray(Array{Float64,1}())
    y = DataArray(Array{Float64,1}())

    lanzamientos = unique(dz[(dz[:concentración] .== concentración) & (dz[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = dz[(dz[:concentración] .== concentración) & (dz[:confinamiento] .== confinamiento) & (dz[:lanzamiento] .== lanzamiento), [:x, :y, :ángulo]]

      l[:x] = suave(suave(naapprox(l[:x]), 10), 5)
      l[:y] = naapprox(l[:y])
      l[:ángulo] = suave(suave(naapprox(lima(mapa(naapprox(l[:ángulo])))), 10), 5)

      l = l[(3 .<= l[:y] .<= 387), :]

      x_temp = (l[:x] - l[:x][1]) / (confinamiento - L)
      dx = derivada(x_temp, 5)
      append!(x, dx)
      y_temp = l[:ángulo] - l[:ángulo][1]
      dy = derivada(y_temp, 5)
      append!(y, dy)

      push!(layers_dx, layer(x=l[:y], y=dx, Geom.line))
      push!(layers_x, layer(x=l[:y], y=x_temp, Geom.line))
      push!(layers_a, layer(x=l[:y], y=y_temp, Geom.line))

      push!(layers, layer(x=dx, y=dy, Geom.point, Theme(highlight_width = 0pt)))
    end

    # Dataset análisis correlación
    push!(correlaciones, [confinamiento, string(concentración, "%"), cor(x,y)])

    # Gráfico de la derivada del desplazamiento horizontal
    # en función del desplazamiento vertical.
    c = plot(layers_dx...,
      Guide.xlabel("y"), Guide.ylabel("dx"),
      Scale.x_continuous(minvalue=0, maxvalue=400),
      #Scale.y_continuous(minvalue=-1, maxvalue=1),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots_dx, c)

    # Gráfico desplazamiento horizontal en función del desplazamiento vertical.
    b = plot(layers_x...,
      Geom.hline(color="orange"),
      yintercept=[-.5, .5],
      Guide.xlabel("y"), Guide.ylabel("x"),
      Scale.x_continuous(minvalue=0, maxvalue=400),
      Scale.y_continuous(minvalue=-1, maxvalue=1),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots_x, b)

    # Gráfico ángulo en función del desplazamiento vertical.
    a = Gadfly.plot(layers_a...,
      Scale.x_continuous(minvalue=0, maxvalue=400),
      Scale.y_continuous(minvalue=-3, maxvalue=3),
      Guide.xlabel("y"),
      Guide.ylabel("θ"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots_a, a)

    # Gráfico series correlación
    p = Gadfly.plot(layers...,
      #Scale.x_continuous(minvalue=-0.5, maxvalue=0.5),
      #Scale.y_continuous(minvalue=-2, maxvalue=2),
      Guide.xlabel("dx"),
      Guide.ylabel("dθ"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, p)

    # Gráfico correlaciones típicas.
    if concentración == 0
      if findfirst([240, 40, 15], confinamiento) != 0
        q = Gadfly.plot(layers...,
          #Scale.x_continuous(minvalue=-0.5, maxvalue=0.5),
          #Scale.y_continuous(minvalue=-2, maxvalue=2),
          Guide.xlabel("dx"),
          Guide.ylabel("dθ"),
          Guide.title("L = $(confinamiento) mm"))

        push!(plots2, q)
      end
    end
  end

  push!(stacks, hstack(plots...))
  push!(stacks_dx, hstack(plots_dx...))
  push!(stacks_x, hstack(plots_x...))
  push!(stacks_a, hstack(plots_a...))
end

draw(PDF(string(dir, "z_correlaciones_típicas_glicerol_0%.pdf"), 30cm, 10cm), hstack(plots2...))
draw(PDF(string(dir, "z_series_velocidades.pdf"), 60cm, 80cm), vstack(stacks_dx...))
draw(PDF(string(dir, "z_series_correlación_(adimensional).pdf"), 60cm, 80cm), vstack(stacks...))
draw(PDF(string(dir, "z_series_trayectorias.pdf"), 60cm, 80cm), vstack(stacks_x...))
draw(PDF(string(dir, "z_series_rotaciones.pdf"), 60cm, 80cm), vstack(stacks_a...))

p = plot(correlaciones,
  x="confinamiento",
  y="correlación",
  color="concentración",
  Geom.point,
  Geom.line,
  Guide.xlabel("Confinamiento [mm]"),
  Guide.ylabel("Correlación dθ-dx"),
  Guide.colorkey("Concentración"),
  Stat.xticks(ticks=[0, 40, 60, 120, 240]))

#draw(PNG(string(dir, "z_correlación.png"), 16cm, 12cm), p)
draw(PDF(string(dir, "z_correlación.pdf"), 12cm, 9cm), p)
