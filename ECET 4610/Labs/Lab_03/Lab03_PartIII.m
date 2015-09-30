%This program will be called Antenna Azimuth Position Control System
%Date       Programmer                  Description of change
%===        ==========                  =====================
%10-19-08   Tyler Long             

%Input Parameters
Kpot= input('Enter the Potentiometer value for Kpot: '); %Potentiometer
K= input('Enter the Preamplifier value for K: '); %Preamp
K1= input('Enter the Power amplifier value for K1: '); %Power amp
a= input('Enter the Power amplifier value for a: '); %Power amp
Km= input('Enter the Motor and load value for Km: '); %Motor and load
am= input('Enter the Motor and load value for am: '); %Motor and load
Kg= input('Enter the Gears value for Kg: '); %Gears

%Transfer Function
num= Kpot*K*K1*Km*Kg;
den= [1,(am+a),(am*a),(Kpot*K*K1*Km*Kg)];

%Step response
[y,x,t] = step(num,den);
plot(t,y)
xlabel('Time in seconds');
ylabel('Displacement');
title ('Azimuth Antenna - Tyler Long');
grid on;


