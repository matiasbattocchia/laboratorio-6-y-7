### ángulos.jl ###
#
# Grafica las rotaciones para todas las series (θ en función de y).

include("común.jl")

stacks = Any[]

for confinamiento in confinamientos
  plots = Gadfly.Plot[]

  for concentración in concentraciones
    layers = Array[]

    lanzamientos = unique(ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & (3 .<= ds[:y] .<= 390), [:ángulo, :y]]

      push!(layers, layer(x=l[:y], y=naapprox(lima(mapa(naapprox(l[:ángulo])))), Geom.line))
    end

    plot = Gadfly.plot(layers...,
      Scale.x_continuous(minvalue=0, maxvalue=400),
      Scale.y_continuous(minvalue=-3, maxvalue=3),
      Guide.xlabel("y"),
      Guide.ylabel("θ"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, plot)
  end

  push!(stacks, hstack(plots...))
end

draw(PDF(string(dir, "ángulos.pdf"), 60cm, 80cm), vstack(stacks...))
