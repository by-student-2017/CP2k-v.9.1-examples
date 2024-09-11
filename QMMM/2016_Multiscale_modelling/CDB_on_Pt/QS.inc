  &DFT
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    
    ! Charge and multiplicity
    #CHARGE 0
    #MULTIPLICITY 1
    #LSD
    
    &MGRID
      COMMENSURATE # this keyword is required for QMMM with GEEP
      #
      ! PW cutoff ... depends on the element (basis) too small cutoffs lead to the eggbox effect.
      ! certain calculations (e.g. geometry optimization, vibrational frequencies,
      ! NPT and cell optimizations, need higher cutoffs)
      CUTOFF [Ry] 200 # 150 (22.6 GB), (<=200 in 32 GB system)
      REL_CUTOFF 30 # (default: 50), 60
      NGRIDS 4 # (default: 4), 5
    &END MGRID
    
    &QS
      # Accuracy of electron density convergence and matrix operations.
      EPS_DEFAULT 1.0E-6 # 1.0E-6 - 1.0E-12, 0.74E-9*[number of QM orbitals] (0.5E-4 meV/orbitals)
      METHOD GPW ! GAPW, GPW, LRIGPW, RIGPW, OFGPW
    &END QS
    
    &SCF
      EPS_SCF 1.0E-03 # default: 1.0E-05, 0.74E-04*[number of QM atoms] (PBE Accuracy: 1 meV/atoms)
      MAX_SCF 20 # 20 or 30
      SCF_GUESS ATOMIC
      #SCF_GUESS RESTART # restart case
      #
      # Often recommended for large systems
      &OT
        MINIMIZER CG
        PRECONDITIONER FULL_ALL
        #PRECONDITIONER FULL_SINGLE_INVERSE # In this case + EAM, it causes a SIGSEGV error.
        #ENERGY_GAP 0.001
        #STEPSIZE 0.2
      &END OT
      #
      # For small systems or when high accuracy is required.
      #&DIAGONALIZATION
      #  ALGORITHM STANDARD
      #&END DIAGONALIZATION
      #
      &MIXING T
        ALPHA 0.5 # 0.2 - 0.5
        METHOD PULAY_MIXING
        NPULAY 5
      &END MIXING
      #
      &OUTER_SCF
        #MAX_SCF 8
        EPS_SCF 1.0E-03 # default: 1.0E-05, 0.74E-04*[number of QM atoms] (PBE Accuracy: 1 meV/atoms)
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
    
    #&PRINT
    #  &MO_CUBES
    #    NLUMO 10
    #    WRITE_CUBE F
    #  &END MO_CUBES
    #  #&V_HARTREE_CUBE
    #  #    STRIDE 2 2 2
    #  #&END
    #&END PRINT
    
    &EXTERNAL_POTENTIAL
      FUNCTION (A/B)*Z
      VALUES [eV] 0.2 [angstrom] 1.0
      PARAMETERS A B
    &END EXTERNAL_POTENTIAL
  &END DFT
