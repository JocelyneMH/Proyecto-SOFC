
function ohm = etaohm (i,T_fuel,T_air,dimensiones)
#T (K)
#dimensiones (m)=[anodo, catodo,electrolito,diametro, area]=[2/1000m,125e-6,40e-6,2.2/1000,94.3]

da=dimensiones(1);
dc=dimensiones(2);
de=dimensiones(3);
D=dimensiones(4);
a=dimensiones(5);

A=0.804/pi;
B=0.13/pi;
T=(T_fuel+T_air)/2;


#anodo
delta_qa=(A*pi*D)^2/(8*da);
rho_qa=1/(1.117e7*exp(1392/T));

#catodo
delta_qc=(A*pi*D)^2/(8*dc)*A*(A+2*(1-A-B));
rho_qc=1/(1.232e4*exp(-600/T));

#electrolito
rho_qe=1/(3.401e4*exp(-10350/T));
delta_qe= de ;

ohm_a=i*rho_qa*delta_qa;
ohm_c=i*rho_qc*delta_qc;
ohm_e=i*rho_qe*delta_qe;

ohm=ohm_a+ohm_c+ohm_e;

endfunction
