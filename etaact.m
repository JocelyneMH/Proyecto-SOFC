function nact = etaact (i,T_fuel,T_air)

F=96485;
R=8.314;
T=(T_fuel+T_air)/2;

f=F/(R*T);


#anodo
i0=5300;
nact_A=(1/(f) )*(asinh(i/i0));

#catodo
i0=2000;
nact_C=(1/(f) )*(asinh(i/i0));

nact=nact_A+nact_C; #anodo +catodo
endfunction
