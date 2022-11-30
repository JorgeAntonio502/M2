# The positions plot :
# The terminal
set term gif animate delay 4 font "Courrier, 11"
#set term png
# The output
set output 'MC_L9.gif'
#set output 'MC.png'
# The plot
set xrange [0:9]
set yrange [0:9]
set tics nomirror
set xlabel "x"
set ylabel "y"
stats 'Positions.txt' name 'A'
do for [i=0:A_blocks-1] {
	plot 'Positions.txt' index i with points pointtype 7 linecolor rgb "red" notitle
}


# The Ep plot :
unset xrange
unset yrange
set terminal png
set output "Ep_MC_L9.png"
stats "Potential_Energy.txt" name 'B'
set xrange [0: B_max_x]
set xlabel "Monte-Carlo Cycle"
set ylabel "Mean Potential Energy"
set key top right box
set key font "Arial, 14"
plot "Potential_Energy.txt" title "Mean Ep per MC cycle (L=9)" w l
