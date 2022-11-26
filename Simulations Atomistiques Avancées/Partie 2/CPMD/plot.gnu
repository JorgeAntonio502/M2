set terminal pdf
set output "Etot.pdf"
set xlabel "Ecutt (Ry)"
set ylabel "Etot (AU)"
unset key
plot "Etot.txt"
