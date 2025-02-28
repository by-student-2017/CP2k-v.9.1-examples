  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      &HF
        FRACTION 1.000
        &INTERACTION_POTENTIAL
          OMEGA 0.30
          POTENTIAL_TYPE MIX_CL
          SCALE_COULOMB 0.167
          SCALE_LONGRANGE 0.833
        &END INTERACTION_POTENTIAL
        &MEMORY
          MAX_MEMORY 10
        &END MEMORY
        &SCREENING
          EPS_SCHWARZ 1.0E-10
        &END SCREENING
      &END HF
      &VDW_POTENTIAL
        DISPERSION_FUNCTIONAL NON_LOCAL
        &NON_LOCAL
          CUTOFF 40
          KERNEL_FILE_NAME rVV10_kernel_table.dat
          PARAMETERS 6.3 0.0093
          SCALE 1.0
          TYPE RVV10
          VERBOSE_OUTPUT
        &END NON_LOCAL
      &END VDW_POTENTIAL
      &XC_FUNCTIONAL
        &HYB_GGA_XC_WB97X_V
        &END HYB_GGA_XC_WB97X_V
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
