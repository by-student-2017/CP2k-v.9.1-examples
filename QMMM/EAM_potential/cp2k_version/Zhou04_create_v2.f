C author: X. W. Zhou, xzhou@sandia.gov
C updates by: Lucas Hale lucas.hale@nist.gov
c      open(unit=5,file='a.i')
      call inter
c      close(5)
      call writeset
      stop
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c main subroutine.                                                c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine inter
      implicit real*8 (a-h,o-z)
      implicit integer*8 (i-m)
      character*80 atomtype,atommatch,outfile,outelem
      namelist /funccard/ atomtype
      common /pass1/ re(16),fe(16),rhoe(16),alpha(16),
     *   beta(16),beta1(16),A(16),B(16),cai(16),ramda(16),
     *   ramda1(16),Fi0(16),Fi1(16),Fi2(16),Fi3(16),
     *   Fm0(16),Fm1(16),Fm2(16),Fm3(16),Fm4(16),
     *   fnn(16),Fn(16),rhoin(16),rhoout(16),rhol(16),
     *   rhoh(16),rhos(16)
      common /pass2/ amass(16),Fr(50001,16),rhor(50001,16),
     *   z2r(50001,16,16),blat(16),drho,dr,rc,outfile,outelem
      common /pass3/ ielement(16),ntypes,nrho,nr
      ntypes=0
10    continue
      atomtype='none'
      read(5,funccard)
      if (atomtype .eq. 'none') goto 1200
      open(unit=10,file='EAM_code',form='FORMATTED',status='OLD')
11    read(10,9501,end=1210)atommatch
9501  format(a80)
      if (atomtype .eq. atommatch) then
         ntypes=ntypes+1
         length=len_trim(outfile)
         if (length .eq. len(outfile)) then
            outfile = atomtype
         else
            outfile = outfile(1:length)//atomtype
         endif
         length=len_trim(outelem)
         if (length .eq. len(outelem)) then
            outelem = atomtype
         else
            outelem = outelem(1:length)//' '//atomtype
         endif
         read(10,*) re(ntypes)
         read(10,*) fe(ntypes)
         read(10,*) rhoe(ntypes)
         read(10,*) rhos(ntypes)
         read(10,*) alpha(ntypes)
         read(10,*) beta(ntypes)
         read(10,*) A(ntypes)
         read(10,*) B(ntypes)
         read(10,*) cai(ntypes)
         read(10,*) ramda(ntypes)
         read(10,*) Fi0(ntypes)
         read(10,*) Fi1(ntypes)
         read(10,*) Fi2(ntypes)
         read(10,*) Fi3(ntypes)
         read(10,*) Fm0(ntypes)
         read(10,*) Fm1(ntypes)
         read(10,*) Fm2(ntypes)
         read(10,*) Fm3(ntypes)
         read(10,*) fnn(ntypes)
         read(10,*) Fn(ntypes)
         read(10,*) ielement(ntypes)
         read(10,*) amass(ntypes)
         read(10,*) Fm4(ntypes)
         read(10,*) beta1(ntypes)
         read(10,*) ramda1(ntypes)
         read(10,*) rhol(ntypes)
         read(10,*) rhoh(ntypes)
         blat(ntypes)=sqrt(2.0d0)*re(ntypes)
         rhoin(ntypes)=rhol(ntypes)*rhoe(ntypes)
         rhoout(ntypes)=rhoh(ntypes)*rhoe(ntypes)
      else
         do 1 i=1,27
1        read(10,*)vtmp
         goto 11
      endif
      close(10)
      goto 10
1210  write(6,*)'error: atom type ',atomtype,' not found'
      stop
1200  continue
      nr=20000+1
      nrho=20000+1
      alatmax=blat(1)
      rhoemax=rhoe(1)
      do 2 i=2,ntypes
         if (alatmax .lt. blat(i)) alatmax=blat(i)
         if (rhoemax .lt. rhoe(i)) rhoemax=rhoe(i)
2     continue
      rc=sqrt(10.0d0)/2.0d0*alatmax
      rst=0.5d0
      dr=rc/(nr-1.0d0)
      fmax=-1.0d0
      do 3 i1=1,ntypes
      do 3 i2=1,i1
      if ( i1 .eq. i2) then
         do 4 i=1,nr
            r=(i-1)*dr
            if (r .lt. rst) r=rst
            call prof(i1,r,fvalue)
            if (fmax .lt. fvalue) fmax=fvalue
            rhor(i,i1)=fvalue
            call pair(i1,i2,r,psi)
            z2r(i,i1,i2)=r*psi
4        continue
      else
         do 5 i=1,nr
            r=(i-1)*dr
            if (r .lt. rst) r=rst
            call pair(i1,i2,r,psi)
            z2r(i,i1,i2)=r*psi
            z2r(i,i2,i1)=z2r(i,i1,i2)
5        continue
      endif
3     continue
      rhom=fmax
      if (rhom .lt. 2.0d0*rhoemax) rhom=2.0d0*rhoemax
      if (rhom .lt. 100.0d0) rhom=100.0d0
      drho=rhom/(nrho-1.0d0)
      do 6 it=1,ntypes
      do 7 i=1,nrho
         rhoF=(i-1)*drho
         if (i .eq. 1) rhoF=0.0d0
         call embed(it,rhoF,emb)
         Fr(i,it)=emb
7     continue
6     continue
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c This subroutine calculates the electron density.                c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine prof(it,r,f)
      implicit real*8 (a-h,o-z)
      implicit integer*8 (i-m)
      common /pass1/ re(16),fe(16),rhoe(16),alpha(16),
     *   beta(16),beta1(16),A(16),B(16),cai(16),ramda(16),
     *   ramda1(16),Fi0(16),Fi1(16),Fi2(16),Fi3(16),
     *   Fm0(16),Fm1(16),Fm2(16),Fm3(16),Fm4(16),
     *   fnn(16),Fn(16),rhoin(16),rhoout(16),rhol(16),
     *   rhoh(16),rhos(16)
      f=fe(it)*exp(-beta1(it)*(r/re(it)-1.0d0))
      f=f/(1.0d0+(r/re(it)-ramda1(it))**20)
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c This subroutine calculates the pair potential.                  c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine pair(it1,it2,r,psi)
      implicit real*8 (a-h,o-z)
      implicit integer*8 (i-m)
      common /pass1/ re(16),fe(16),rhoe(16),alpha(16),
     *   beta(16),beta1(16),A(16),B(16),cai(16),ramda(16),
     *   ramda1(16),Fi0(16),Fi1(16),Fi2(16),Fi3(16),
     *   Fm0(16),Fm1(16),Fm2(16),Fm3(16),Fm4(16),
     *   fnn(16),Fn(16),rhoin(16),rhoout(16),rhol(16),
     *   rhoh(16),rhos(16)
      if (it1 .eq. it2) then
         psi1=A(it1)*exp(-alpha(it1)*(r/re(it1)-1.0d0))
         psi1=psi1/(1.0d0+(r/re(it1)-cai(it1))**20)
         psi2=B(it1)*exp(-beta(it1)*(r/re(it1)-1.0d0))
         psi2=psi2/(1.0d0+(r/re(it1)-ramda(it1))**20)
         psi=psi1-psi2
      else
         psi1=A(it1)*exp(-alpha(it1)*(r/re(it1)-1.0d0))
         psi1=psi1/(1.0d0+(r/re(it1)-cai(it1))**20)
         psi2=B(it1)*exp(-beta(it1)*(r/re(it1)-1.0d0))
         psi2=psi2/(1.0d0+(r/re(it1)-ramda(it1))**20)
         psia=psi1-psi2
         psi1=A(it2)*exp(-alpha(it2)*(r/re(it2)-1.0d0))
         psi1=psi1/(1.0d0+(r/re(it2)-cai(it2))**20)
         psi2=B(it2)*exp(-beta(it2)*(r/re(it2)-1.0d0))
         psi2=psi2/(1.0d0+(r/re(it2)-ramda(it2))**20)
         psib=psi1-psi2
         call prof(it1,r,f1)
         call prof(it2,r,f2)
         psi=0.5d0*(f2/f1*psia+f1/f2*psib)
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c This subroutine calculates the embedding energy.                c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine embed(it,rho,emb)
      implicit real*8 (a-h,o-z)
      implicit integer*8 (i-m)
      common /pass1/ re(16),fe(16),rhoe(16),alpha(16),
     *   beta(16),beta1(16),A(16),B(16),cai(16),ramda(16),
     *   ramda1(16),Fi0(16),Fi1(16),Fi2(16),Fi3(16),
     *   Fm0(16),Fm1(16),Fm2(16),Fm3(16),Fm4(16),
     *   fnn(16),Fn(16),rhoin(16),rhoout(16),rhol(16),
     *   rhoh(16),rhos(16)
      if (rho .lt. rhoe(it)) then
         Fm33=Fm3(it)
      else 
         Fm33=Fm4(it)
      endif
      if (rho .eq. 0.0d0) then
        emb = 0.0d0
      else if (rho .lt. rhoin(it)) then
         emb=Fi0(it)+
     *       Fi1(it)*(rho/rhoin(it)-1.0d0)+
     *       Fi2(it)*(rho/rhoin(it)-1.0d0)**2+
     *       Fi3(it)*(rho/rhoin(it)-1.0d0)**3
      else if (rho .lt. rhoout(it)) then
         emb=Fm0(it)+
     *       Fm1(it)*(rho/rhoe(it)-1.0d0)+
     *       Fm2(it)*(rho/rhoe(it)-1.0d0)**2+
     *       Fm33*(rho/rhoe(it)-1.0d0)**3
      else
         emb=Fn(it)*(1.0d0-fnn(it)*log(rho/rhos(it)))*
     *       (rho/rhos(it))**fnn(it)
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write out set file.                                             c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine writeset
      implicit real*8 (a-h,o-z)
      implicit integer*8 (i-m)
      character*80 outfile,outelem
      common /pass1/ re(16),fe(16),rhoe(16),alpha(16),
     *   beta(16),beta1(16),A(16),B(16),cai(16),ramda(16),
     *   ramda1(16),Fi0(16),Fi1(16),Fi2(16),Fi3(16),
     *   Fm0(16),Fm1(16),Fm2(16),Fm3(16),Fm4(16),
     *   fnn(16),Fn(16),rhoin(16),rhoout(16),rhol(16),
     *   rhoh(16),rhos(16)
      common /pass2/ amass(16),Fr(50001,16),rhor(50001,16),
     *   z2r(50001,16,16),blat(16),drho,dr,rc,outfile,outelem
      common /pass3/ ielement(16),ntypes,nrho,nr
      character*80 struc
      character(2) :: str1
      character(2) :: str2
      character*80 outelemxx
      struc='fcc'
c      write(1,*) ' DATE: 2018-03-30 ',
c     *   'CONTRIBUTOR: Xiaowang Zhou xzhou@sandia.gov and ',
c     *   'Lucas Hale lucas.hale@nist.gov ',
c     *   'CITATION: X. W. Zhou, R. A. Johnson, ',
c     *   'H. N. G. Wadley, Phys. Rev. B, 69, 144113(2004)'
c      write(1,*) ' Generated from Zhou04_create_v2.f'
c      write(1,*) ' Fixes precision issues with older version'
c      write(1,8)ntypes,outelem
c8     format(i5,' ',a24)
c      write(1,9)nrho,drho,nr,dr,rc
c9     format(i5,e24.16,i5,2e24.16)

      outelemxx = outfile(1:index(outfile,' ')-1)
      do 13 i1=1,ntypes
      do 13 i2=1,ntypes
      
c      write(str1, '(I0)') ielement(i1)
c      write(str2, '(I0)') ielement(i2)
      str1 = outelemxx((i1-1)*2+1:(i1-1)*2+2)
      str2 = outelemxx((i2-1)*2+1:(i2-1)*2+2)
      
c      outfile = outfile(1:index(outfile,' ')-1)//'_Zhou04.eam.alloy'
c      outfile = 'atn-'//str1//'-'//str2//'_Zhou04.eam.alloy'
      outfile = str1//'-'//str2//'_Zhou04.eam.alloy'
      open(unit=1,file=outfile)
      
      write(1,*) 'DATE: 2018-03-30 ',
     * 'CITATION: X. W. Zhou et al., Phys. Rev. B, 69, 144113(2004).'
      
      write(1,11) ielement(i1),amass(i1),blat(i1)
11    format(i4,2g15.5)
      
      write(1,9) dr,drho,rc,(nrho-1)
9     format(e24.16,"  ",e24.16,"  ",e24.16,"   ",i5)
      
      drho1 = (rhor(j+1,i1) - rhor(1,i1))/dr
      drho2 = (rhor(j+1,i2) - rhor(1,i2))/dr
      write(1,12) rhor(1,i1),0.0, rhor(1,i2),0.0
      do 21 j=2,(nr-1)
      drho1 = (rhor(j+1,i1) - rhor(j-1,i1))/(2.0*dr)
      drho2 = (rhor(j+1,i2) - rhor(j-1,i2))/(2.0*dr)
      write(1,12) rhor(j,i1),drho1, rhor(j,i2),drho2
21    continue
      
c for j=1
      j=3
      dj3z2r1 = ( z2r(j+1,i1,i1)/((j+1-1)*dr)
     * - z2r(j,i1,i1)/((j-1)*dr))/dr
      dj3z2r2 = ( z2r(j+1,i1,i2)/((j+1-1)*dr)
     * - z2r(j,i1,i2)/((j-1)*dr))/dr
c for j=2
      j=2
      dz2r1 = ( z2r(j+1,i1,i1)/((j+1-1)*dr)
     * - z2r(j,i1,i1)/((j-1)*dr))/dr
      dz2r2 = ( z2r(j+1,i1,i2)/((j+1-1)*dr)
     * - z2r(j,i1,i2)/((j-1)*dr))/dr
c j=1
      write(1,12) z2r(j,i1,i1)/((j-1)*dr)-(2.0*dz2r1-dj3z2r1)*dr, 
     * 2.0*dz2r1-dj3z2r1,
     * z2r(j,i1,i2)/((j-1)*dr)-(2.0*dz2r2-dj3z2r2)*dr, 
     * 2.0*dz2r2-dj3z2r2
c      write(1,12) 0.0,0.0, 0.0,0.0
c j=2
      write(1,12) z2r(j,i1,i1)/((j-1)*dr), dz2r1,
     * z2r(j,i1,i2)/((j-1)*dr), dz2r2
c      write(1,12) 0.0,0.0, 0.0,0.0
c j>=3
      do 22 j=3,(nr-1)
      dz2r1 = ( z2r(j+1,i1,i1)/((j+1-1)*dr)
     * - z2r(j-1,i1,i1)/((j-1-1)*dr))/(2.0*dr)
      dz2r2 = ( z2r(j+1,i1,i2)/((j+1-1)*dr)
     * - z2r(j-1,i1,i2)/((j-1-1)*dr))/(2.0*dr)
      write(1,12) z2r(j,i1,i1)/((j-1)*dr), dz2r1,
     * z2r(j,i1,i2)/((j-1)*dr), dz2r2
22    continue
      
      dFr1 = (Fr(j+1,i1) - Fr(1,i1))/drho
      dFr2 = (Fr(j+1,i2) - Fr(1,i2))/drho
      write(1,12) Fr(1,i1),dFr1, Fr(1,i2),dFr2
c      write(1,12) 0.0,0.0, 0.0,0.0
      
      do 23 j=2,(nrho-1)
      dFr1 = (Fr(j+1,i1) - Fr(j-1,i1))/(2.0*drho)
      dFr2 = (Fr(j+1,i2) - Fr(j-1,i2))/(2.0*drho)
      write(1,12) Fr(j,i1),dFr1, Fr(j,i2),dFr2
23    continue
      
12    format(e24.16,"  ",e24.16,"  ",e24.16,"  ",e24.16)
      
      close(1)
13    continue
      
      return
      end
