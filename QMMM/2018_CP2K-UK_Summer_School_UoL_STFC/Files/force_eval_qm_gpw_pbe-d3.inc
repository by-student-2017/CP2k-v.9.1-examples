  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    !
    &XC                        ! Parameters needed to compute the electronic exchange potentia
      &VDW_POTENTIAL
        @IF ${VV10} == 1
        POTENTIAL_TYPE NON_LOCAL
        &NON_LOCAL
          KERNEL_FILE_NAME rVV10_kernel_table.dat
          TYPE RVV10
          VERBOSE_OUTPUT
        &END NON_LOCAL
        @ENDIF
        @IF ${D3} == 1
        POTENTIAL_TYPE PAIR_POTENTIAL
        &PAIR_POTENTIAL
          CALCULATE_C9_TERM .TRUE.
          EPS_CN 1.0E-6
          PARAMETER_FILE_NAME dftd3.dat
          REFERENCE_C9_TERM .TRUE.
          !          VERBOSE_OUTPUT .TRUE.
          REFERENCE_FUNCTIONAL PBE
          R_CUTOFF [angstrom] 16.
          TYPE DFTD3
        &END PAIR_POTENTIAL
        @ENDIF
      &END VDW_POTENTIAL
      &XC_FUNCTIONAL
        &PBE
        &END PBE
      &END XC_FUNCTIONAL
      &XC_GRID
        XC_DERIV NN50_SMOOTH
        XC_SMOOTH_RHO NN50
      &END XC_GRID
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
