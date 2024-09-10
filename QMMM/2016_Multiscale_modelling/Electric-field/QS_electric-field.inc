  &DFT
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    
    &MGRID
      COMMENSURATE # this keyword is required for QMMM with GEEP
      #
      ! PW cutoff ... depends on the element (basis) too small cutoffs lead to the eggbox effect.
      ! certain calculations (e.g. geometry optimization, vibrational frequencies,
      ! NPT and cell optimizations, need higher cutoffs)
      CUTOFF [Ry] 150 # 150 (22.6 GB)
      #REL_CUTOFF 50 # 60
      #NGRIDS 4 # 5
    &END MGRID
    
    &QS
      EPS_DEFAULT 1.0E-8 # 1.0E-6 - 1.0E-12
      METHOD GPW ! GAPW, GPW, LRIGPW, RIGPW, OFGPW
    &END QS
    
    &SCF
      EPS_SCF 1.0E-06 # default: 1.0E-05
      MAX_SCF 20 # 20 or 30
      SCF_GUESS ATOMIC
      #SCF_GUESS RESTART # restart case
      #
      &OT
        MINIMIZER CG
        PRECONDITIONER FULL_SINGLE_INVERSE
        #ENERGY_GAP 0.001
      &END OT
      #
      &OUTER_SCF
        #MAX_SCF 8
        EPS_SCF 1.0E-05 # default: 1.0E-05
      &END OUTER_SCF
      #
      #&PRINT
      #  &RESTART OFF
      #  &END
      #&END
    &END SCF
    
    &XC
      ! use a PBE functional 
      &XC_FUNCTIONAL PBE
      &END XC_FUNCTIONAL
      #
      ! adding Grimme's D3 correction (by default without C9 terms) 
      &VDW_POTENTIAL
         POTENTIAL_TYPE PAIR_POTENTIAL 
         &PAIR_POTENTIAL
            PARAMETER_FILE_NAME dftd3.dat
            TYPE DFTD3
            REFERENCE_FUNCTIONAL PBE
            R_CUTOFF [angstrom] 16
         &END
      &END VDW_POTENTIAL
    &END XC
    
    &PRINT
      &MO_CUBES
          NLUMO 10
          WRITE_CUBE F
      &END MO_CUBES
      #&V_HARTREE_CUBE
      #    STRIDE 2 2 2
      #&END
    &END PRINT
    
    &EXTERNAL_POTENTIAL
      #FUNCTION (A/B)*Z
      FUNCTION (A/B)*(Z-15.0/2.0)
      VALUES [eV] 0.2 [angstrom] 1.0
      PARAMETERS A B
    &END EXTERNAL_POTENTIAL
  &END DFT
