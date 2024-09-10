# SIR ODE Model with Cumulative Infection compartment (C)
# Useful for CompareProfiles.R

library(deSolve)

odesir <- function(beta, gamma, N, I0){
  
  # Define function of model (ODEs)
  sir_model <- function(time, variables, parameters) {
    with(as.list(c(variables, parameters)), { 
      dS <- - (beta * I * S) / N
      dI <-  (beta * I * S) / N - gamma * I
      dR <-  gamma * I
      dC <- (beta * I * S) / N
      return(list(c(dS, dI, dR, dC)))
    })
  }
  
  # Define params
  parameters_values <- c(
    beta, # infectious contact rate (/person/day)
    gamma    # recovery rate (/day)
  )
  
  
  # Define init conds
  initial_values <- c(
    S = N - I0,  # number of susceptibles at time = 0
    I =   I0,  # number of infectious at time = 0
    R =   0,   # number of recovered (and immune) at time = 0
    C =   I0  # number of infectious at time = 0
  )
  
  # time structure using maximum value based on popsize to represent "infinity"
  maxinterval = N/10
  time_values <- seq(0, maxinterval, by = 0.1)
  
  # apply ode solver (ex. ode)
  sir_model_solve <- ode(
    y = initial_values,
    times = time_values,
    func = sir_model,
    parms = parameters_values 
  )
  
  newsir_model_solve <- as.data.frame(sir_model_solve) #restructure data frame
  
}
