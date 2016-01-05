%%% adquirir_serie.m %%%
%
% Dispara la adquisición. Esta es una subrutina de principal.m.

trigger(vid);
wait(vid);
clear('frames');
frames = getdata(vid);
start(vid);
