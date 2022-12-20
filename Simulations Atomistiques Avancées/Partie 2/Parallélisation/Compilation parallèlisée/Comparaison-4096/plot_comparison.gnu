set xrange [0 : 200]
set xlabel "Steps"
set ylabel "Etot"
set title "Comparaison de la précision avec et sans parallélisation"
set key box bottom left
plot "unparallel.dat" using 1:5 w l title "Non parallélisé", "2_threads.dat" using 1:5 w l title "Parallélisé - 2 threads", "3_threads.dat" using 1:5 w l title "Parallélisé - 3 threads", "4_threads.dat" using 1:5 w l title "Parallélisé - 4 threads", "5_threads.dat" using 1:5 w l title "Parallélisé - 5 threads"

