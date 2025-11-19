
function E = reversible (T_fuel,T_air, X)
  #T= temperatura en Kelvin;
  #X=vector de fracciones molares
#Constantes
  F=96485;
  R=8.314;
  Ho=-241572; #J/mol
  To=298.15;#K
  Uo=1.229; #V
#La temperatura de operación es un promedio entre la de combustible y aire
T=(T_fuel+T_air)/2;


X_h2=X(1);
X_h2o=X(2);
X_o2=X(3);


U=Uo*T/To+Ho/(2*F)*(T/To-1);
E=U-R*T/(2*F)*log((X_h2*X_o2^0.5)/X_h2o);
endfunction
