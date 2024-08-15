  &DFT
    CHARGE 0
    &QS
      METHOD PM6
      &SE
         &COULOMB
           CUTOFF [angstrom] 12.0
         &END
         &EXCHANGE
           CUTOFF [angstrom] 12.0
         &END
      &END
    &END QS
    &SCF
      MAX_SCF 30
      EPS_SCF 1.0E-6
      SCF_GUESS ATOMIC
      &OT 
        MINIMIZER DIIS
        PRECONDITIONER FULL_SINGLE_INVERSE
      &END
      &OUTER_SCF
        EPS_SCF 1.0E-6
        MAX_SCF 10
      &END
      &PRINT
        &RESTART OFF
        &END
        &RESTART_HISTORY OFF
        &END
      &END
    &END SCF
  &END DFT
