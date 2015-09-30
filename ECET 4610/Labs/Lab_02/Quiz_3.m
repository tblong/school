%This program will be called microphone gain
%This program plots the gain of a microphone
%Date       Programmer                  Your major
%===        ==========                  =====================
%9-22-08       Tyler Long                EET

%Input Parameters
g= input('Enter a value for the microphone constant: '); %Mic variable
angle1= input('Enter a starting angle degrees: '); %Angle in degrees
angle2= input('Enter an ending angle degrees: '); %Angle in degrees

rad1=angle1*(pi/180);
rad2=angle2*(pi/180);

if angle1<=angle2
    theta=rad1:.01:rad2;
else
    theta=rad2:.01:rad1;    
end

GAIN=2*g*(1+cos(theta));


polar(theta,GAIN)
title('Microphone Gain - Tyler Long');
grid on;