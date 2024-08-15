  &MM
    &FORCEFIELD
      !DO_NONBONDED .TRUE.
      !EI_SCALE14 1.0
      !VDW_SCALE14 1.0
      parm_file_name ${ROOT}/Files/mol_solv.top
      parmtype AMBER
      &SPLINE
       R0_NB [angstrom] 0.1
       RCUT_NB [angstrom] 9.0
       EMAX_SPLINE 10.0 # semi-empirical case
       !EMAX_SPLINE 1.0E14 # GPW case
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
