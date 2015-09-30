%This program will be called average
%This program calculates the average test grade for a course
%Date       Programmer                  Your major
%===        ==========                  =====================
%9-24-08       Tyler Long                EET


%Input Parameters
t1= input('Enter a grade for Test#1: '); %Test 1 grade
t2= input('Enter a grade for Test#2: '); %Test 2 grade
t3= input('Enter a grade for Test#3: '); %Test 3 grade

%Average test grade calculation
avg=(t1+t2+t3)/3;

%Letter grade determination

if avg >= 90
    'Your grade is: A'
elseif avg >= 80
    'Your grade is: B'
elseif avg >= 70
    'Your grade is: C'
elseif avg >= 60
    'Your grade is: D'
else
    'Your grade is: F'
end    
    