  &MM
    &FORCEFIELD
      parm_file_name ${ROOT}/Files/mol_solv.top
      parmtype AMBER
      &SPLINE
       R0_NB [angstrom] 0.1
       RCUT_NB [angstrom] 9.0
       EMAX_SPLINE 10.0
      &END
    &END FORCEFIELD
    &POISSON
      &EWALD
        EWALD_TYPE spme
        ALPHA .4
        GMAX  54
        O_SPLINE 4
      &END EWALD
    &END POISSON
  &END MM
