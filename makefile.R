# makefile.R -> runs the order of necessary functions to compute comparison

#Introduce analytical ODE model
source("/Users/carolynfulton/InfectiousnessProfiles/odeSIR.R")

#Introduce various individual infectiousness profile regimes
source("/Users/carolynfulton/InfectiousnessProfiles/delta_sim.R")
  #more to come ...

#Introduce comparison/plotting functions
source("/Users/carolynfulton/InfectiousnessProfiles/CompareProfiles.R")

#Example output
  # Compare Delta Infectiousness (delta_sim) to SIR (odesir) with parameters:
  # beta = 0.75, gamma = 0.35, N = 1000, I0 = 1
  # using 5 simulations/iterates

CompareProfiles(delta_sim,odesir,5,0.75,0.35,1000,1)