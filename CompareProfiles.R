# Plot Multiple Simulations for Individual Infectiousness Profiles
# Against Analytical (ODE) Solution

require(ggplot2)
require(reshape2)
library(deSolve)

#define function to plot simulated and analytical data
# inputs: stochastic -> individual infectiousness profile (ex. delta_simulation)
#         deterministic -> SIR ODE model (odesir from sir_model.R)
#         iterates -> number of stochastic simulations to perform
#         infrate -> beta (with dif name to keep it straight)
#         recrate -> gamma "
#         popsize -> N "
#         initinf -> I0 "

plotmulti <- function(stochastic, deterministic, iterates, infrate, recrate, popsize, initinf){
  sims = c()
  groups = c()
  
  analytic = deterministic(infrate, recrate, popsize, initinf) #compute the analytical solution
  
  #run iterates total simulations to plot against the analytical. Some sizing adjustments necessary
  for (i in 1:iterates){ 
    sim = stochastic(infrate, recrate, popsize, initinf) # run a simulation from stochastic regime
    simwithna = c(sim, rep(NA, times = popsize - length(sim))) # add NA to end of sim to fill length to popsize
    sims <- c(sims, simwithna) # create vector of simulations that contain NA
    name = paste0("group_", i)
    group = rep(name, times = popsize)
    groups <- c(groups, group)
  }
  
  #df1 contains all simulation data
  df1 = data.frame(pop = c(rep(1:popsize,times = iterates)), # number of the population infected
                   sims, # timing of infection
                   groups) # labels
  
  #df2 contains analytical data
  df2 = data.frame(pop = analytic[1:popsize,5], # cumulative infection/incidence data
                   sims = analytic[1:popsize,1], # timing
                   groups = c(rep("deterministic", times = popsize))) # labels
  
  # Plotting
  ggplot(df1, aes(x = sims, y = pop)) + geom_line(aes(color = groups)) + geom_line(data = df2) +xlab("Time (days)") + ylab("Infected (people)") + ggtitle("Cumulative Infections for Delta Profile")
  
}