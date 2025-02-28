  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME EMSL_BASIS_SETS
    LSD
    POTENTIAL_FILE_NAME POTENTIAL
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      &HF
        FRACTION 0.25
        &MEMORY
          MAX_MEMORY 10
        &END MEMORY
        &SCREENING
          EPS_SCHWARZ 1.0E-16
        &END SCREENING
      &END HF
      &XC_FUNCTIONAL PBE
        &PBE
          SCALE_C 1.0
          SCALE_X 0.75
        &END PBE
      &END XC_FUNCTIONAL
    &END XC
    !
    &QS
      EPS_DEFAULT 1.0E-12
      METHOD GAPW
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
      CUTOFF 250 # GAPW case
      REL_CUTOFF 50
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
        #STEPSIZE 1.4999999999999999E-01
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
