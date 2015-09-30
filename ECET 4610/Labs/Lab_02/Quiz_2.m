function trajectory = Quiz_2(x0,v0,t,t1)
%This program will be called Trajectory
%It is function that calculates the distance and plots the distance
%Date       Programmer                 Description of change
%===        ==========                  =====================
%9-22-08       Tyler Long               Murphy

%Parameters

x=x0+v0*t+.5*-9.8*t.^2;

%create plots

plot(t,x);
title('Trajectory of Ball - Tyler Long');
xlabel('Time [sec]');
ylabel('Height [m]');
grid on;

x1=x0+v0*t1+.5*-9.8*t1.^2;

['The height at time ' num2str(t1) ' seconds is ' num2str(x1) ' meters.']
