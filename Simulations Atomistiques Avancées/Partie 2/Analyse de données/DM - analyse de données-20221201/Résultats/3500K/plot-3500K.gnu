set xlabel "Distance r"
set ylabel "Radial distribution g(r)"
set title "Normalized Radial Distribution g(r) (T = 300 K)"
set key box
plot "Si-O.dat" using 1:3 w l title "SiO", "O-O.dat" using 1:3 w l title "OO", "Si-Si.dat" using 1:3 w l title "SiSi"
