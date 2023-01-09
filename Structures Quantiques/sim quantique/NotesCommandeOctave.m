
•	[vp vlp]Eig(Matrice)
•	Vp valeur propre vlp valeurs propre

who donne les variables

clear vide les variables

commencer un programme par un clear pour effacer d'éventuelles variables

format long
permet d'avoir plus

log() logarithme hyperbolique

log10()
vecteur ligne
l=[1 2 3]
vecteur colonne
d=[1;2;3]

logspace (a, b, n)
returns a row vector with n elements logarithmically spaced from 10^a to 10^b.

l' transposé conjugué
l.' transposé (non conjugué)

creer un vecteur de point 2 facon
avec le pas:
n= 1:2:10 ( nombre de depart : pas : nombre d'arrivé )

avec le nombre N de points
linspace(a,b,N)

plot(x1,f(x1),x2,f(x2))
grid

Anonymous functions
f = @(x) abs(sin(x))

le .* multiplication terme à terme

documentation avec help

fsolve(sin,.5) donne le 0 qui est le plus proche de la seed ici 0.5 ce qui va donc conditionner le résulat

on peut avoir sûrement une option qui donne les solutions (a trouver)

codesQWs

pwd pour savoir dans quel repertoire on est
ls
cd

on met ... pour continuer le calcul apres

executer section F9

floor pour partie entiere

format long %pour que les résultats soit grand

figure; hold on
si on veut garder la meme figure et rajouter mettre juste hold on
