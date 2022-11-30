# A lire depuis gnuplot après execution de md_part2.c pour visualiser les deux centres de masse

set xlabel "Steps"
set ylabel "R"
unset key
plot "output.log" using 1:2 title "Rx_A", "output.log" using 1:3 title "Rx_B"
