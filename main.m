clear all;
close all;
clc;

%donnees
choix_algo = 1; %SIR=0, SIS=1
plot_p = 0; %0 to not disp anything, 1 to disp the simulation
Nb_part = 100; %Number of particules
Samp_Trsh = 0.3*Nb_part; %Resampling treshold for SIE
Show_part = 0; %

[N,T,Z,F,Hfull,mX0,PX0,Qw,Rv,Xreel] = simulationDonnees(plot_p);
X = nan(6,Nb_part,N);
W = nan(1,Nb_part,N);

if choix_algo == 0 %SIR
%     %k=0 :
%     [x,w] = SIR(nan(6,Nb_part),nan(1,Nb_part),[],0,1); %[] : mesure vide, 0 : k, 1 : pas resamp. 
%     X(:,:,1) = x;
%     W(:,:,1) = w;
%     %k>0 :
%     for k = 1:N-1
%         [x,w] = SIR(X(:,:,k),W(:,:,k),Z(:,k),k,Samp_Trsh); %x : (6,Nb_part) w : (1,Nb_part)
%         X(:,:,k+1)=x;
%         W(:,:,k+1)=w;
%     end
    
else %SIS
    %k=0 :
    [x,w] = SISb(nan(6,Nb_part),nan(1,Nb_part),[],0); %[] : mesure vide, 0 : k 
    X(:,:,1) = x;
    W(:,:,1) = w;

    %k>0 :
    for k = 1:N-1
        [x,w] = SISb(X(:,:,k),W(:,:,k),Z(:,k),k); %x : (6,Nb_part) w : (1,Nb_part)
        X(:,:,k+1)=x;
        W(:,:,k+1)=w;
    end
    
end

%Moment estimation
Ex = zeros(6,N); %esperance etat
for k=1:N
    for i = 1:Nb_part
        Ex(:,k) = Ex(:,k)+X(:,i,k)*W(1,i,k);
    end
end

Px = zeros(6,6,N); %covariance etat
for k = 1:N
    for i = 1:Nb_part
        Px(:,:,k) = Px(:,:,k)+((X(:,i,k)-Ex(:,k))*(X(:,i,k)-Ex(:,k))')*W(1,i,k);
    end
end


%affichage des courbes
figure(1)

T = size(Xreel);
T = T(2);
for a = 1:6
    subplot(8,1,a);
    plot(1:T,Xreel(a,:),'b',1:T,Ex(a,:)+3*(reshape(Px(a,a,:),[1,T]).^(0.5)),'r',1:T,Ex(a,:)-3*(reshape(Px(a,a,:),[1,T]).^(0.5)),'r');
    hold on
end
weff = nan(1,T);
for t = 1:T
    weff(1,t) = 1/sum(W(:,:,t).^2);
end
subplot(8,1,7);
plot(1:T,weff);
hold on
subplot(8,1,8);
plot(1:T,weff);
set(gca, 'YScale', 'log')


%affichage de l'éllipse
figure(2)

T = size(Xreel);
T = T(2);
NNb_part = size(X);
NNb_part = NNb_part(2);
for k = 1:T
    axis([-3 6 -3 6])
    for l = 1:3
       MatricePestk = Px(:,:,k);
       figure(2);
       ellipse(Ex(2*l-1:2*l,k),MatricePestk(2*l-1:2*l,2*l-1:2*l),'r');
       hold on;
       scatter(Xreel(2*l-1,k),Xreel(2*l,k),25,'filled');
       hold on;
       scatter(Ex(2*l-1,k),Ex(2*l,k),25,'xr');
       hold on
       if Show_part == 1
           wmax = max(W(1,:,k));
           for i = 1:NNb_part
                scatter(X(2*l-1,i,k),X(2*l,i,k),W(1,i,k)/wmax*50,'d')
           end
       end
    end
    legend("Ellipse d'incertitude","Position réelle du robot et des amers","Position estimé du robot et des amers");
    pause(1)
    clf;
end



%Lors des premiere iterations, les ellipses d'incertitude reste grande.
%Cependant au fur et a mesure que le rebot acquiere des donnes, il exclu les particules qui sont incoherentes. 
%Il en exclus suffisement pour reduire l'estimation a un point mais en enlève trop pour conserver une incertitude correct   

%legende graphe amer
%les rond point represente les position reelle des amers et du robot
%les rond vides represente l'estimé de la position.

                                  