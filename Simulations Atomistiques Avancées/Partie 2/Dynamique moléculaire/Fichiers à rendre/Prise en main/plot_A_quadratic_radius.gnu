# A lire depuis gnuplot après exécution de md_part1.c pour observer le rayon quadratique

set xlabel "Steps"
set ylabel "Center of mass"
unset key
plot "donnees_A.log" using 1:3
