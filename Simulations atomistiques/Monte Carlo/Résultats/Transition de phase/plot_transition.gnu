set xlabel "densité (N/V)"
set ylabel "Mean energy per particle"
set title "Energie moyenne par particule en fonction de la densité"
unset key
plot "Transition.dat" using 2:($3/100) w l
