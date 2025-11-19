

function conc = etaconc (i, T_fuel,T_air, P, dimensiones,Deff_H2,Deff_H2O,Deff_O2)
F=96485;
R=8.314;
T=(T_fuel+T_air)/2;

f=F/(R*T);



ph2=P(1);
ph2o=P(2);
po2=P(3);
p_op=P(4);

da=dimensiones(1);
dc=dimensiones(2);
de=dimensiones(3);
D=dimensiones(4);

A=0.804/pi;
B=0.13/pi;
delta_qa=(A*pi*D)^2/(8*da);
delta_qc=(A*pi*D)^2/(8*dc)*A*(A+2*(1-A-B));
delta_qe= de ;


#Cálculo P_ PTB en atm, por las ecuaciones de D_eff


P_H2_TPB  = ph2  - i * ((R*T * da) / (2*F*Deff_H2 ))  / 101325;
P_H2O_TPB = ph2o - i * ((R*T * da) / (2*F*Deff_H2O))  / 101325;
P_O2_TPB  = po2  - i * ((R*T * dc) / (2*F*Deff_O2 ))  / 101325;

nconc_C = (R * T) / (4 * F) * log(po2 / P_O2_TPB);
nconc_A = (R * T) / (2 * F) * log((ph2 * P_H2O_TPB)/ (P_H2_TPB * ph2o));


conc=nconc_A+nconc_C; #anodo +catod


endfunction
