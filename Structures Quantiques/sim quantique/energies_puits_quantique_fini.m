%x=[-10:10]; %ne donne que des entier ce qui n'es pas le but
clear
V0=5;

%k=0:10/99:10;

k=linspace(0,20,1000);

alpha= 1/(pi*sqrt(V0));

%cos(k)
condition_tan= tan(k/2)>=0; %donne vecteur avec 1 quand condition  respecté et 0 sinon

%plot(k,abs(cos(k)),tan(k),alpha*k*2);
%plot(k,abs(cos(k)),tan(k));

cos_respectant = condition_tan.*abs(cos(k/2));

%trouver les points de croisementcroisement entre les 2
points_croisant = abs(cos_respectant-(alpha*k)) <2.4e-2;
%conditions ne sont pas tres précises pour avoir les croisement

cos_respectant


plot(k/2,abs(cos_respectant),k/2,alpha*k,k/2, points_croisant);

%pour plot differentes fonction sur octave au meme endroit il faut à chaque fois dire avant les x

title('Puits quantique non infini en 1D, condition modale pour trouver les energies');
    xlabel('k/2'); ylabel('Y=fonction(k/2)');
    legend('|cos(k/2)| lorsque tan(k/2)>=0','alpha k');
