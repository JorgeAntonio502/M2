function [En_bar, Psi, v] = double_rect(v_0, a_bar, N, l_bar, n_modes, d_bar)
  options.disp = 0;

  dx = l_bar / N;
  x = - l_bar / 2 + dx * (0:N);
  x_centre = 0.;
  v = v_0 * ((abs(x) <= d_bar / 2.) + (d_bar / 2. + a_bar <= abs(x)));

  ee = ones(N+1, 1);
  Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
  A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);

  [Psi, E] = eigs(A, n_modes, 'sm', options);
  En_bar = sort(diag(E));
end
