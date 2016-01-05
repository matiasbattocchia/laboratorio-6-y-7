### común.jl ###
#
# Instrucciones comunes para el resto de las rutinas de graficación y análisis.

using Gadfly
using DataFrames
using GLM
using Dierckx
using Optim

dir = "../../gráficos/"

dz = readtable("../../resultados/resultados.csv", nastrings = ["NaN"])

names!(dz, [:fecha, :concentración, :confinamiento, :lanzamiento, :t, :x, :y, :ángulo, :v_x, :v_y])

ds = dz[!isna(dz[:x]),:]

confinamientos = [240, 120, 60, 40, 25, 20, 15] #, 11]
concentraciones = [0, 7, 14, 21]

# Diámetro discos [mm]
L = 11

## Para motivos de prueba.
#
#confinamiento = 60
#concentración = 7
#lanzamiento = 3
#
#l = ds[(ds[:concentración] .== concentración) & (ds[:confinamiento] .== confinamiento) & (ds[:lanzamiento] .== lanzamiento),:]

function derivada(da, v)
  wa = Array{Float64}(length(da))

  l = length(da)

  for i = 1:l
    m = if i <= v
      i - 1
    else
      v
    end

    wa[i] = da[i] - da[i-m]
  end

  wa / v
end

function suave(da, v)
  wa = Array{Float64}(length(da))

  l = length(da)

  for i = 1:l
    m = if i <= v
      i - 1
    else
      v
    end

    p = if i >= l - v
      l - i
    else
      v
    end

    wa[i] = mean(sub(da, i-m:i+p))
  end

  wa
end

function naapprox(da::AbstractDataArray)
  wa = Array{Float64}(length(da))

  i = 1

  while isna(da[i])
    i += 1
  end

  for j = 1:i-1
    wa[j] = da[i]
  end

  o = length(da)

  while isna(da[o])
    o -= 1
  end

  for j = o+1:length(da)
    wa[j] = da[o]
  end

  left = 0

  for j in i:o
    if isna(da[j])
      if left == 0
        left = j - 1
      end
    else
      wa[j] = da[j]

      if left != 0
        g = (da[j] - da[left])/(j - left)

        for k in left+1:j-1
          wa[k] = da[left] + g * (k-left)
        end

        left = 0
      end
    end
  end

  wa
end

function mapa(wa)
  da = Array{Float64}(length(wa))

  for i = 1:length(da)
    da[i] = wa[i] - wa[1]

    if da[i] > pi
      da[i] -= 2*pi
    elseif da[i] < -pi
      da[i] += 2*pi
    end
  end

  da
end

function lima(wa)
  da = DataArray{Float64}(zeros(length(wa)))

  último = wa[1]

  for i = 2:length(da)
    if abs(wa[i] - último) > .5
      da[i] = NA
    else
      da[i] = último = wa[i]
    end
  end

  da
end

#====

function suma(a, b)
  diff = abs(length(a) - length(b))

  c = if length(a) < length(b) a else b end

  append!(c, zeros(diff))

  a + b
end

function máximos(x, y, x_min, x_max)
  pares = []

  for i = 2:length(x)-1
    if x_min <= x[i] <= x_max
      if y[i-1] < y[i] > y[i+1]

        push!(pares, (x[i], y[i]))
      end
    end
  end

  pares
end

function isin(array, elements)
  function f(array_item)
    for element in elements
      if element == array_item
        return true
      end
    end

    return false
  end

  map(f, array)
end

====#
