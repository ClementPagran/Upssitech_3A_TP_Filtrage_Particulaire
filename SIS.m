function [xk,wk] = simulationDonnees(x,w,z,N,N_nbr,m,P,Qw,F,Rv,HFull);
for k=1:N
    X=array(N,N_nbr)
    W=array(N,N_nbr)
    if k==1
        Z=randn(N,1);
        L=sqrt (chol(P))';
        X(1,:)=m+L*Z;
        W(1,:)=1/N;
    end
    if k>=2
        for i=2:N_nbr
            X(k+1,i)=
            num1=exp((-1/2)*(x(k+1,:) - F(k,:))' / (Qw(k,k)) * (x(k+2,:) - F(k,:)));
            num2=exp((-1/2)*(z(:,k) - HFull(:,k))' / (Rv(k,k)) * (z(:,k) - HFull(:,k)));

        end
    end
end
end

