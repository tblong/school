%This program will be called Mechanical Response
%Date       Programmer                  Description of change
%===        ==========                  =====================
%10-12-08   Tyler Long             

%Input Parameters
M= input('Enter a value for mass in Kg: '); %Mass of object
K= input('Enter a value for the spring constant in N/m: '); %Spring Constant
D= input('Enter a value for the damping coefficient in N-s/m: '); %Damping coefficient

if D >= 0  % Generates error on negative values for D
    
A= input('Enter a value for the step input: '); %Step input

%Numerator
numg=A/M;

%Denominator
deng1=[1,D/M,K/M];

%Step response
[y1,x1,t1]=step(numg,deng1);

%Peak time calculation
index=find(y1==max(y1));
Tp=t1(index(1));
['Peak time Tp = ' num2str(Tp) ' seconds']

%Percent overshoot calculations
cmax=max(y1);
cfinal=A/K;
POS=((cmax-cfinal)/cfinal)*100;
['Percent overshoot %OS = ' num2str(POS) ' percent']

%Zeta calculation
if D > 0
zeta=(-log(POS/100))/(sqrt(pi^2+(log(POS/100))^2));
['Zeta = ' num2str(zeta)]
else
    zeta = 0;  %True when D<=0
end

%Settling time calculation
if D > 0 
    
    Ts=(4*sqrt(1-zeta^2)*Tp)/(pi*zeta);
    ['Settling time Ts = ' num2str(Ts) ' seconds']
else
    ['Settling time Ts = infinity; System is undamped'] %True when D<=0
end

%Natural frequency calculation
if D > 0
    Wn=4/(Ts*zeta);
    ['Natural frequency Wn = ' num2str(Wn)]
else
    Wn=sqrt(K/M);
    ['Natural frequency Wn = ' num2str(Wn)]
end

%Rise time calculation
if D > 0
y2=y1(1:index);  %Limits the array to the peak time numbers
t2=t1(1:index);  %Limits the array to the peak time numbers

Tmax=interp1(y2,t2,0.9*(A/K));
Tmin=interp1(y2,t2,0.1*(A/K));
Tr=(Tmax-Tmin);
    ['Rise time Tr = ' num2str(Tr) ' seconds']
else 
    ['Rise time Tr = NaN; System is undamped']
end

%Maximum displacement and time
y1max=max(y1);
['Maximum displacement y1 = ' num2str(y1max) ' meters']
['Time during maximum displacement Tp = ' num2str(Tp) ' seconds']

%Displacement at t=5 sec.
Y5=interp1(t1,y1,5);
['The displacement at t=5 seconds is Y5 = ' num2str(Y5) ' meters']

%Plot
plot(t1,y1)
xlabel('Time in Seconds')
ylabel('y1,displacement')

else
    ['Error: Non-negative value for D Required']
end

%Part III
num=318;
den=[1 1.71 318];
G=tf(num,den);
figure(2);
step(G);

omegan=sqrt(318);
['Natural frequency for Part III Wn = ' num2str(omegan)]

zetaIII=1.71/636;
['Zeta for Part III = ' num2str(zetaIII)]

TsIII=4/(omegan*zetaIII);
['Settling time for Part III Ts = ' num2str(TsIII) ' seconds']

TpIII=pi/(omegan*sqrt(1-zetaIII^2));
['Peak time for Part III Tp = ' num2str(TpIII) ' seconds']

POSIII=exp(-(zetaIII*pi)/(sqrt(1-zetaIII^2)))*100;
['Percent overshoot for Part III %OS = ' num2str(POSIII) ' percent']

TrIII=((2.230*zetaIII^2)-(.078*zetaIII)+1.12)/omegan;
['Rise time for Part III Tr = ' num2str(TrIII) ' seconds']