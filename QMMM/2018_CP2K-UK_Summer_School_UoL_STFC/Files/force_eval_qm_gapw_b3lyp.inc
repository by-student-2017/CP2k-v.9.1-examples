  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME EMSL_BASIS_SETS
    LSD
    POTENTIAL_FILE_NAME POTENTIAL
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      !
      &XC_FUNCTIONAL
        &BECKE88
          SCALE_X 0.72
        &END BECKE88
        &LYP
          SCALE_C 0.81
        &END LYP
        &VWN
          FUNCTIONAL_TYPE VWN5
          SCALE_C 0.19
        &END VWN
        &XALPHA
          SCALE_X 0.08
        &END XALPHA
      &END XC_FUNCTIONAL
      &HF
        FRACTION 0.20
        TREAT_LSD_IN_CORE TRUE
        &INTERACTION_POTENTIAL
          CUTOFF_RADIUS 6.0
          POTENTIAL_TYPE TRUNCATED
          T_C_G_DATA t_c_g.dat
        &END INTERACTION_POTENTIAL
        &MEMORY
          EPS_STORAGE_SCALING 0.1
          MAX_MEMORY 13000
        &END MEMORY
        &SCREENING
          EPS_SCHWARZ 1.0E-8
          SCREEN_ON_INITIAL_P TRUE
        &END SCREENING
      &END HF
      !
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
      CUTOFF 300 # GAPW case
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
