

function [Deff_H2,Deff_H2O,Deff_O2] = Deff (r_pore, tau, E, T_fuel,T_air,X,P_total)

F=96485;
R=8.314;

T=(T_fuel+T_air)/2;
f=F/(R*T);

M_H2=2/1000;#kg/mol
M_H2O=18/1000;
M_O2=32/1000;
M_N2 = 28/1000;

X_h2= X(1);
X_h2o= X(2);
X_o2= X(3);

P_H2  = X_h2  * P_total/101325; #en atm
P_H2O = X_h2o * P_total/101325;
P_O2  = X_o2  * P_total/101325;

% Diffusion volumes
v_H2  = 7.07;
v_H2O = 12.7;
v_O2  = 16.6;
v_N2  = 17.9;

% Difusión de Knudsen
DK_H2 = (2/3)*r_pore*sqrt((8*R*T)/(pi*M_H2) );
DK_H2O = (2/3)*r_pore*sqrt((8*R*T)/(pi*M_H2O));
DK_O2  = (2/3)*r_pore*sqrt((8*R*T)/(pi*M_O2));

% DIFUSIÓN BINARIA

D_H2_H2O=(1e-7)*T^1.75*((1/(M_H2*1000) + 1/(M_H2O*1000))^0.5)/((1)* ((v_H2^(1/3) + v_H2O^(1/3))^2));
D_O2_N2 = (1e-7)*T^1.75*((1/(M_O2*1000) + 1/(M_N2*1000))^0.5)/(1*((v_O2^(1/3) + v_N2^(1/3))^2));

#Difusión molecular

Dm_H2 = (1-X_h2)/((X_h2+X_h2o)/D_H2_H2O);
Dm_H2O = (1-X_h2o)/((X_h2+X_h2o)/D_H2_H2O);
Dm_O2 = (1-X_o2)/(X_o2/D_O2_N2);

%Difusiones efectivas

Deff_H2  = ((E/tau) * ((1/Dm_H2 )  + (1/DK_H2 )))^(-1);
Deff_H2O = ((E/tau) * ((1/Dm_H2O)  + (1/DK_H2O)))^(-1);
Deff_O2  = ((E/tau) * ((1/Dm_O2 )  + (1/DK_O2 )))^(-1);


endfunction
