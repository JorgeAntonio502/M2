set terminal qt
set yrange [1.850290E+03 + 5 : 1.850290E+03 - 5]
set xlabel "Steps"
set ylabel "Etot"
plot "output.log" using 1:5
