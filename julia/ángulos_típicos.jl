### ángulos_típicos.jl ###
#
# Grafica las rotaciones de series seleccionadas (θ en función de y).

include("común.jl")

confinamientos = [240, 40, 15]
concentraciones = [21, 0]

stacks = Any[]

for concentración in concentraciones
  plots = Any[]

  for confinamiento in confinamientos
    lanzamiento = 3

    l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & !isna(ds[:ángulo]) & (3 .<= ds[:y] .<= 390),:]

    plot = plot(y=-1 .* l[:y],
      x=l[:ángulo]-l[:ángulo][1],
      Geom.path,
      Guide.xlabel("θ [rad]"),
      Guide.ylabel("y [mm]"),
      Scale.y_continuous(minvalue=-400, maxvalue=0),
      Scale.x_continuous(minvalue=-2, maxvalue=2),
      Guide.title("L = $(confinamiento) mm"))

    push!(plots, plot)
  end

  draw(PDF(string(dir, "ángulos_típicos_glicerol_$(concentración)%.pdf"), 30cm, 10cm), hstack(plots...))
end
