########################################################################################################
### OPTIONAL - RUN ALL FUTURE SIMULATIONS AT ALL SITES/SLOPES/TREATMENTS/RCP SCENARIOS FOR 1985-2100 ###
########################################################################################################

# Re-run all model simulations and generate output files

# LOAD LIBRARIES

library(parallel)

### RUNNING ALL SIMS IN PARALLEL

filelist=list("./ste_future45_lx.sh","./ste_future85_lx.sh","./str_future45_lx.sh","./str_future85_lx.sh","./wal_future45_lx.sh","./wal_future85_lx.sh")

no_cores = length(filelist)

if(Sys.info()["sysname"]=="Windows"){
  library(doParallel)
  cl=makeCluster(no_cores)
  registerDoParallel(cl)
} else{
  library(doMC)
  registerDoMC(no_cores)
}
library(foreach)

ptm = proc.time()

setwd("/media/andy/Modelling/DAP_files/")
returnComputation = 
  foreach(x=filelist) %dopar%{
    system(x, intern = F)
  }

proc.time() - ptm # To check how long the sims took!
