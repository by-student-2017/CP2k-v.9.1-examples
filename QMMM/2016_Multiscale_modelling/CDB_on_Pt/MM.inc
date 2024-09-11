 &MM
    &FORCEFIELD
      
      &NONBONDED
        
&LENNARD-JONES		
  ATOMS	H	Pt
  EPSILON	0.059329588	
  SIGMA	2.512334385	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	C	Pt
  EPSILON	0.091651514	
  SIGMA	2.942193017	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	N	Pt
  EPSILON	0.074296702	
  SIGMA	2.857112189	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	O	Pt
  EPSILON	0.069282032	
  SIGMA	2.785840292	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	F	Pt
  EPSILON	0.063245553	
  SIGMA	2.725259179	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	P	Pt
  EPSILON	0.156204994	
  SIGMA	3.074046027	
  RCUT	10	
&END LENNARD-JONES		
		
&LENNARD-JONES		
  ATOMS	S	Pt
  EPSILON	0.148054044	
  SIGMA	3.024155699	
  RCUT	10	
&END LENNARD-JONES		

        
        #Note: Since FCC has a close-packed structure, 
        # the structure can be adequately reproduced using the Lennard-Jones potential.
        # FCC: Ca, Sr, Ph, Ir, Ni, Pd, Pt, Cu, Ag, Au, Al, Pb, Yb
        # Closely packed and ideal HCP elements: Mg, Co
        # Close-packed HCP elements with slightly smaller c/a: Be, Ti, Zr, Hf, Ru, Y, Gd
        # Elements in HCPs with close-packed c/a significantly higher than ideal (not recommended): Zn, Cd
&LENNARD-JONES		
  ATOMS	Pt	Pt
  EPSILON	0.08	
  SIGMA	2.45353507	
  RCUT	10	
&END LENNARD-JONES		

        
        #&EAM # embedded atom for Pt-Pt interaction
        #  atoms Pt Pt
        #  PARM_FILE_NAME ./EAM_potential/Pt-Pt_Zhou04.eam.alloy
        #&END EAM
        
      &END NONBONDED
      
      # When it is long distance and can be ignored (The terms with missing parameters will be treated as zero). 
      IGNORE_MISSING_CRITICAL_PARAMS .TRUE.
      
      # EAM case
      #&SPLINE
      #  EPS_SPLINE 1.0E-6 # 1.0E-6 - 1.0E-7
      #  EMAX_SPLINE 0.9e2 # 0.5 - 1.0
      #&END SPLINE
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
