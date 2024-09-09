! how to propagate the system, selection via RUN_TYPE in the &GLOBAL section
&MOTION
 &GEO_OPT
   #TYPE MINIMIZATION ! for GEO_OPT
   MAX_DR    [bohr] 1.0E-03 ! adjust target as needed, e.g., 1.0E-01 or 0.003
   MAX_FORCE [hartree/bohr] 1.0E-04 ! 1.0E-03, 4.5E-4 or 1.0E-4
   RMS_DR    [bohr] 1.0E-03
   RMS_FORCE [hartree/bohr] 1.0E-03 ! 1.0E-03, 4.5E-4 or 1.0E-4
   MAX_ITER 500 # Maximum Iterations: 200 (BFGS), 300 (LBFGS) or 500 (CG)
   #
   #OPTIMIZER BFGS # CG, BFGS or LBFGS
   #OPTIMIZER BFGS ! Good choice for 'small' systems (use LBFGS for large systems)
   #&BFGS
   #  #RESTART_FILE_NAME restart.hess
   #  #RESTART_HESSIAN .TRUE.
   #  TRUST_RADIUS 0.25
   #  USE_MODEL_HESSIAN .TRUE.
   #  USE_RAT_FUN_OPT .FALSE.
   #&END BFGS
   #
   OPTIMIZER LBFGS
   &LBFGS
     MAX_F_PER_ITER 20
     MAX_H_RANK 5
     TRUST_RADIUS 0.25
     WANTED_PROJ_GRADIENT 1.0E-6
     WANTED_REL_F_ERROR 1.0E-6
   &END LBFGS
   #
   # https://www.cp2k.org/exercises:2015_cecam_tutorial:geometry_and_cell_optimization
   #OPTIMIZER CG
   #&CG
   #  MAX_STEEP_STEPS  0
   #  RESTART_LIMIT 9.0E-01
   #&END CG
   #
   &PRINT
   &END PRINT
  &END GEO_OPT
  &CELL_OPT
    #CONSTRAINT NONE
    #CONSTRAINT XY          # Fix x and y components
    CONSTRAINT Z            # Fix z component
    #KEEP_SPACE_GROUP .TRUE. # Preserve space group during optimization
    #KEEP_SYMMETRY .TRUE.    # Preserve initial cell symmetry
    #EPS_SYMMETRY 1.0E-4     # Accuracy of space group determination
    KEEP_ANGLES .TRUE.      # Fix angle between cell vectors
    EXTERNAL_PRESSURE  [bar] 0.0    # Specify the external pressure
    PRESSURE_TOLERANCE [bar] 1.0E-3 # Pressure Convergence Criteria
    #
    &PRINT
      &CELL
        &EACH
          CELL_OPT 1
        &END EACH
        ADD_LAST NUMERIC
      &END CELL
    &END PRINT
  &END CELL_OPT
  
  #&CONSTRAINT
  #  &FIXED_ATOMS
  #    COMPONENTS_TO_FIX XYZ
  #    LIST 529..672
  #    EXCLUDE_MM .FALSE.
  #    EXCLUDE_QM .TRUE.
  #  &END FIXED_ATOMS
  #&END CONSTRAINT
 
 &MD
   ENSEMBLE NVT
   TEMPERATURE [K] 300  ! The temperature in K used to initialize the velocities
   TIMESTEP [fs] 0.5    ! The length of an integration step
   STEPS 1000           ! The number of MD steps to perform 
   # GLE thermostat as generated at http://epfl-cosmo.github.io/gle4md 
   # GLE provides an effective NVT sampling.
   #----------------------------------------------------------------------------
   # URL: https://gle4md.org/index.html?page=matrix
   #  GLE type: Optimal sampling
   #  GLE options: Optimize Potential nrg, Ns/Range Ns=4, wmax/wmin=10^4
   #  w0 40 cm^-1
   #  Output format: CP2K input section
   #----------------------------------------------------------------------------
   # Generated at http://cosmo-epfl.github.io/gle4md 
   # Please cite: 
   # M. Ceriotti, G. Bussi and M. Parrinello, J. Chem. Theory Comput. 6, 1170 (2010) 
   # M. Ceriotti, G. Bussi and M. Parrinello, Phys. Rev. Lett. 102, 020601 (2009) 
   # Optimal-sampling GLE. Enforces efficient sampling of the potential energy 
   # by an appropriate colored noise. The parameters were picked from 
   # library/optimal/kv_4-4.a, 
   # and shifted so that they span a range between 
   # wmin=0.4 cm^-1 and wmax=4000 cm^-1 
   # Begins CP2K input section 
   #
   &THERMOSTAT
     REGION MASSIVE
     TYPE GLE
     &GLE
       NDIM 5
       A_SCALE [ps^-1] 1.00
       A_LIST    1.859575861256e+2   2.726385349840e-1   1.152610045461e+1  -3.641457826260e+1   2.317337581602e+2
       A_LIST   -2.780952471206e-1   8.595159180871e-5   7.218904801765e-1  -1.984453934386e-1   4.240925758342e-1
       A_LIST   -1.482580813121e+1  -7.218904801765e-1   1.359090212128e+0   5.149889628035e+0  -9.994926845099e+0
       A_LIST   -1.037218912688e+1   1.984453934386e-1  -5.149889628035e+0   2.666191089117e+1   1.150771549531e+1
       A_LIST    2.180134636042e+2  -4.240925758342e-1   9.994926845099e+0  -1.150771549531e+1   3.095839456559e+2
     &END GLE
   &END THERMOSTAT
   
   #ENSEMBLE NVT
   #STEPS 5000
   #TIMESTEP 0.5
   #TEMPERATURE 298
   #&THERMOSTAT
   #  TYPE CSVR
   #  REGION MOLECULE
   #  &CSVR
   #    TIMECON [fs] 50.
   #  &END CSVR
   #&END THERMOSTAT
   
   #ENSEMBLE NPT_I
   #STEPS 10000
   #TIMESTEP 0.5
   #TEMPERATURE 300
   #PRESSURE 1.0
 &END MD
 
 &PRINT
   &TRAJECTORY
     &EACH
       MD 1
     &END EACH
     FILENAME MDtraj
     FORMAT xyz # ATOMIC, DCD, DCD_ALIGNED_CELL, PDB, XMOL or XYZ
   &END TRAJECTORY
   &VELOCITIES OFF
   &END VELOCITIES
   &FORCES OFF
   &END FORCES
   &CELL
     &EACH
       MD 10
     &END EACH
     COMMON_ITERATION_LEVELS 3
   &END CELL
 &END PRINT
&END MOTION