set xlabel "Distance r"
set ylabel "Radial distribution g(r)"
set title "Normalized Radial Distribution g(r) (T = 3500 K)"
set key box
plot "donnees_SiO_3500K.log" using 1:3 w l title "SiO", "donnees_OO_3500K.log" using 1:3 w l title "OO", "donnees_SiSi_3500K.log" using 1:3 w l title "SiSi"
