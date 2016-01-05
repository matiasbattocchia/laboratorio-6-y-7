### fourier.jl ###
#
# Analiza las componentes en frecuencia del desplazamiento horizontal (x de t).

include("común.jl")

stacks = Any[]
stacks2 = Any[]

arreglo = collect(0:1/20:5)
frecuencias = DataFrame(confinamiento=[], concentración=[], frecuencia=[], amplitud=[])

plots3 = Gadfly.Plot[]

for confinamiento in confinamientos
  plots = Gadfly.Plot[]
  plots2 = Gadfly.Plot[]

  for concentración in concentraciones
    layers = Array[]

    lanzamientos = unique(dz[(dz[:concentración] .== concentración) & (dz[:confinamiento] .== confinamiento), :lanzamiento])

    if confinamiento >= 40 && concentración == 0
      fs = 50
    else
      fs = 100
    end

    acumulador = zeros(length(arreglo))

    for lanzamiento in lanzamientos
      l = dz[(dz[:concentración] .== concentración) & (dz[:confinamiento] .== confinamiento) & (dz[:lanzamiento] .== lanzamiento), [:x, :y, :t]]

      l[:x] = suave(suave(naapprox(l[:x]), 10), 5)
      l[:y] = naapprox(l[:y])

      l = l[(3 .<= l[:y] .<= 387), :]
      N = length(l[:t])

      fourier = abs(fft((l[:x] - l[:x][1]) / (confinamiento - L))[1:N/2+1])/N
      fourier[2:end-1] = 2*fourier[2:end-1]

      #freq = 0:Fs/length(x):Fs/2
      F = 0:fs/N:5
      fourier = fourier[1:length(F)]

      spline = Spline1D(F, fourier)
      acumulador += spline(arreglo)

      push!(layers, layer(x=F, y=fourier[1:length(F)], Geom.line))
    end

    acumulador /= length(lanzamientos)
    spline = Spline1D(arreglo, acumulador)
    o = optimize(x->-spline(x), 0.1, 3.0)

    push!(frecuencias, [confinamiento, string(concentración, "%"), o.minimum, -o.f_minimum])

    plot = Gadfly.plot(layers...,
      Scale.x_continuous(minvalue=0, maxvalue=5),
      Scale.y_continuous(minvalue=0, maxvalue=.25),
      #= Guide.xticks(ticks=[0,1,2,3,4,5]), =#
      Guide.xlabel("Frecuencia [Hz]"),
      Guide.ylabel("Amplitud"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))
    push!(plots, plot)

    plot2 = Gadfly.plot(x=arreglo, y=acumulador,
      Geom.line,
      Geom.vline(color="orange"),
      xintercept=[o.minimum],
      Scale.x_continuous(minvalue=0, maxvalue=5),
      Scale.y_continuous(minvalue=0, maxvalue=.25),
      #= Guide.xticks(ticks=[0,1,2,3,4,5]), =#
      Guide.xlabel("Frecuencia [Hz]"),
      Guide.ylabel("Amplitud"),
      Guide.title("Confinamiento $(confinamiento) mm - Glicerol $(concentración)%"))

    push!(plots2, plot2)

    if concentración == 0
      if findfirst([240, 40, 15], confinamiento) != 0
        q = Gadfly.plot(x=arreglo, y=acumulador,
          Geom.line,
          Geom.vline(color="orange"),
          xintercept=[o.minimum],
          Scale.x_continuous(minvalue=0, maxvalue=5),
          Scale.y_continuous(minvalue=0, maxvalue=.25),
          #= Guide.xticks(ticks=[0,1,2,3,4,5]), =#
          Guide.xlabel("Frecuencia [Hz]"),
          Guide.ylabel("Amplitud"),
          Guide.title("L = $(confinamiento) mm"))

        push!(plots3, q)
      end
    end
  end

  push!(stacks, hstack(plots...))
  push!(stacks2, hstack(plots2...))
end

draw(PDF(string(dir, "fourier_típicos_glicerol_0%.pdf"), 30cm, 10cm), hstack(plots3...))

draw(PDF(string(dir, "series_fourier_(adimensional).pdf"), 60cm, 80cm), vstack(stacks...))

draw(PDF(string(dir, "series_fourier_promediado_(adimensional).pdf"), 60cm, 80cm), vstack(stacks2...))

p = plot(frecuencias,
  x="confinamiento",
  y="frecuencia",
  color="concentración",
  Geom.point,
  Geom.line,
  Guide.xlabel("Confinamiento [mm]"),
  Guide.ylabel("Frecuencia [Hz]"),
  Guide.colorkey("Concentración"),
  Stat.xticks(ticks=[0, 40, 60, 120, 240]))

draw(PDF(string(dir, "fourier.pdf"), 12cm, 9cm), p)
#draw(PNG(string(dir, "fourier.png"), 16cm, 12cm), p)
