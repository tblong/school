%Function freqresp = resp(R,C,f)
%This program will be called program no 2.
%It is function that plots the amplitude and phase response of a low-pass
%RC filter
%date       programmer                 description of change
%===        ==========                  =====================
%9-15-08       Tyler Long               Murphy
%ampl       amplitude response
C= input('Enter a value for the capacitance : '); %Capacitance in Farads
R= input('Enter a value for the resistance : '); %Resistance in Ohms
% phase phase response
% gain      Vo/Vi=1/(1+j2pifRC).
f= input('Enter the range of values for the frequency: '); %Frequency range
gain=1./(1+j*2*pi*f*R*C);
ampl = abs(gain);
phase=angle(gain);
%create plots
subplot(3,1,1);
loglog(f,ampl);
title('Amplitude response - Tyler Long');
xlabel('Frequency in [Hz]');
ylabel('Vo/Vi Ratio');
grid on;
subplot(3,1,3);
semilogx(f,phase);
title('Phase response - Tyler Long');
xlabel('Frequency in [Hz]');
ylabel('out-inp phase in [rad]'); grid on;