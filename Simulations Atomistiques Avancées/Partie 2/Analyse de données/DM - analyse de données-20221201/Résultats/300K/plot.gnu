set xlabel "Distance r"
set ylabel "Radial distribution g(r)"
set title "Normalized Radial Distribution g(r) (T = 300 K)"
set key box
plot "donnees_SiO_300K.log" using 1:3 w l title "SiO", "donnees_OO_300K.log" using 1:3 w l title "OO", "donnees_SiSi_300K.log" using 1:3 w l title "SiSi"
