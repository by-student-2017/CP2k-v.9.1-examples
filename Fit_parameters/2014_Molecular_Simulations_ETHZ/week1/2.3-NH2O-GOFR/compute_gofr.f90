MODULE trajectory_tools
IMPLICIT NONE
PRIVATE
INTEGER,PARAMETER :: dp=KIND(0.0D0)
PUBLIC :: read_xyz_frame,pbc,dp
CONTAINS

SUBROUTINE pbc(res,x,L,Linv) 
  REAL(KIND=dp) :: x(3),res(3),L,Linv
  res(1)=x(1)-L*ANINT(x(1)*Linv)
  res(2)=x(2)-L*ANINT(x(2)*Linv)
  res(3)=x(3)-L*ANINT(x(3)*Linv)
END SUBROUTINE

SUBROUTINE read_xyz_frame(x,iunit,success)
  INTEGER :: iunit
  REAL(KIND=dp), DIMENSION(:,:), POINTER ::  x
  LOGICAL :: success
  CHARACTER(LEN=2) :: AA
  INTEGER :: i,k
  success=.FALSE.
  read(iunit,FMT=*,END=999,ERR=998)
  read(iunit,FMT=*,END=999,ERR=998)
  DO i=1,SIZE(x,2)
     read(iunit,FMT=*,END=999,ERR=998) AA,(x(k,i),k=1,SIZE(x,1))
  ENDDO
  success=.TRUE.
998 CONTINUE
999 CONTINUE
END SUBROUTINE read_xyz_frame
END MODULE trajectory_tools

PROGRAM MAIN
  USE trajectory_tools
  IMPLICIT NONE
  INTEGER, PARAMETER :: iunit = 11
  
  INTEGER :: Nframe,Natom,iframe,Nframe_first,Nframe_last
  LOGICAL :: success
  REAL(KIND=dp) :: boxl

  TYPE frame_type
       REAL(KIND=dp), DIMENSION(:,:), POINTER :: x
  END TYPE
  REAL(KIND=dp), DIMENSION(:,:), POINTER :: dum
  TYPE(frame_type), DIMENSION(:), ALLOCATABLE :: trajectory
  INTEGER :: Nspec,i
  REAL(KIND=dp) :: dr,pi,dist,norm,Linv
  INTEGER :: Nbins, Ngofr,ispec,jspec,iatom,jatom,igofr,ibin
  REAL(KIND=dp), DIMENSION(:,:), POINTER :: gofr
  REAL(KIND=dp), DIMENSION(3) :: rab,rab_pbc,res
  CHARACTER(LEN=80) :: filename,filename_in

  TYPE atom_descriptor
    INTEGER :: species
    INTEGER :: molecule
  END TYPE
  TYPE(atom_descriptor), DIMENSION(:), ALLOCATABLE :: atom_info
  INTEGER, DIMENSION(:,:), ALLOCATABLE :: spec_spec_gofr
  INTEGER, DIMENSION(:), ALLOCATABLE :: Natom_spec 
  CHARACTER(LEN=10), DIMENSION(:), ALLOCATABLE :: label

  pi=4.0*ATAN(1.0)

  READ(5,*) filename_in
  READ(5,*) Natom
  READ(5,*) Nframe_first
  READ(5,*) Nframe_last
  Nframe=Nframe_last-Nframe_first+1
  READ(5,*) boxl
  Linv=1.0D0/boxl
  READ(5,*) dr
  READ(5,*) Nspec
  ALLOCATE(label(Nspec))
  READ(5,*) label
  ! group atoms in molecules and species
  ALLOCATE(atom_info(Natom))
  DO I=1,Natom
     READ(5,*) atom_info(I)%molecule,atom_info(I)%species
  ENDDO
  IF (NSPEC.NE.MAXVAL(atom_info(:)%species)) STOP "Nspec ?"
  ALLOCATE(Natom_spec(Nspec))
  DO I=1,Nspec
     Natom_spec(I)=COUNT(atom_info(:)%species .EQ. I)
  ENDDO
  IF (SUM(Natom_spec).NE.Natom) STOP "Natom ?"

  ! write some info
  WRITE(6,*) "Reading from:           "," "//TRIM(filename_in)
  WRITE(6,*) "Number of atoms:        ",Natom
  WRITE(6,*) "First frame:            ",Nframe_first
  WRITE(6,*) "Last frame:             ",Nframe_last
  WRITE(6,*) "Edge of simulation cell:",boxl
  WRITE(6,*) "Number of species:      ",Nspec
  WRITE(6,'(5X,5A10)') label

  ! map species-species to gofrs
  ALLOCATE(spec_spec_gofr(Nspec,Nspec))
  igofr=0
  DO ispec=1,Nspec
   DO jspec=ispec,Nspec
    igofr=igofr+1
    spec_spec_gofr(ispec,jspec)=igofr
    spec_spec_gofr(jspec,ispec)=igofr
   ENDDO
  ENDDO
   

  Ngofr=(Nspec*(Nspec+1))/2
  Nbins=CEILING(boxl/2.0/dr) ! we provide a gofr for half the box
  ALLOCATE(gofr(Nbins,Ngofr))
  gofr=0.0
  ALLOCATE(dum(3,Natom))
  ALLOCATE(trajectory(Nframe))

  WRITE(6,*) "Reading frames ..."

  OPEN(UNIT=iunit,FILE=filename_in)
  DO iframe=1,Nframe_first-1
     CALL read_xyz_frame(dum,iunit,success)
     IF (.NOT. success) THEN
        write(6,*) "Error : could only read ",iframe-1," frames of the trajectory"
        STOP
     ENDIF
  ENDDO
  DO iframe=1,Nframe
     ALLOCATE(trajectory(iframe)%x(3,Natom))
     CALL read_xyz_frame(trajectory(iframe)%x,iunit,success)
     IF (.NOT. success) THEN
        write(6,*) "Error : could only read ",iframe-1," frames of the trajectory"
        STOP
     ENDIF
  ENDDO
  CLOSE(iunit)

  WRITE(6,*) "... Done"
  WRITE(6,*) "Computing g(r) ..."

  ! compute g(r), unnormalised first
  DO iframe=1,Nframe
     IF (MOD(iframe*10,(Nframe/10)*10)==0) WRITE(6,*) "   ",iframe,"/",Nframe
     DO iatom=1,Natom
        DO jatom=iatom+1,Natom
           rab(:)=trajectory(iframe)%x(:,iatom)-trajectory(iframe)%x(:,jatom)
           CALL pbc(rab_pbc,rab,boxl,Linv)
           dist=SQRT(DOT_PRODUCT(rab_pbc,rab_pbc))
           ibin=CEILING(dist/dr)
           IF (ibin.LE.Nbins) THEN
              igofr=spec_spec_gofr(atom_info(iatom)%species,atom_info(jatom)%species)
              IF (atom_info(iatom)%molecule .NE. atom_info(jatom)%molecule) THEN 
                  gofr(ibin,igofr)=gofr(ibin,igofr)+2.0
              ENDIF
           ENDIF
        ENDDO
     ENDDO
  ENDDO

  ! normalise the g(r)
  igofr=0
  DO ispec=1,Nspec
     DO jspec=ispec,Nspec
        igofr=igofr+1
        DO ibin=1,Nbins
           norm=1.0
           IF (ispec.NE.jspec) norm=2.0
           gofr(ibin,igofr)=gofr(ibin,igofr)/( &
             norm*nframe*natom_spec(ispec)*(natom_spec(jspec)/boxl**3)*4.0*pi*(dr**3)* &
             (REAL(ibin,KIND=dp)**3-REAL(ibin-1,KIND=dp)**3)/3.0  )
        ENDDO
     ENDDO
  ENDDO

  WRITE(6,*) "... Done"
  WRITE(6,*) "Writing results to files: "
  ! write to file
  igofr=0
  DO ispec=1,Nspec
     DO jspec=ispec,Nspec
        igofr=igofr+1
        write(filename,*) "gofr_"//TRIM(label(ispec))//"_"//TRIM(label(jspec))
        write(6,*) TRIM(ADJUSTL(filename))
        OPEN(17,FILE=TRIM(ADJUSTL(filename)))
        DO ibin=1,Nbins
           write(17,'(2F10.4)') (ibin-0.5)*dr,gofr(ibin,igofr)
        ENDDO
        CLOSE(17)
     ENDDO
  ENDDO

  ! dealloc the trajectory
  DO iframe=1,Nframe
     DEALLOCATE(trajectory(iframe)%x)
  ENDDO
  DEALLOCATE(trajectory)
  DEALLOCATE(gofr)
  DEALLOCATE(dum)
END PROGRAM


