### velocidades_típicas.jl ###
#
# Grafica las velocidades de series seleccionadas (v_x y v_y en función de y).

include("común.jl")

confinamientos = [240, 40, 15]
concentraciones = [21, 0]

stacks = Any[]

for concentración in concentraciones
  plots = Any[]

  for confinamiento in confinamientos
    lanzamiento = 3

    l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & !isna(ds[:v_x]) & (ds[:v_y] .< 300) & (3 .<= ds[:y] .<= 385),:]

    p = plot(layer(x=l[:t], y=l[:v_y], Geom.path),
      layer(x=l[:t], y=l[:v_x],
      Geom.path,
      Theme(default_color=color("orange"))),
      Scale.y_continuous(minvalue=0, maxvalue=300),
      Guide.ylabel("v [mm/s]"), Guide.xlabel("t [s]"),
      Guide.title("L = $(confinamiento) mm"),
      Guide.manual_color_key("", ["Vy", "Vx"], ["deepskyblue", "orange"]))

    push!(plots, p)
  end

  draw(PDF(string(dir, "velocidades_típicas_glicerol_$(concentración)%.pdf"), 30cm, 10cm), hstack(plots...))
end
