  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    LSD
    POTENTIAL_FILE_NAME POTENTIAL_UZH
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      &XC_FUNCTIONAL
         &HYB_GGA_XC_CAM_B3LYP
           _AC 0.81      
           _ALPHA 0.65   
           _BETA -0.46   
           _OMEGA 0.33   
         &END HYB_GGA_XC_CAM_B3LYP
      &END XC_FUNCTIONAL
      &HF
         FRACTION 1.0
         &HF_INFO ON
         &END
         &INTERACTION_POTENTIAL
            POTENTIAL_TYPE MIX_CL_TRUNC
            CUTOFF_RADIUS 4.5
            OMEGA 0.33
            SCALE_COULOMB 0.19
            SCALE_LONGRANGE 0.46
            T_C_G_DATA t_c_g.dat
         &END
         &SCREENING
           EPS_SCHWARZ 1.0E-10
           SCREEN_ON_INITIAL_P FALSE
         &END
      &END HF
      &vdW_POTENTIAL
          DISPERSION_FUNCTIONAL PAIR_POTENTIAL
          &PAIR_POTENTIAL
            TYPE DFTD3
            CALCULATE_C9_TERM .FALSE.
            PARAMETER_FILE_NAME dftd3.dat
            REFERENCE_FUNCTIONAL CAMB3LYP
          &END PAIR_POTENTIAL
      &END vdW_POTENTIAL
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
