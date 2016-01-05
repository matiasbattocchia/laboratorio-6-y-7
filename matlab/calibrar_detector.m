%%% calibrar_detector.m %%%
%
% Ayuda a escoger el parámetro umbral_detector
% (ver configurar.m).

while 1
  pause(.2);
  a = step(optical, step(vid));
  b = max(max(a));

  if( b > 0.01 )
      b
  end
end
