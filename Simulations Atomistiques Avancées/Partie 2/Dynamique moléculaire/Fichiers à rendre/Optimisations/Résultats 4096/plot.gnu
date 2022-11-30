set yrange [1.409354E+04 -5 : 1.409354E+04 + 5]
set xlabel "Steps"
set ylabel "Etot"
unset key
plot "donnees_calcul_distance.log" using 1:5 w l
#plot "donnees_PBC.log" using 1:5 w l
#plot "donnees_uc.log" using 1:5 w l
#plot "donnees_verlet.log" using 1:5 w l 
