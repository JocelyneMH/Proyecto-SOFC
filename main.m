#Curva de polarización
#Puntos experimentales:
i=[1506.31136,2507.713885,3063.113604,3551.192146,4207.573633,4754.558205,5360.448808,5654.978962]; #A partir de Fig. 5 con WebPlotDgitalizer


T_fuel=1123; %K
T_air=873;

#Composiciones molares
X_h2=(0.89*100/2)/(0.89*100/2+0.11*100/18);
X_h2o=(0.11*100/18)/(0.89*100/2+0.11*100/18);
X_o2=(0.23*100/32)/(0.23*100/32+0.77*100/28);
X=[X_h2,X_h2o,X_o2];

%Supuesto de presion de operacion 1 atm, igual anodo y catodo


#presiones concentracion
P_c=[X_h2*101325,X_h2o*101325,X_o2*101325,101325];

#dimensiones ohmicas
dimensiones=[125e-6,2/1000,40e-6,2.2/1000,94.3]; #m

#Parámetros
r_pore=1e-6; #m
E=0.5;
tau=3;
[Deff_H2,Deff_H2O,Deff_O2]=Deff (r_pore, tau, E, T_fuel,T_air,X,101325);

#Iteración sobre densidades de corriente
U=[];
for j=i
  #Visualización de los sobrepotenciales
  disp(sprintf('Sobrepotencial a %d A/m^2:', j));
  disp('n_{concentracion}:')
  etaconc(j, T_fuel,T_air, P_c,dimensiones,Deff_H2,Deff_H2O,Deff_O2)
  disp('n_{activación}:')
  etaact(j,T_fuel,T_air)
  disp('v_{Ohm}')
  etaohm(j,T_fuel,T_air,dimensiones)

  #Calculo voltaje
  u=reversible(T_fuel,T_air,X)-(etaact(j,T_fuel,T_air)
  +etaohm(j,T_fuel,T_air,dimensiones)
  +etaconc(j, T_fuel,T_air, P_c, dimensiones,Deff_H2,Deff_H2O,Deff_O2));
  U=[U;u];
endfor
#Experimental
U_exp=[0.739937521,0.681251605,0.646860123,0.610479144,0.559957219,0.513496124,0.454942841,0.426675057];

#Gráfico
plot(i,U,'k-o',i,U_exp,'-rs')
xlabel('i (A/m^2)')
ylabel('U(V)')
legend('Modelo', 'Experimental')
title('U_{cell} vs i')
axis([0 6000 0 1]);
grid on

