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
        _BETA -0.321208E+0
        _COS0 5.53261E-01
        _COS1 -1.16626E+00
        _COS2 6.84409E+00
        _COS3 -8.90640E+00
        _COS4 0.0E0
        _CSS0 1.15698e+00
        _CSS1 -3.31669e+00
        _CSS2 6.27265e+00
        _CSS3 -4.51464e+00
        _CSS4 0.0E0
        _CX0 2.51767e-01
        _CX1 1.57375e-00
        _CX2 -5.26624e+00
        _CX3 6.74313e+00
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
          SCALE_COULOMB 0.678792
          SCALE_LONGRANGE 0.321208
          # Adjust the cutoff radius according to your box sizes
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
            # A smaller cutoff can be used to save computation time
            CUTOFF  ${WFC_GPW_CUTOFF-300}
            REL_CUTOFF 50
          &END
         &END INTEGRALS
         SCALE_T  0.581569
         SCALE_S  0.477992
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
