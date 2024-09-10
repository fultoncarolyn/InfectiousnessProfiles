# Infectiousness Profiles
## Research project between Carolyn Fulton and Stephen Kissler exploring how heterogeniety in individual infectiousness profiles (timing and intensity) may impact epidemic trajectories.

### Code Guide

See makefile.R to run all necessary code to produce a plot comparing stochastic trajectories (dependent on the infectiousness profile) to the analytical solution to the SIR ODE system.

CompareProfiles.R -> Plots comparison between specified stochastic and analytical models
delta_sim.R -> Simulates infectiousness as a delta spiking function
odeSIR.R -> Simulates SIR ODE model for analytical solution

Note: Exponential Decay and On/Off infectiousness regimes are work in progress as of 9/10/2024
