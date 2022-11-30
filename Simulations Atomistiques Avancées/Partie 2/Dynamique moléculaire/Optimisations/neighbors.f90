module neighbors_module

  use kernels, only: DP, pbc, potential

  implicit none

contains

  ! Time integration with neighbor list
  subroutine evolve_with_neighbors(dt,rcut,box,pos,neighbors_number,neighbors_list,vel,for,epot)
    real(DP), intent(in)    :: dt, rcut
    real(DP), intent(in)    :: box(:)
    real(DP), intent(inout) :: pos(:,:), vel(:,:), for(:,:)
    integer,  intent(inout) :: neighbors_number(:), neighbors_list(:,:)
    real(DP), intent(out)   :: epot
    real(DP), parameter     :: mass = 1.0
    integer                 :: i
    pos = pos + vel * dt + 0.5_DP * for / mass * dt**2
    vel = vel + 0.5_DP * for / mass * dt
    do i = 1,size(pos,2) 
       call pbc(pos(:,i),box)
    end do
    call forces_with_neighbors(rcut,box,pos,neighbors_number,neighbors_list,for,epot)
    vel = vel + 0.5_DP * for / mass * dt
  end subroutine evolve_with_neighbors

  ! Compute neighbor list using O(N^2) method
  ! Note: rmax is the distance up to which particles are considered neighbors,
  ! typically rmax = rcut + rskin, where rcut is the potential cutoff distance
  ! and rskin is a length of the order of a fraction of the interparticle distance.
  subroutine compute_neighbors(rmax,box,pos,neighbors_number,neighbors_list)
    real(DP), intent(in)  :: box(:), rmax
    real(DP), intent(in)  :: pos(:,:)
    integer, allocatable  :: neighbors_number(:), neighbors_list(:,:)
    real(DP)              :: rij(size(pos,1)), rijsq
    integer               :: i, j, npart, nmax
    real(DP)              :: x
    npart = size(pos,2)
    if (.not.allocated(neighbors_number)) then
       allocate(neighbors_number(npart))
    end if
    if (.not.allocated(neighbors_list)) then
       ! For each particle, the size of the list is the average number of particles
       ! within the cutoff times a factor, x, that accounts for fluctuations around
       ! this average value. Values around 3-4 are usually large enough.
       x = 3
       nmax = int(x * 4./3.*3.1415 * (npart / product(box)) * rmax**3)
       allocate(neighbors_list(nmax,npart))
    end if
    neighbors_number = 0
    do i = 1,npart
       do j = i+1,npart
          rij = pos(:,i) - pos(:,j)
          call pbc(rij,box)
          rijsq = dot_product(rij,rij)
          if (rijsq < rmax**2) then
             ! Increment number of neighbors of particle i by one
             neighbors_number(i) = neighbors_number(i) + 1
             ! Add particle j to neighbor list of particle i 
             neighbors_list(neighbors_number(i),i) = j
          end if
       end do
    end do
  end subroutine compute_neighbors

  ! Evaluate the potential energy and the forces between particles
  subroutine forces_with_neighbors(rcut,box,pos,neighbors_number,neighbors_list,for,epot)
    real(DP), intent(in)  :: box(:), rcut
    real(DP), intent(in)  :: pos(:,:)
    integer,  intent(in)  :: neighbors_number(:),neighbors_list(:,:)
    real(DP), intent(out) :: for(:,:)
    real(DP), intent(out) :: epot
    real(DP)              :: rij(size(pos,1)), rijsq, uij, wij
    integer               :: i, j, jj
    for = 0.0_DP
    epot = 0.0_DP
    do i = 1,size(pos,2)
       ! Loop over all neighbors of particle i
       ! We assume 3rd Netwon law 
       do jj = 1,neighbors_number(i)
          j = neighbors_list(jj,i)
          rij = pos(:,i) - pos(:,j)
          call pbc(rij,box)
          rijsq = dot_product(rij,rij)
          if (rijsq < rcut**2) then
             call potential(rcut,rijsq,uij,wij) ! wij = -(du/dr)/r
             epot = epot + uij
             for(:,i) = for(:,i) + wij * rij
             for(:,j) = for(:,j) - wij * rij
          end if
       end do
    end do
  end subroutine forces_with_neighbors

end module neighbors_module
