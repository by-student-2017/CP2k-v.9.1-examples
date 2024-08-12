IMPLICIT NONE

real, dimension(:,:,:), ALLOCATABLE :: trajectory
real*8, dimension(:), ALLOCATABLE :: msd
real :: r(3),dt
integer :: i,Nframes,Natom,Nox,iframe,jframe,line
character(LEN=80)  :: trajfilename,outfilename,title
character(LEN=2)  :: ele

read(5,*) trajfilename
read(5,*) dt
read(5,*) outfilename
open(10,FILE=trajfilename)
rewind(10)
read(10,*) Natom
rewind(10)

! # water molecules = # oxygens
Nox=Natom/3

! count frames
line=0
Nframes=0
write(*,*) "Counting number of frames"
DO 
  line=line+1
  READ(10,*,END=999,ERR=999) Natom
  line=line+1
  READ(10,'(A80)',END=999,ERR=999) title
  DO i=1,Natom
     line=line+1
     READ(10,*,END=999,ERR=999) ele,r
  ENDDO
  Nframes=Nframes+1
ENDDO
999 CONTINUE
write(6,*) "Found ", Nframes, " frames on ", line, " lines"
REWIND(10)

! Stores coordinates of oxygens
ALLOCATE(trajectory(3,Nox,Nframes))
ALLOCATE(msd(0:Nframes-1))

! read trajectory
write(*,*) "Reading frames"
DO iframe=1,Nframes
   READ(10,*,END=999,ERR=999) Natom
   READ(10,'(A80)',END=999,ERR=999) title
   DO i=1,Natom
      READ(10,*,END=999,ERR=999) ele,r
      ! Assume that order is O-H-H-O-H-H ...
      IF (MOD(i-1,3)==0) trajectory(:,(i-1)/3+1,iframe)=r
   ENDDO
ENDDO

! compute MSD of oxygens

! Note: the msd during the 1st ps will be influenced by
! later calculations!
write(*,*) "Computing mean squared displacement ( * = 10% )"
msd=0
DO iframe=1,Nframes
 DO jframe=iframe,Nframes
   DO i=1,Nox
    msd(jframe-iframe)=msd(jframe-iframe)+SUM((trajectory(:,i,iframe)-trajectory(:,i,jframe))**2)
   ENDDO
 ENDDO
ENDDO
write(*,*) ""

! normalize and write
write(*,*) "Writing msd to ", outfilename
open(11,FILE=outfilename)
write(11,*) "# time [units as in input, e.g. fs],  MSD in Angstrom**2"
DO iframe=0,Nframes-1
   jframe=Nframes-iframe
   msd(iframe)=(msd(iframe)/Nox)/jframe
   write(11,*) iframe*dt,msd(iframe)
ENDDO
END
