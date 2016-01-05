### trayectorias_típicas.jl ###
#
# Grafica las trayectorias de series seleccionadas (x en función de y).

include("común.jl")

confinamientos = [240, 40, 15]
concentraciones = [21, 0]

stacks = Any[]

for concentración in concentraciones
  plots = Any[]

  for confinamiento in confinamientos
    lanzamiento = 3

    l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento) & !isna(ds[:x]) & (3 .<= ds[:y] .<= 390),:]

    p = plot(y=-1 .* l[:y],
      x=l[:x]-l[:x][1],
      Geom.path,
      Geom.vline(color="orange"),
      xintercept=[-confinamiento/2+5.5, confinamiento/2-5.5],
      Guide.xlabel("x [mm]"),
      Guide.ylabel("y [mm]"),
      Scale.y_continuous(minvalue=-400, maxvalue=0),
      Scale.x_continuous(minvalue=-confinamiento/2, maxvalue=confinamiento/2),
      Guide.title("L = $(confinamiento) mm"))

    push!(plots, p)
  end

  draw(PDF(string(dir, "trayectorias_típicas_glicerol_$(concentración)%.pdf"), 30cm, 10cm), hstack(plots...))
end
