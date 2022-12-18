set xlabel "density (N/V)"
set ylabel "Mean energy per particle"
unset key
plot "Transition.dat" using 2:($3/100) w l
