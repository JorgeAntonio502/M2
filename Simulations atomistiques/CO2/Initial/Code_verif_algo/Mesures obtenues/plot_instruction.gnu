stats "data.dat" name 'A'
#set yrange[A_min_y : A_max_y]
set xlabel "ln(dt)"
set ylabel "ln(E(t*) - E_0)"
unset key
#f(x) = a*x + b
#fit f(x) "data.dat" via a, b
plot "data.dat"
