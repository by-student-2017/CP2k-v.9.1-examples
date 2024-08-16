  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      &XC_FUNCTIONAL
        &HYB_GGA_XC_WB97X_D3
        # "This setup incorporates D3 dispersion compensation." by Copilot
        # wB97X-D3 range-separated functional
        # https://manual.cp2k.org/trunk/CP2K_INPUT/ATOM/METHOD/XC/XC_FUNCTIONAL.html#cp2k-input-atom-method-xc-xc-functional-hyb-gga-xc-wb97x-d3
          SCALE   1.00000000E+000
          _ALPHA  1.00000000E+000
          _BETA  -8.04272000E-001
          _COS0   1.00000000E+000
          _COS1   2.43326600E+000
          _COS2  -1.54460080E+001
          _COS3   1.76443900E+001
          _COS4  -8.87949400E+000
          _CSS0   1.00000000E+000
          _CSS1  -4.86890200E+000
          _CSS2   2.12957260E+001
          _CSS3  -3.60208660E+001
          _CSS4   1.91770180E+001
          _CX0    8.04272000E-001
          _CX1    6.98900000E-001
          _CX2    5.08940000E-001
          _CX3   -3.74490300E+000
          _CX4    1.00607900E+001
          _OMEGA  2.50000000E-001
        &END HYB_GGA_XC_WB97X_D3
      &END XC_FUNCTIONAL
    &END XC
    !
    &QS
      EPS_DEFAULT 1.0E-12
      METHOD GPW ! GPW, LRIGPW, RIGPW, OFGPW
      !
      !METHOD PM6 # AM1, PM3, PM6, PM6-FM, PDG, RM1, PNNL, XTB
      !&SE
      !   &COULOMB
      !     CUTOFF [angstrom] 12.0
      !   &END
      !   &EXCHANGE
      !     CUTOFF [angstrom] 12.0
      !   &END
      !&END
    &END QS
    !
    !&POISSON                !Necessary to define POISSON section in non-perdiodic
    !  PERIODIC NONE        !boudary conditions as the default assumes PBCs
    !  POISSON_SOLVER MT
    !&END POISSON
    !
    &MGRID
      COMMENSURATE
      #NGRIDS 4
      CUTOFF 400 # GPW case
      REL_CUTOFF 60
    &END MGRID
    !
    &SCF  ! Parameters controlling the convergence of the scf. This section should not be changed.
      MAX_SCF 300 # semi-empirical case: 30
      EPS_SCF 1.0E-6
      SCF_GUESS ATOMIC
      ! SCF_GUESS RESTART
      !
      !&DIAGONALIZATION  ON
      !  ALGORITHM STANDARD
      !&END DIAGONALIZATION
      !
      !&MIXING  T
      !  METHOD BROYDEN_MIXING
      !  ALPHA 0.4
      !  NBROYDEN 8
      !&END MIXING
      !
      &OT 
        MINIMIZER DIIS
        ! PRECONDITIONER FULL_SINGLE_INVERSE # semi-empirical case
        PRECONDITIONER FULL_ALL
        STEPSIZE 1.4999999999999999E-01
      &END
      &OUTER_SCF
        EPS_SCF 1.0E-6
        MAX_SCF 10
      &END
      &PRINT
        &RESTART OFF
        &END
        &RESTART_HISTORY OFF
        &END
      &END
    &END SCF
  &END DFT
