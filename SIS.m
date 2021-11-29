function [X,W] = SIS(x,N,N_nbr,m,P,Qw,F,Rv,HFull);
    X=zeros(size(x));
    W=zeros(1,N_nbr);
for k=0:size(x,2)
    if k==0
        y=randn(6,N);
        L=(chol(P))';
        for j=1:N
            X(:,j)=m + L * y(:,j);
        end
        W(1,:)=1/N;
    end
    if k>=1
        for i=2:N_nbr
            X(:,1)= Qw * randn(size(x,1),1) + F * x(:,1); %il faut rajouter le temps
            pxkxkm1=exp((-1/2)*(X(:,i) - F*x(k,:))' / (Qw(k,k)) * (X(:,i) - F*x(:,i)));
            pzkxk=exp((-1/2)*(z(:,i) - HFull*X(:,i))' / (Rv * (z(:,i) - HFull*X(:,i))));
            pxkxkm1zk= L * randn(size(x,1),1) + F *X(:,1);
            W(1,i+1)=W(1,i)+(pxkxkm1*pzkxk)/pxkxkm1zk;
        end
    sumPoids=sum(W(1,:));
    W(:,k) = W(:,k)/sumPoids;
    end
end
end

