module test
 
  implicit none

contains

  ! A paralleliser avec le construct parallel do
  subroutine saxpy(a,x,y,z)
    integer :: i,n
    real :: z(:,:),a,y,x(:,:)
    
    !$OMP PARALLEL DO
    do i=1,size(x,2)
       z(:,i) = a*x(:,i) + y
    end do
    !$OMP end PARALLEL DO
  end subroutine saxpy

  ! A paralleliser avec workshare
  subroutine saxpy_vector(a,x,y,z)
    integer :: i
    real :: z(:,:),a,y,x(:,:)
    !$OMP  PARALLEL WORKSHARE
    z = a*x + y
    !$OMP END  PARALLEL WORKSHARE
  end subroutine saxpy_vector

  ! A paralleliser avec workshare
  subroutine saxpy_vector_slice(a,x,y,z)
    integer :: i
    real :: z(:,:),a,y,x(:,:)
    !$OMP  PARALLEL WORKSHARE
    z(:,:) = a*x(:,:) + y
    !$OMP END  PARALLEL WORKSHARE
  end subroutine saxpy_vector_slice

end module test

program hello
!$use OMP_LIB
  use test
  implicit none
  integer :: i
  integer, parameter :: ndim=3,n=60000
  real :: a=1.0,y=2.0,x(ndim,n),z(ndim,n)
  x = 1.0
  do i = 1,60000
     !call saxpy(a,x,y,z)
     call saxpy_vector_slice(a,x,y,z)
  end do
end program hello
