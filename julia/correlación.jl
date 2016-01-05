### correlación.jl ###
#
# Analiza la correlación entre las señales θ y x.

include("común.jl")

stacks = Any[]
correlaciones = DataFrame(confinamiento=[], concentración=[], correlación=[])

plots2 = Gadfly.Plot[]

for confinamiento in confinamientos
  plots = Gadfly.Plot[]

  for concentración in concentraciones
    layers = Array[]
    x = DataArray(Array{Float64,1}())
    y = DataArray(Array{Float64,1}())

    lanzamientos = unique(ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & (3 .<= ds[:y] .<= 390), [:ángulo, :x]]

      x_aux = l[:x]
      x_temp = (x_aux - x_aux[1]) / confinamiento
      append!(x, x_temp)
      y_temp = naapprox(lima(mapa(naapprox(l[:ángulo]))))
      append!(y, y_temp)
      push!(layers, layer(x=x_temp, y=y_temp, Geom.point, Theme(highlight_width = 0pt)))
    end

    push!(correlaciones, [confinamiento, string(concentración, "%"), cor(x,y)])

    p = Gadfly.plot(layers...,
      Scale.x_continuous(minvalue=-0.5, maxvalue=0.5),
      Scale.y_continuous(minvalue=-2, maxvalue=2),
      Guide.xlabel("x"),
      Guide.ylabel("θ"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, p)

    if concentración == 0
      if findfirst([240, 40, 15], confinamiento) != 0
        q = Gadfly.plot(layers...,
          Scale.x_continuous(minvalue=-0.5, maxvalue=0.5),
          Scale.y_continuous(minvalue=-2, maxvalue=2),
          Guide.xlabel("x [mm]"),
          Guide.ylabel("θ [rad]"),
          Guide.title("L = $(confinamiento) mm"))

        push!(plots2, q)
      end
    end
  end

  push!(stacks, hstack(plots...))
end

draw(PDF(string(dir, "correlaciones_típicas_glicerol_0%.pdf"), 30cm, 10cm), hstack(plots2...))

draw(PDF(string(dir, "series_correlación_(adimensional).pdf"), 60cm, 80cm), vstack(stacks...))

p = plot(correlaciones,
  x="confinamiento",
  y="correlación",
  color="concentración",
  Geom.point,
  Geom.line,
  Guide.xlabel("Confinamiento [mm]"),
  Guide.ylabel("Correlación θ-x"),
  Guide.colorkey("Concentración"),
  Stat.xticks(ticks=[0, 40, 60, 120, 240]))

#draw(PNG(string(dir, "correlación.png"), 16cm, 12cm), p)
draw(PDF(string(dir, "correlación.pdf"), 12cm, 9cm), p)
