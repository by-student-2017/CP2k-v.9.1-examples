  &DFT
    CHARGE 0
    !
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    !
    &XC
      &XC_FUNCTIONAL
       &HYB_GGA_XC_WB97X_D
        SCALE 1.0E+0
        _ALPHA 1.0E+0
        _BETA -0.363842E+0
        _COS0 5.18198e-01
        _COS1 -5.85956e-01
        _COS2  4.27080e+00
        _COS3 -6.48897e+00
        _COS4 0.0E0
        _CSS0 9.08460e-01
        _CSS1 -2.80936E+00
        _CSS2 6.02676E+00
        _CSS3 -4.56981E+00
        _CSS4 0.0E0
        _CX0 3.15503E-01
        _CX1 1.04772E+00
        _CX2  -2.33506E+00
        _CX3 3.19909E+00
        _CX4 0.0E0
        _OMEGA 3.00000000E-001
       &END HYB_GGA_XC_WB97X_D
      &END XC_FUNCTIONAL
      &HF
        &SCREENING
          EPS_SCHWARZ ${HF_EPS_SCHWARZ-1.0E-10}
        &END SCREENING
        &INTERACTION_POTENTIAL
          OMEGA 0.3
          POTENTIAL_TYPE ${MY_POTENTIAL_TYPE-MIX_CL}
          SCALE_COULOMB 0.636158
          SCALE_LONGRANGE 0.363842
          CUTOFF_RADIUS ${HF_CUTOFF_RADIUS-10.0}
        &END INTERACTION_POTENTIAL
      &END HF
      &WF_CORRELATION
        &RI_MP2
          BLOCK_SIZE 1
        &END RI_MP2
        &INTEGRALS
         ERI_METHOD GPW
          &WFC_GPW
            CUTOFF  ${WFC_GPW_CUTOFF-300}
            REL_CUTOFF 50
          &END
         &END INTEGRALS
         SCALE_T  0.529319
         SCALE_S  0.447105
      &END
    &END XC
    !
    &QS
      EPS_DEFAULT 1.0E-12
      METHOD GPW ! GPW, LRIGPW, RIGPW, OFGPW
    &END QS
    !
    &MGRID
      COMMENSURATE
      #NGRIDS 4
      CUTOFF 450 # (>=450)
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
