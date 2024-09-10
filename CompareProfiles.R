# Plot Multiple Simulations for Individual Infectiousness Profiles
# Against Analytical (ODE) Solution

require(ggplot2)
require(reshape2)
library(deSolve)

#define function to plot simulated and analytical data
# inputs: stochastic -> individual infectiousness profile (ex. delta_simulation from delta_sim.R)
#         deterministic -> SIR ODE model (odesir from odeSIR.R)
#         iterates -> number of stochastic simulations to perform
#         beta -> rate of infection
#         gamma -> rate of recovery
#         N -> population size
#         I0 -> initial infected population

CompareProfiles <- function(stochastic, deterministic, iterations, beta, gamma, N, I0){
  sims = c()
  groups = c()
  
  analytic = deterministic(beta, gamma, N, I0) #compute the analytical solution
  
  #run iterates total simulations to plot against the analytical. Some sizing adjustments necessary
  for (i in 1:iterations){ 
    sim = stochastic(beta, gamma, N, I0) # run a simulation from stochastic regime
    simwithna = c(sim, rep(NA, times = N - length(sim))) # add NA to end of sim to fill length to popsize
    sims <- c(sims, simwithna) # create vector of simulations that contain NA
    name = paste0("group_", i)
    group = rep(name, times = N)
    groups <- c(groups, group)
  }
  
  #df1 contains all simulation data
  df1 = data.frame(pop = c(rep(1:N,times = iterations)), # number of the population infected
                   sims, # timing of infection
                   groups) # labels
  
  #df2 contains analytical data
  df2 = data.frame(pop = analytic[1:N,5], # cumulative infection/incidence data
                   sims = analytic[1:N,1], # timing
                   groups = c(rep("deterministic", times = N))) # labels
  
  # Plotting
  ggplot(df1, aes(x = sims, y = pop)) + geom_line(aes(color = groups)) + geom_line(data = df2) +xlab("Time (days)") + ylab("Infected (people)") + ggtitle("Cumulative Infections for Delta Profile")
  
}