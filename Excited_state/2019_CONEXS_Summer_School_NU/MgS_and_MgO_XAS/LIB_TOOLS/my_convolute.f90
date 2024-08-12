      implicit none

      integer :: npnt, nmesh, ncol
      integer :: ic, il, im, istat
      integer :: i,argcount,IARGC
      real :: emin, emax, de, pi, root2pi
      real :: e1, e2, sigmin, sigmax
      real :: fact, func, sum, ww
      real, dimension(:), allocatable :: sigma, xmesh, xline
      real, dimension(:,:), allocatable :: ymesh, yline

      character*80   wq_char
      character*80   filein, fileout
      logical :: read_e1, read_e2

      !defaults
      de = 0.1d0
      sigmin = 1.0d0
      sigmax = 8.0d0
      npnt = 10
      filein = "spectrum.inp"
      fileout = "spectrum.out"
      pi = acos(-1.0d0)
      root2pi = sqrt(2.0d0*pi)
      ncol = 4
      read_e1 = .false.
      read_e2 = .false.

      argcount = IARGC()
      do i=1,argcount
        call getarg(i,wq_char)
        !number of lines
        if(INDEX(wq_char,'-pnt').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) npnt
        end if
        !integration step
        if(INDEX(wq_char,'-de').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) de
        end if
        !energy up to which sigma is constant and equal to its minimum
        if(INDEX(wq_char,'-e1').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) e1
          read_e1 = .true.
        end if
        !energy beyond which sigma is constant and equal to its maximum
        if(INDEX(wq_char,'-e2').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) e2
          read_e2 = .true.
        end if
        !minimum value for sigma
        if(INDEX(wq_char,'-smin').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) sigmin
        end if
        !maximum value for sigma
        if(INDEX(wq_char,'-smax').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) sigmax
        end if
        !number of columns
        if(INDEX(wq_char,'-ncol').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) ncol
        end if
        ! input file
        if(INDEX(wq_char,'-fin').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) filein
        end if
        ! output file
        if(INDEX(wq_char,'-fout').NE.0) then
          call getarg(i+1,wq_char)
          read(wq_char,*) fileout
        end if
      enddo

      write(6,'(T5,A)') ' Read from input line:'
      write(6,'(T30,A,T50,I14)') '# lines ', npnt
      write(6,'(T30,A,T50,f14.3)') 'integration step ', de
      write(6,'(T30,A,T50,f14.3)') 'Minimum sigma ', sigmin
      write(6,'(T30,A,T50,f14.3)') 'Maximum sigma ', sigmax
      write(6,'(T30,A,T50,A14)') 'Input file ', filein
      write(6,'(T30,A,T50,A14)') 'Output file ', fileout

      open(10,file=filein,status="old")

      emin = 10000.0d0
      emax = 0.0d0
      do il = 1,npnt
        read(10,*) i, ww
        if(ww < emin) emin = ww
        if(ww > emax) emax = ww
      end do 

      emin = emin - 2.0d0
      emax = emax + 2.0d0

      nmesh =  int((emax-emin)/de)+1

      write(6,'(T30,A,T50,f14.3)') 'Minimum energy ', emin
      write(6,'(T30,A,T50,f14.3)') 'Maximum energy ', emax
      write(6,'(T30,A,T50,I14)') '# of mesh points ', nmesh

      IF(.NOT. read_e1) THEN
          e1 = emin + 5.0d0
      ENDIF
      IF(.NOT. read_e2) THEN
          e2 = e1 +  25.0d0
      END IF
      IF(.NOT. read_e2 .AND. .NOT. read_e1) e2 = emin + 25.0d0

      write(6,'(T30,A,T50,f14.3)') 'E1 ', e1
      write(6,'(T30,A,T50,f14.3)') 'E2 ', e2

      allocate(xmesh(nmesh),xline(npnt),STAT=istat)
      allocate(ymesh(ncol,nmesh),yline(ncol,npnt),STAT=istat)
      allocate(sigma(npnt),STAT=istat)

      rewind(10)
      do il = 1,npnt
        read(10,*)i , xline(il),(yline(ic,il),ic=1,ncol)
        IF( xline(il) < e1 ) THEN
          sigma(il) = sigmin/(2.D0*SQRT(2.D0*LOG(2.D0)))
        ELSEIF( xline(il) > e2 ) THEN
          sigma(il) = sigmax/(2.D0*SQRT(2.D0*LOG(2.D0)))
        ELSE
          sigma(il) =  ((xline(il)-e1)*(sigmax-sigmin)/ &
              (e2-e1)+sigmin)/(2.D0*SQRT(2.D0*LOG(2.D0)))
        END IF
  write(*,*) il,  xline(il),  yline(4,il) , sigma(il)
      end do 
      close(10)

      DO im = 1,nmesh
        ymesh(1:ncol,im) = 0.0d0
        xmesh(im) = emin + real(im)*de
        DO il = 1,npnt
          fact = de/(sigma(il)*root2pi)
          func = exp(-(xmesh(im)-xline(il))**2/(2.d0*sigma(il)**2))*fact
          DO ic = 1,ncol
            ww = yline(ic,il)
            ymesh(ic,im) =  ymesh(ic,im) + func*ww
          END DO  ! ic
        END DO  ! il
      END DO  ! im


      open(20,file=fileout,status="unknown")
      sum = 0.0D0
      DO im = 1,nmesh
         sum = sum +  ymesh(ncol,im)
         write(20,'(f10.4,10f14.6)') xmesh(im),(ymesh(ic,im),ic=1,ncol),sum
      END DO
      close(20)

      deallocate(xline,xmesh,STAT=istat)
      deallocate(yline,ymesh,STAT=istat)
      deallocate(sigma,STAT=istat)

      end
