# The positions plot :
# The terminal
set term gif animate delay 4 font "Courrier, 11"
# The output
set output 'CO2.gif'
# The plot
set xrange [0:50]
set yrange [0:50]
set tics nomirror
set xlabel "x"
set ylabel "y"
stats 'positions.txt' name 'A'
do for [i=0:A_blocks-1] {
	plot 'positions.txt' index i with points pointtype 7 linecolor rgb "red" notitle
}

# The energy plot :
unset xrange
unset yrange
set terminal png
set output "Energy.png"
stats "energy.txt" name 'B'
set xrange [0: B_max_x]
set xlabel "temps (N*dt)"
set ylabel "Energy of the system"
unset key
plot "energy.txt"
