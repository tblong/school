%This is a program that calculates the roots of a quadratic equation.
%      Date         Programmer          description of change
%   =========       ============        ======================
%   9-15-08         Tyler Long          original code
a=input('enter the value of a = ');
b=input('enter the value of b = ');
c=input('enter the value of c = ');
x1=(-b+sqrt(b^2-4*a*c))/2*a;
x2=(-b-sqrt(b^2-4*a*c))/2*a;
if (b^2-4*a*c)<0
    str=['This equation has two complex roots x1=' num2str(x1)  '  and x2=' num2str(x2)]
elseif (b^2-4*a*c)==0
    str=['This equation has two identical roots x1=' num2str(x1)  '  and x2=' num2str(x2)]
else
    str=['This equation has two distinct real roots x1=' num2str(x1)  '  and x2=' num2str(x2)]
end