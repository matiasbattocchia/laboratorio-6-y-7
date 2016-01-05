### x_de_t.jl ###
#
# Grafica los desplazamientos horizontales de todas las series (x en función de t).

include("común.jl")

stacks = Any[]

for confinamiento in confinamientos
  plots = Gadfly.Plot[]

  for concentración in concentraciones
    layers = Array[]

    lanzamientos = unique(ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento), [:x, :t]]

      push!(layers, layer(l, x=:t, y=:x, Geom.line))
    end

    plot = Gadfly.plot(layers...,
      Scale.x_continuous(minvalue=0, maxvalue=4),
      Scale.y_continuous(minvalue=30, maxvalue=100),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, plot)
  end

  push!(stacks, hstack(plots...))
end

draw(PDF(string(dir, "x_de_t.pdf"), 60cm, 80cm), vstack(stacks...))
