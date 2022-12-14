# The positions plot :
# The terminal
set term gif animate delay 4 font "Courrier, 11"
#set term png
# The output
set output 'MC.gif'
#set output 'MC.png'
# The plot
set xrange [0 : 40]
set yrange [0 : 40]
set tics nomirror
set xlabel "x"
set ylabel "y"
unset key
stats 'Positions.txt' name 'A'
do for [i=0:A_blocks-1] {
	plot 'Positions.txt' index i with points pointtype 7 linecolor rgb "red" notitle
}


# The Ep plot :
unset xrange
unset yrange
set terminal png
set output "Ep_MC.png"
stats "Physical_quantities.txt" name 'B'
set xrange [1: B_max_x]
set xlabel "Monte-Carlo Cycle"
set ylabel "Mean Potential Energy"
set key top right box
set key font "Arial, 14"
plot "Physical_quantities.txt" title "Mean Ep per MC cycle" w l

# The P plot :
unset xrange
unset yrange
set terminal png
set output "Pressure_MC.png"
stats "Physical_quantities.txt" using 1:3 name 'C'
set xrange [1: C_max_x]
set xlabel "Monte-Carlo Cycle"
set ylabel "Mean Pressure"
set key top right box
set key font "Arial, 14"
plot "Physical_quantities.txt" using 1:3 title "Mean Pressure per MC cycle" w l
