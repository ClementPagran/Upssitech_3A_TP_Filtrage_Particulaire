
plot_p=0;
[N,T,Z,F,Hfull,mX0,PX0,Qw,Rv,X] = simulationDonnees(plot_p);
x=[];
N_nbr=100;
[xk,wk] = SIS(x,N,N_nbr,mX0,PX0,Qw,F,Rv,Hfull);
                                  