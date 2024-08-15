  &MM
    &FORCEFIELD
      DO_NONBONDED .TRUE. # GPW case
      EI_SCALE14 1.0      # GPW case
      VDW_SCALE14 1.0     # GPW case
      parm_file_name ${ROOT}/Files/mol_solv.top
      parmtype AMBER
      &SPLINE
       R0_NB [angstrom] 0.1
       !RCUT_NB [angstrom] 9.0 # semi-empirical case
       RCUT_NB [angstrom] 12.0 # GPW case
       !EMAX_SPLINE 10.0 # semi-empirical case
       EMAX_SPLINE 1.0E14 # GPW case
      &END
    &END FORCEFIELD
    &POISSON
      &EWALD
        EWALD_TYPE spme
        ALPHA .4
        !GMAX  54 # semi-empirical case
        GMAX 80 # GPW case
        O_SPLINE 4
      &END EWALD
    &END POISSON
  &END MM
