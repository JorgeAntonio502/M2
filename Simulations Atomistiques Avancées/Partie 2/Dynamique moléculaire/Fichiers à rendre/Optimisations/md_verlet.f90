!
! Simple (and inefficient) molecular dynamics simulation of Lennard-Jones particles.
! This code is meant for pedagogical purposes, not for production.
! Author: Daniele Coslovich (daniele.coslovich@umontpellier.fr)
!

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

module kernels

  implicit none

  integer, parameter :: NDIM = 3
  integer, parameter :: DP = selected_real_kind(12)

contains

  ! Read a configuration in xyz format from a file open on the specified unit.
  ! Positions and velocities are stored in arrays of dimensions (NDIM,n)
  ! where n is the number of particles. The box size in an array of size NDIM.
  ! The box size, positions and velocities of particles will be stored
  ! in the allocatable arrays box, pos, and vel, respectively.
  subroutine read(unit,box,pos,vel)
    integer, intent(in)  :: unit
    real(DP),allocatable :: box(:)
    real(DP),allocatable :: pos(:,:), vel(:,:)
    integer              :: i, n
    character(6)         :: string,tmp
    read(unit,*) n
    if (allocated(pos)) deallocate(pos)
    if (allocated(vel)) deallocate(vel)
    if (allocated(box)) deallocate(box)
    allocate(pos(NDIM,n),vel(NDIM,n),box(NDIM))
    read(unit,*) box
    do i = 1,n
       read(unit,*) string,pos(:,i),vel(:,i)
    end do
  end subroutine read

  ! Read simulation parameters from input file provided on the command line
  subroutine input(input_cnf,output_log,nsteps,dt,period_log)
    character(256), intent(inout) :: input_cnf,output_log
    integer,        intent(inout) :: nsteps,period_log
    real(DP),       intent(inout) :: dt
    integer                       :: unit=99
    character(256)                :: input_file, param, value
    if (command_argument_count() /= 1) then
       write(*,"(a)") "Usage: ./a.out <parameter_file>"
       write(*,"(a)") "where <parameter_file> is a file with the simulation parameters."
       stop 
    end if
    call get_command_argument(1,value=input_file)
    open(unit=unit,file=input_file,status="old")
    do
       read(unit,*,end=10) param, value
       if (trim(param) == "period_log") read(value(1:len_trim(value)),*) period_log
       if (trim(param) == "file_log") read(value(1:len_trim(value)),*) output_log
       if (trim(param) == "file_input") read(value(1:len_trim(value)),*) input_cnf
       if (trim(param) == "nsteps") read(value(1:len_trim(value)),*) nsteps
       if (trim(param) == "dt") read(value(1:len_trim(value)),*) dt
    end do
10  continue
    ! Check that input_cnf has been set
    if (len(trim(input_cnf))==0) then
       write(*,"(a)") "Please provide file_input in parameter file"
       stop
    end if
  end subroutine input

  ! Integration step using the velocity-Verlet algorithm
  subroutine evolve(dt,rcut,box,pos,vel,for,epot)
    real(DP), intent(in)    :: dt, rcut
    real(DP), intent(in)    :: box(:)
    real(DP), intent(inout) :: pos(:,:), vel(:,:), for(:,:)
    real(DP), intent(out)   :: epot
    real(DP), parameter     :: mass = 1.0
    integer                 :: i
    pos = pos + vel * dt + 0.5_DP * for / mass * dt**2
    vel = vel + 0.5_DP * for / mass * dt
    do i = 1,size(pos,2) 
       call pbc(pos(:,i),box)
    end do
    call forces(rcut,box,pos,for,epot)
    vel = vel + 0.5_DP * for / mass * dt
  end subroutine evolve

  ! Dump some thermodynamic quantities to the specified IO unit
  subroutine report(what,unit,step,box,pos,vel,epot)
    character(*), intent(in) :: what
    integer,      intent(in) :: unit, step
    real(DP),     intent(in) :: pos(:,:), vel(:,:), box(:), epot
    real(DP)                 :: ekin
    integer                  :: ndim, npart
    if (what == "header") then
       write(unit,"('#',a9,4a14)") "Step", "Epot", "Temp", "Ekin", "Etot"
       write(unit,"('#',65('-'))")
    else if (what == "log") then
       ekin = kinetic(vel)
       ndim = size(pos,1)
       npart = size(pos,2)
       write(unit,"(i10,4es14.6)") step, epot, 2*ekin/(npart*ndim), ekin, epot+ekin
    end if
  end subroutine report

  ! Evaluate the kinetic energy from the particles' velocities
  function kinetic(vel) result (ekin)
    real(DP), intent(in) :: vel(:,:)
    real(DP)             :: ekin
    integer              :: i
    ekin = 0.0_DP
    do i = 1,size(vel,2)
       ekin = ekin + dot_product(vel(:,i),vel(:,i))
    end do
    ekin = ekin / 2
  end function kinetic

  ! Evaluate the potential energy and the virial contribution 
  ! using the cut and shifted Lennard-Jones potential
  subroutine potential(rcut,rsq,u,w)
    real(DP), intent(in)  :: rsq, rcut
    real(DP), intent(out) :: u, w
    real(DP)              :: uc
    uc = 4/rcut**12 - 4/rcut**6
    u = 4 * (1/rsq**6 - 1/rsq**3) - uc
    w = 24 * (2/rsq**6 - 1/rsq**3 ) / rsq
  end subroutine potential

  ! Apply minimum image convention to a distance vector r.
  ! This subroutine can also be used to fold a particle back 
  ! in the central cell during a simulation. However, it won't
  ! correctly fold back a particle from an arbitrary position.
  subroutine pbc(r,box)
    real(DP), intent(inout) :: r(:)
    real(DP), intent(in)    :: box(:)
    where (abs(r) > box/2)
       r = r - sign(box,r)
    end where
  end subroutine pbc

  ! Evaluate the potential energy and the forces between particles
  subroutine forces(rcut,box,pos,for,epot)
    real(DP), intent(in)  :: box(:), rcut
    real(DP), intent(in)  :: pos(:,:)
    real(DP), intent(out) :: for(:,:)
    real(DP), intent(out) :: epot
    real(DP)              :: rij(size(pos,1)), rijsq, uij, wij
    integer               :: i, j
    
    for = 0.0_DP
    epot = 0.0_DP
    
    do i = 1,size(pos,2)
       do j = i+1,size(pos,2)
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
  end subroutine forces

end module kernels

program main

  use kernels
  USE neighbors_module

  implicit none
  
  ! Déclaration variables 
  real(DP),allocatable :: pos(:,:), vel(:,:), for(:,:), box(:)
  integer, allocatable  :: neighbors_number(:), neighbors_list(:,:)
  integer              :: unit_inp=100, unit_log=101, max_neighbors, period_neighbors = 15;
  integer              :: i, nsteps=1000, period_log=10, nv
  character(256)       :: file_inp="", file_log="output.dat"
  real(DP)             :: dt=0.002_DP, epot, rcut=2.5_DP, dum, rmax = 3.0_DP
  
  !allocate(neighbors_number(512))
  !allocate(neighbors_list(max_neighbors,512))

  call input(file_inp,file_log,nsteps,dt,period_log)
  open(unit=unit_inp,file=file_inp,status="old")
  open(unit=unit_log,file=file_log,status="unknown")

  ! Read input configuration and allocate arrays
  call read(unit_inp,box,pos,vel)
  allocate(for(size(pos,1),size(pos,2)))

  ! Dump to log file
  write(unit_log,"('# Number of particles =',i15)") size(pos,2)
  write(unit_log,"('# Box side            =',f15.3)") box(1)
  write(unit_log,"('# Time step           =',es15.3)") dt
  write(unit_log,"('#')") 
  call report("header",unit_log,i,box,pos,vel,epot)

  ! Main MD loop
  call compute_neighbors(rmax,box,pos,neighbors_number,neighbors_list)
  call forces_with_neighbors(rcut,box,pos,neighbors_number,neighbors_list,for,epot)
  do i = 1,nsteps
     call evolve_with_neighbors(dt,rcut,box,pos,neighbors_number,neighbors_list,vel,for,epot)
     if (mod(i,period_neighbors)==0) call compute_neighbors(rmax,box,pos,neighbors_number,neighbors_list)
     if (mod(i,period_log)==0) call report("log",unit_log,i,box,pos,vel,epot) 
  end do

  close(unit_inp)
  close(unit_log)

end program main
