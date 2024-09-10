# GOAL: Create vectors to simulate
# {infection times}
# {individual tau value} 
# {0 or 1 denote accounted for}

# 1. Identify which values are unaccounted for (0) from V3
# 2. Select smallest value from V1 from that subset
#     if == then select smallest in V2 of the two
#     if == then randomly select?
# 3. Apply upsilon to generate new infections
# 4. Denote 1 on previous iteration index in V3
# 5. Tracking using iterates to indicate the individual index it came from (work in progress)
###############################################################################################

# Delta Infectiousness Profile Simulation

delta_sim <- function(beta, gamma, N, I){ 
  #population constraints
  S = N - I
  
  #define vectors
  vone = integer(I) #initial infected
  vtwo = rexp(N,gamma) #infectiousness profile timing
  inputthree = integer(I) #accounting vector
  vfour = integer(I) #tracking vector
  
  #initialize simulation for first step
  for (k in 1:N){
    if (k == 1){  
      vthree = inputthree
    } else { #and introduce looping of resulting vector(s)
      vthree = vthree
    }
    
    #define empty vectors
    unaccounted = c()
    match = c()
    comptau = c()
    contacts = c()
    mu = c()
    
    #select index to apply to next
    for (i in 1:length(vthree)){ 
      if (vthree[i] == 0){ # if vector at given index is zero then it has not yet been accounted for
        unaccounted[i] <- vone[i]
      } else {
        unaccounted[i] <- NA # if vector at given index is one/else then it has been accounted for
      }
      match <- which(unaccounted == min(unaccounted, na.rm=T)) #search of unaccounted which is next in time
      
      #NOTE: experiencing the following warning message(s) here with no effect on output
      #   In min(unaccounted, na.rm = T) :
      # no non-missing arguments to min; returning Inf
      
      #choose from unaccounted 
      if (length(match) > 1){
        for (i in match)
          comptau[i] <- vtwo[i]
        compmatch <- which(comptau == min(comptau, na.rm=T)) #utilize tau to determine who infects next if multiple choices
        if (length(compmatch) > 1){
          match <- sample(match,1)
          print(paste0("The next individual was selected randomly due to matching tau values."))
        } else {
          match <- compmatch
        }
      }
    }
    
    if (length(match) == 0){ #everyone has been accounted for
      break
    }
    if (length(vone) > N){ #exceeding population limit (stop())
      break
    }
    
    
    # begin the infection regime
    upsilon = rpois(1,beta/gamma) #number of contacts within the infectiousness period 
   
    if (upsilon == 0){
      #no new contacts
      contacts <- NA
    } else {
      for (j in 1:upsilon){ #iterate over that vector to determine which contacts "stick"
        mu[j] <- rbinom(1,1,S/N)
        ###print(paste0("The probability of transmission: ", mu[j], " for contact number: ", j," from individual index: ", match,"."))
        if (mu[j] == 0){
          #no new contacts
          contacts[j] <- NA
        } else {
          contacts[j] <- vone[match] + vtwo[match]
          S <- S - 1
          ###print(paste0("The remaining susceptible population ", S, "."))
        }
      }
    }
    
    contacts <- contacts[!is.na(contacts)] #remove any NA (not successful) contacts
    
    #new contacts are added onto vectors and accounting for process follows
    addcontacts = length(contacts)
    vone <- c(vone,contacts)
    vthree[match] <- 1
    vthree <- c(vthree,integer(addcontacts))
    keeptrack = rep(match, times = addcontacts)
    vfour <- c(vfour,keeptrack)
  }
  
  infections = sort(vone,decreasing = FALSE)
  print(infections)
}
