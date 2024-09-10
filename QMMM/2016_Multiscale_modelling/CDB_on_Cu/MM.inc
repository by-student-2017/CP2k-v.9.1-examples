 &MM
    &FORCEFIELD
      
      &NONBONDED
        #&GENPOT
        #  atoms Cu H
        #  FUNCTION A*exp(-av*r)+B*exp(-ac*r)-C/(r^6)
        #  VARIABLES r
        #  PARAMETERS A av B ac C
        #  VALUES 0.878363 1.33747 24.594164 2.206825 21.32834305207502214234
        #  RCUT 15
        #&END GENPOT
        #&GENPOT
        #  atoms Cu C
        #  FUNCTION A*exp(-av*r)+B*exp(-ac*r)-C/(r^6)
        #  VARIABLES r
        #  PARAMETERS A av B ac C
        #  VALUES 4.13643 1.33747 115.82004 2.206825 75.40708524085266692113
        #  RCUT  15
        #&END GENPOT
        
        &LENNARD-JONES
          ATOMS Cu H
          EPSILON 0.084
          SIGMA 2.5
          RCUT 10.0
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Cu C
          EPSILON 0.105
          SIGMA 3.0
          RCUT 10.0
        &END LENNARD-JONES
        
        &LENNARD-JONES
          ATOMS Cu N
          EPSILON 0.0103
          SIGMA 3.31
          RCUT 10.0
        &END LENNARD-JONES
        &LENNARD-JONES
          ATOMS Cu O
          EPSILON 0.0067
          SIGMA 3.02
          RCUT 10.0
        &END LENNARD-JONES
        
        #Note: Since FCC has a close-packed structure, 
        # the structure can be adequately reproduced using the Lennard-Jones potential.
        &LENNARD-JONES
          ATOMS Cu Cu
          EPSILON 0.167
          SIGMA 2.338
          RCUT 10.0
        &END LENNARD-JONES
        
        #&EAM # embedded atom for Cu-Cu interaction
        #  atoms Cu Cu
        #  #PARM_FILE_NAME CU.pot
        #  PARM_FILE_NAME Cu-Cu_Zhou04.eam.alloy
        #&END EAM
      &END NONBONDED
      
      # When it is long distance and can be ignored (The terms with missing parameters will be treated as zero). 
      IGNORE_MISSING_CRITICAL_PARAMS .TRUE.
      
      # EAM case
      &SPLINE
        EPS_SPLINE 1.0E-7
        EMAX_SPLINE 0.9e2
      &END SPLINE
      #
    &END FORCEFIELD
    
    &POISSON
      &EWALD
        EWALD_TYPE spme
        ALPHA .44
        GMAX  40
      &END EWALD
    &END POISSON
  &END MM
