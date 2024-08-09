  &MM
    &FORCEFIELD
      &CHARGE
         ATOM K
         CHARGE 1.0
      &END CHARGE
      &CHARGE
         ATOM Cl
         CHARGE -1.0
      &END CHARGE
      &NONBONDED
        &WILLIAMS
          atoms K   Cl
          A [eV] 4117.9
          B [angstrom^-1] 3.2808
          C [eV*angstrom^6] 0.0
          RCUT [angstrom] 3.0
        &END WILLIAMS
        &WILLIAMS
          atoms Cl  Cl
          A [eV] 1227.2
          B [angstrom^-1] 3.1114
          C [eV*angstrom^6] 124.0
          RCUT [angstrom] 3.0
        &END WILLIAMS
        &WILLIAMS
          atoms K   K
          A [eV] 3796.9
          B [angstrom^-1] 3.84172
          C [eV*angstrom^6] 124.0
          RCUT [angstrom] 3.0
        &END WILLIAMS
      &END NONBONDED
    &END FORCEFIELD
    &POISSON
      &EWALD
        EWALD_TYPE spme
        ALPHA .44
        GMAX  40
      &END EWALD
    &END POISSON
  &END MM