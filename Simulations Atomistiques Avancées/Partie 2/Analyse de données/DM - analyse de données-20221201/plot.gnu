set xlabel "Distance r"
set ylabel "Radial distribution g(r)"
set title "Normalized Radial Distribution g(r)"
unset key
plot "output.log" using 1:3 w l
