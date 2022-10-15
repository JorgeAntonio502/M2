# The positions plot :
# The terminal
set term gif animate delay 4 font "Courrier, 11"
# The output
set output 'CO2.gif'
# The plot
set xrange [0:10]
set yrange [0:10]
set tics nomirror
set xlabel "x"
set ylabel "y"
stats 'Positions.txt' name 'A'
do for [i=0:A_blocks-1] {
	plot 'Positions.txt' index i with points pointtype 7 linecolor rgb "red" notitle
}

# The energy plot :
unset xrange
unset yrange
set terminal png
set output "Energy.png"
stats "Energy.txt" name 'B'
set xrange [0: B_max_x]
set xlabel "time (N*dt)"
set ylabel "Energy"
set key top left width 2
plot "Energy.txt" title "Energie totale", "Energy.txt" using 1:3 title "Energie potentielle", "Energy.txt" using 1:4 title "Energie cinétique"
