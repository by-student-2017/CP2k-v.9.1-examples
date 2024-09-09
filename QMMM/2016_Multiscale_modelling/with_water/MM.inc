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
      
      # water (tip3p)
      &CHARGE
        ATOM Ow
        CHARGE -0.834
      &END CHARGE
      &CHARGE
        ATOM Hw
        CHARGE 0.417
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
        #
        # water (tip3p)
        &LENNARD-JONES
          ATOMS Ow Ow
          EPSILON [kcalmol] 0.102
          SIGMA [angstrom] 3.1507
        &END LENNARD-JONES
        #
        # UFF: https://pubs.acs.org/doi/10.1021/ja00051a040
        &LENNARD-JONES
          ATOMS Ow H
          EPSILON [kcalmol] 0.066992
          SIGMA [angstrom] 2.8609168
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Ow C
          EPSILON [kcalmol] 0.1034891
          SIGMA [angstrom] 3.29077548
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Ow N
          EPSILON [kcalmol] 0.0838927
          SIGMA [angstrom] 3.205694
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Ow O
          EPSILON [kcalmol] 0.0782304
          SIGMA [angstrom] 3.1344227
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Ow K
          EPSILON [kcalmol] 0.0597494
          SIGMA [angstrom] 3.2734029
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Ow Cl
          EPSILON [kcalmol] 0.1521643
          SIGMA [angstrom] 3.3335386
        &END LENNARD-JONES
      &END NONBONDED
      
      # When it is long distance and can be ignored (The terms with missing parameters will be treated as zero). 
      IGNORE_MISSING_CRITICAL_PARAMS .TRUE.
      
      #
      # EAM case
      &SPLINE
        EPS_SPLINE 1.0E-7
        EMAX_SPLINE 0.9e2
      &END SPLINE
      #
      #&EAM # embedded atom for Cu-Cu interaction
      #  atoms Cu Cu
      #  #PARM_FILE_NAME ${LIBDIR}/CU.pot
      #  PARM_FILE_NAME ${LIBDIR}/Cu-Cu_Zhou04.eam.alloy
      #&END EAM
    &END FORCEFIELD
    
    &POISSON
      &EWALD
        EWALD_TYPE spme
        ALPHA .44
        GMAX  40
      &END EWALD
    &END POISSON
  &END MM
