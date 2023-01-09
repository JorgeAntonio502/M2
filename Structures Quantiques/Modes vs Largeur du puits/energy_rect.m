function [En_bar] = energy_rect(v_0, lim_bar, N, l_bar, n_modes)
  options.disp = 0;

  dx = l_bar / N;
  x = - l_bar / 2 + dx * (0:N);
  v = v_0 * (abs(x) >= lim_bar);

  ee = ones(N+1, 1);
  Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
  A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);

  [Psi, E] = eigs(A, n_modes, 'sm', options);
  En_bar = sort(diag(E));
end

