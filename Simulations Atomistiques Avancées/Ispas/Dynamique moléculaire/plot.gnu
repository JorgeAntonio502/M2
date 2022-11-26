set terminal qt
set xlabel "Steps"
set ylabel "R"
plot "output.log" using 1:2 title "Rx_A", "output.log" using 1:3 title "Rx_B"
