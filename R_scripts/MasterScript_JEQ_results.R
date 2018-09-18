##################################################################################
### An overarching script to load in modelled and measured results required    ###
### by the Robertson et al (2017) paper published in JEQ looking at ag         ###
### productivity and soil carbon stocks in response to cropping intensity and  ###
### climate change.                                                            ###
##################################################################################

################################################################################
### OPTIONAL - RUN ALL SIMULATIONS AT ALL SITES/SLOPES/TREATMENTS UP TO 2009 ###
################################################################################

# NOTE - This must be performed while running R in Linux. Windows and Mac will not work!!!

#library(parallel)
#library(foreach)

#filelist=list("./ste_all_lx.sh","./str_all_lx.sh","./wal_all_lx.sh") # List of shell scripts to batch run DayCent and save outputs to correct destination folders

#no_cores = length(filelist) # Cores used for parallelization
#ptm = proc.time()

#if(Sys.info()["sysname"]=="Windows"){
#  print("Simulations only possible on Linux OS")
#} else{
#  library(doMC)
#  registerDoMC(no_cores)
#  setwd("/media/andy/Modelling/DAP_files/")
#}

#returnComputation = 
#  foreach(x=filelist) %dopar%{
#    system(x, intern = F) # Re-run all model simulations and generate output files
#  }

#proc.time() - ptm # Check how long the sims took!

rm(list=ls()) # Clear R environment

### LOAD LIBRARIES
library(RCurl)
library(plyr)
library(dplyr)
library(data.table)
library(reshape2)
library(Rcpp)
library(ggplot2)
library(grid)
library(jsonlite)
library(magrittr) # Only needed for sensitivity analysis plotting

dodge = position_dodge(width=0.9)

### ASSIGN DIRECTORY LOCATIONS BASED ON OS
if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")}

source(file.path(fundir, "RFunctions.R")) # Load functions

### BEGIN ANALYSIS

#####################
# COMPARING CLIMATE #
#####################

read.DC(file.path(resdir, "LAI_LX_Outputs")) # IMPORT ALL DAYCENT OUTPUTS FROM SIMS UP TO 2009
source(file.path(scriptdir, "clim_compare.R")) # COMPARE MEASURED AND MODELLED CLIMATE DATA UP TO 2009

####################
# COMPARING YIELDS #
####################

read.DC(file.path(resdir, "LAI_LX_Outputs")) # IMPORT ALL DAYCENT OUTPUTS FROM SIMS UP TO 2009

# NOTE - The prep file below only needs re-running if the simulations have changed
source(file.path(scriptdir, "DC_yld_prep.R")) # CREATE THE MODELLED ANNUAL YIELD AND C INPUT OBJECT
# ONLY NEED TO RUN THESE LINES IF PREP FILE WAS RUN
if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations again (same as above)
source(file.path(fundir, "RFunctions.R")) # Functions need reloading
read.DC(file.path(resdir, "LAI_LX_Outputs")) # Import simulation results again

source(file.path(scriptdir, "DC_yields.R")) # COMPILE SIMULATED YIELD DATA FROM ALL SITES/SLOPES etc.

if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations again (same as above)
load(file.path(Robjsdir, "mod.raw.annuals")) # Reload the saved annual simulated C input values
load(file.path(Robjsdir, "mod.raw.slc")) # Reload the saved simulated soil carbon values

source(file.path(scriptdir, "DAP_yields.R")) # COMPILE SIMULATED YIELD DATA FROM ALL SITES/SLOPES etc.

source(file.path(scriptdir, "yld_calval.R")) # PRODUCE FIGURES THAT SHOW CALIBRATION AND VALIDATION USING ODD/EVEN YEARS (parameterisation performed outside R)

source(file.path(scriptdir, "Yield_figs_to09.R")) # PRODUCE FIGURES THAT SHOW COMPARISON OF MEASURED AND MODELLED YIELD DATA (1986-2009)

source(file.path(scriptdir, "Yield_tables_to09.R")) # PRODUCE TABLES OF MEASURED AND MODELLED YIELD DATA (1986-2009)

##############################################################
### FURTHER ANALYSIS REQUIRES 'FUTURE' SIMULATIONS AS WELL ###
# ----------- OPTIONALLY RE-RUN THE SIMULATIONS -------------#
##############################################################

# NOTE - This re-analysis can be done in R but it is highly recommended to run the R_RUN_FUTURE.R file from the Terminal
# To run from Terminal navigate to the script directory "cd '/media/andy/Modelling/DAP_files/R_scripts'" then batch run

# R CMD BATCH R_RUN_FUTURE.R
# THIS WILL TAKE UP TO AN HOUR!

source(file.path(scriptdir, "clim_future.R")) # PLOT CLIMATE DATA USED FOR FUTURE SIMULATIONS (>2009)

####################
# COMPARING SOIL C #
####################

source(file.path(scriptdir, "DAP_soilC.R")) # IMPORT, FORMAT AND SAVE MEASURED SOIL C (GRAPH TIMELINE meas-mod COMPARISON 2009)

source(file.path(scriptdir, "DC_cin_soil.R")) # CREATES AND SAVES ALL MODEL SIMULATION INFORMATION REPORTED IN LIS FILES (GRAPH 1to1 OF SOIL C)

###############################################
# GRAPHING FUTURE YIELDS AND C INPUTS TO SOIL #
###############################################

source(file.path(scriptdir, "Yield_figs_from09.R")) # PRODUCE FIGURES OF GRAIN AND STOVER YIELDS AFTER 2009 (VARIABILITY AND BY PHASE) 
# Note - could be annualized timeline if borrow code from create.gifs and estimate annualized for every 12 years

source(file.path(scriptdir, "Cin_figures_from09.R")) # PRODUCE FIGURES OF C INPUTS TO SOIL (AFTER 2009 ONLY)

source(file.path(scriptdir, "Yield_tables_from09.R")) # PRODUCE TABLES IN THE SAME FORMAT AS PRE-2009 ONES (see above)

#############################################################################################
# ESTIMATING SEQUESTRATION 'EFFICIENCY' AND PLOTTING CIN vs SOIL C UNDER DIFFERENT CLIMATES #
#############################################################################################

source(file.path(scriptdir, "SoilC_sequestration.R")) # PRODUCE FIGURES OF SEQUESTRATION EFFICIENCY AND BY PHASE

# NOTE - ImageMagick must be installed on your operating system before this will work!
#        Currently assumes a location of "C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" for windows
#        and a 'default' location for Linux. It may need specifying if these aren't correct.
# Depending on how many gifs created, this will take ~20 mins

#load(file.path(Robjsdir, "all_data")) # Load in object required to plot future simulation data
source(file.path(scriptdir, "figure_gifs.R")) # CREATE GIF IMAGES OF THE C INPUTS vs SOC RELATIONSHIP OVER TIME (among others)

######################################
# COMPLIMENTARY SENSITIVITY ANALYSIS #
######################################

if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations again (same as above)
source(file.path(fundir, "RFunctions.R")) # Load functions again if needed
source(file.path(scriptdir, "LHC-sens-functions.R"))
source(file.path(scriptdir, "LHC-sens-constants.R"))

### BEFORE RUNNING YOU MUST FIRST RUN sens_lx.sh FROM THE TERMINAL IN LINUX
# This script will take a VERY long time to run (around 7 full days for 1024 sims) 
# depending on how many iterations (runs) are specified in LHC-sens-constants.R
source(file.path(scriptdir, "sens.R"))

source(file.path(scriptdir, "plot_sens.R")) # Create plots of the sensitivity results from above script
