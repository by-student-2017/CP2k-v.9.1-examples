  &DFT
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    
    &MGRID
      COMMENSURATE # this keyword is required for QMMM with GEEP
      CUTOFF 150
    &END MGRID
    
    &QS
      EPS_DEFAULT 1.0E-10 # 1.0E-6 - 1.0E-12
      METHOD GPW ! GAPW, GPW, LRIGPW, RIGPW, OFGPW
      #
      #METHOD PM6                 # Semi-empirical method based on Hartree-Fock
      #EXTRAPOLATION ASPC
      #EXTRAPOLATION_ORDER 3
      #&SE
      #  &COULOMB
      #    CUTOFF [angstrom] 20.0
      #  &END
      #  &EXCHANGE
      #    CUTOFF [angstrom] 20.0
      #  &END
      #&END SE
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
      #&OT
      #  PRECONDITIONER NONE
      #  MINIMIZER DIIS
      #  N_DIIS 7
      #&END
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
    
    #&POISSON
    #  PERIODIC NONE           # no interaction between replica
    #  POISSON_SOLVER WAVELET 
    #  &WAVELET
    #    SCF_TYPE 60
    #  &END WAVELET
    #&END POISSON
    
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
    #&EXTERNAL_POTENTIAL
    #  FUNCTION (A/B)*Z
    #  VALUES [eV] 0.2 [angstrom] 1.0
    #  PARAMETERS A B
    #&END EXTERNAL_POTENTIAL
  &END DFT

  #&SUBSYS
  #  &CELL
  #    ABC 37.8 37.8 50.0
  #    PERIODIC NONE
  #  &END CELL
  #  &TOPOLOGY
  #    COORD_FILE_NAME QM_region.xyz
  #    COORDINATE xyz
  #    &CENTER_COORDINATES
  #    &END
  #  &END
  #&END SUBSYS