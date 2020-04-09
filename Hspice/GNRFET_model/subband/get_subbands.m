% This function computes the subbands of a GNR
% also computes some stuff for the charge..

% inputs
% N should be preset in define_design.m

% constants
t = 2.7; % in eV   (tight binding hopping parameter)
a = sqrt(3)*1.42e-10; % in meters
d = 0.12; % For the correction factor
% The rest are defined in define_const.m
define_const;
% h = 4.13567e-15 ; % in ev*s
% Kb =8.6173e-5; % eV/K 
% T = 300; % in K
% B = 1/(Kb*T); % represents beta in 1/ev
% Pi = 3.14159265; 
% h_bar = h/(2*Pi); 
% q = 1.6e-19;

% Calculations Begin
alpha = 1:N; 

A = cos(alpha*Pi/(N+1)); % A sub alphas

correction = 4*d*t/(N+1) * (sin(alpha*Pi/(N+1))).^2;

E_zero1 = t * (1+2*A);  
E_zero = abs(E_zero1); 

for i=1:N 
   if(A(i) < -0.5)
	E_final1(i) = E_zero(i) - correction(i); 
   else
	E_final1(i) = E_zero(i) + correction(i); 
   end;
end;  

E_final = sort(E_final1); 

% Finding the old index for first n_sbbd subbands

sbbd = zeros(1,n_sbbd);
mass = zeros(1,n_sbbd);
for s=1:n_sbbd
    n = 0;
    sbbd(s) = E_final(s);
    
    for i = 1:N
        if(E_final1(i) == sbbd(s))
            n = i;
        end
    end
    mass(s) = abs(2/3*h_bar^2 * sbbd(s) /(a^2*t^2*A(n)))/6.24e18; % in kg
end

clear t a d;
clear A E_final E_final1 E_zero E_zero1 alpha correction i n;
