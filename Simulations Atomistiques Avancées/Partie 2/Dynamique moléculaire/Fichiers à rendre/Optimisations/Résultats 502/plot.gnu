set yrange [1.850290E+03 -5 : 1.850290E+03 + 5]
set xlabel "Steps"
set ylabel "Etot"
unset key
plot "donnees_calcul_distance.log" using 1:5
#plot "donnees_PBC.log" using 1:5
#plot "donnees_uc.log" using 1:5
#plot "donnees_verlet.log" using 1:5
