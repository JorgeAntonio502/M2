set xlabel "Temperature"
set ylabel "Taux d'acceptation"
unset key
set title "Taux d'acceptation des déplacements en fonction de la température du système"
plot "taux_acceptation.dat" w l
