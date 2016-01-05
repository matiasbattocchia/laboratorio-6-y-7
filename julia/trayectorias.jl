### trayectorias.jl ###
#
# Grafica las trayectorias de todas las series (x en función de y).

include("común.jl")

stacks = Any[]

for confinamiento in confinamientos
  plots = Plot[]

  for concentración in concentraciones
    layers = Array[]

    lanzamientos = unique(ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento), :lanzamiento])

    for lanzamiento in lanzamientos
      l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & (3 .<= ds[:y] .<= 390), [:x, :y]]

      push!(layers, layer(x=l[:y], y=l[:x]-l[:x][1], Geom.path))
    end

    p = plot(layers...,
      Geom.hline(color="orange"),
      yintercept=[-confinamiento/2+5.5, confinamiento/2-5.5],
      Guide.xlabel("y"), Guide.ylabel("x"),
      Scale.x_continuous(minvalue=0, maxvalue=400),
      Scale.y_continuous(minvalue=-confinamiento/2, maxvalue=confinamiento/2),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots, p)
  end

  push!(stacks, hstack(plots...))
end

draw(PDF(string(dir, "trayectorias.pdf"), 60cm, 80cm), vstack(stacks...))
