###############################################################################################
### SENSITIVITY OF ALL SITES/SLOPES/TREATMENTS FOR SET VARIABLES USING MONTE CARLO ANALYSIS ###
###############################################################################################

### IMPORTANT!
### YOU MUST RUN THE "sens_lx.sh" SCRIPT ON COMMAND LINE BEFORE RUNNING THIS SCRIPT!
### The 'system("./sens_lx.sh") call below will no longer work because of an added prompt

#setwd("/media/andy/Modelling/DAP_files/")
#system("./sens_lx.sh")

# INSTEAD USE THE TERMINAL IN LINUX, NAVIGATE TO THE DAP_FILES DIRECTORY AND RUN THE BASH SCRIPT:
# cd "/media/andy/Modelling/DAP_files/"
# ./sens_lx.sh
# AFTER THE ABOVE 'setup' HAS BEEN RUN, ALL RELEVANT FILES AND FOLDERS ARE IN PLACE FOR THIS SCRIPT

#====================================================================
#### START MAIN PROGRAM:
#====================================================================
# Settings for the simulation runs:
#====================================================================
base_path = file.path(resdir, "LAI_Sensitivity")
testvars = c("global", "temp", "prec", "clay", "bulk", "ph")
uniquevars = c("temp", "prec", "clay", "bulk", "ph")
start_year = styr
end_year = enyr
svar = sensitivity_factor # Variability induced to calculate sensitivity (e.g. 0.2 is 20%)
runs = sens.sims
#====================================================================

# Set seed for reproducible random LHC sample
set.seed(2)

# Set min and max for variable ranges. Ranges are plus and minus 0.2 * value
clay.val = ste.sum.clay
clay.min = clay.val - (clay.val * svar)
clay.max = clay.val + (clay.val * svar)
silt.val = ste.sum.silt
sand.val = ste.sum.sand
bulk.val = ste.sum.bulk
bulk.min = bulk.val - (bulk.val * svar)
bulk.max = bulk.val + (bulk.val * svar)
ph.val = ste.sum.ph
ph.min = ph.val - (ph.val * svar)
ph.max = ph.val + (ph.val * svar)

sites = c("Sterling","Stratton","Walsh")
sites2 = c("ste","str","wal")
treatments = c("WF","WCF","WCMF","OPP","Grass")
treatments2 = c("wf","wcf","wcmf","opp","grass")
slopes = c("Summit","Side","Toe")
slopes2 = c("sum","sid","toe")

start_time = Sys.time()
progress = data.frame(var="start", time=start_time)
write.csv(progress,file=file.path(figdir,"Sensitivity Results", "progress.csv"))

for(site in sites){
  for(treat in treatments){
    for(slope in slopes){
      site2 = sites2[which(sites==site)]
      treat2 = treatments2[which(treatments==treat)]
      slope2 = slopes2[which(slopes==slope)]
      
      path=paste(base_path,site,treat,slope,sep="/")
      setwd(path)

      # Build LHC sample
      lcube = randomLHS(runs, length(uniquevars))
      
      # Set variables names on lcube
      colnames(lcube) = uniquevars
      
      # Convert soil variables to values to use as run inputs
      lcube[, "clay"] = clay.min + ((clay.max - clay.min) * lcube[, "clay"])
      lcube[, "bulk"] = bulk.min + ((bulk.max - bulk.min) * lcube[, "bulk"])
      lcube[, "ph"] = ph.min + ((ph.max - ph.min) * lcube[, "ph"])
      
      # Reverse sign on random selection of half of the samples for temp and prec
      # so an increase and decrease can be simulated
      
      rows = sample(1:nrow(lcube), nrow(lcube)/2) # Have to save row numbers to ensure numbers are overwritten
      lcube[c(rows),"temp"] = -lcube[c(rows),"temp"]
      rows = sample(1:nrow(lcube), nrow(lcube)/2) # Have to save row numbers to ensure numbers are overwritten
      lcube[c(rows),"prec"] = -lcube[c(rows),"prec"]
      
      # Rainfall and temperature changed by up to sensibility variability
      lcube[, "prec"] = lcube[, "prec"] * svar
      lcube[, "temp"] = lcube[, "temp"] * svar
      
      # Soil values in lcube are used as-is. Weather variables changed by the lcube percentages.
      # Soil texture inputs must sum to 1. Keep silt constant, and vary sand with clay.
      lcube = cbind(lcube, "silt" = silt.val, "sand" = 1 - (lcube[, "clay"] + silt.val))
      
      # change the climate file in folder
      climfile = paste("clim_base.txt", sep="")
      CLIM = read.table(climfile, header = FALSE, sep = "\t", colClasses = c(rep("integer", 4), rep("numeric", 3)))
      CLIM_BASE = read.table(climfile, header = FALSE, sep="\t", fill=TRUE)
      climout = paste(path, "sens.wth", sep = "/")
      
      # Write initial climate input file
      write.table(CLIM, climout, row.names = FALSE, col.names = FALSE)
      
      # change the soil file in folder
      soilfile = paste("soils_base.txt", sep = "")
      SOIL_list = read.table(soilfile)
      SOIL = matrix(as.numeric(unlist(SOIL_list)), nrow = nrow(SOIL_list), ncol = 13)
      SOIL_BASE = matrix(as.numeric(unlist(SOIL_list)), nrow = nrow(SOIL_list), ncol = 13)
      soilout = paste(path, "soils.in", sep = "/")
      
      # Write initial soil input file
      write.table(SOIL, soilout, row.names = FALSE, col.names = FALSE)
      
      # Set results file header
      header = c("sim",
                 "NPP",
                 "NEE",
                 "Biomass",
                 "RESP",
                 "Active",
                 "Slow",
                 "Passive",
                 "SOC",
                 "N2O",
                 "NO",
                 "N2",
                 "CH4",
                 "Tmax",
                 "Tmin",
                 "prec",
                 "pH",
                 "BD",
                 "clay")
      
      # Set up simulation loop
      for (sim_id in testvars) {
        if (sim_id == "global") {
          cat("Running global Monte Carlo simulation\n")
          } else {
            cat("Now running Monte Carlo simulations for variable ", sim_id, "\n", sep = "")
          }
        
        # Set name for results file
        outfile = paste("sensitivity-", sim_id, ".txt", sep = "")
        
        # Open results file and set to write mode
        dataout = file(outfile, "w")
        
        # Start writing results to table
        write.table(t(header), dataout, sep = "       ", append = FALSE, quote = FALSE, col.names = FALSE, row.names = FALSE)
  
        # Start main Monte Carlo simulation loop
        for (run_num in 1:runs){ 
          
          # Set temperature input
          if (sim_id == "temp") {
            CLIM[, 5] = CLIM_BASE[, 5]
            CLIM[, 6] = CLIM_BASE[, 6]
            } else {
              CLIM[, 5] = CLIM_BASE[, 5] * (1+lcube[run_num, "temp"])
              CLIM[, 6] = CLIM_BASE[, 6] * (1+lcube[run_num, "temp"])
            }
          Tmax = max(CLIM[, 5])
          Tmin = min(CLIM[, 6])
          
          # Set precipitation input
          if (sim_id == "prec") {
            CLIM[, 7] = CLIM_BASE[, 7]
            } else {
              CLIM[, 7] = CLIM_BASE[ ,7] * (1+lcube[run_num, "prec"])
            }
          
          # Convert negative values to zero, for zero precipitation
          CLIM[CLIM[, 7] < 0, 7] = 0
          prectot = sum(CLIM[, 7])
          
          # Set soil inputs
          if (sim_id == "ph") {
            SOIL[, 13] = SOIL_BASE[, 13]
            } else {
              SOIL[, 13] = lcube[run_num, "ph"]
            }
          ph = SOIL[1, 13]
          if (sim_id == "bulk") {
            SOIL[, 3] = SOIL_BASE[, 3]
            } else {
              SOIL[, 3] = lcube[run_num, "bulk"]
            }
          bulk = SOIL[1, 3]
          if (sim_id == "clay") {
            SOIL[, 9] = SOIL_BASE[, 9]
            SOIL[, 8] = SOIL_BASE[, 8]
            } else {
              SOIL[, 9] = lcube[run_num, "clay"]
              SOIL[, 8] = lcube[run_num, "sand"]
            }
          clay = SOIL[1, 9]
          
          # Write updated climate input file
          write.table(CLIM, climout, row.names = FALSE, col.names = FALSE)
          # Write updated soil input file
          write.table(SOIL, soilout, row.names = FALSE, col.names = FALSE)
          
          setwd(path)
          system(paste("./",treat2,".sh",sep=""))
          
          file_in = "dc_sip.csv"
          file_harv = "harvest.csv"
          file_ghg = "tgmonth.out"
          
          summary_out = get_data1(path = path, file = file_in, growth_fac = growth_fac)
          #harvest<-get_harvest(modelpath,file_harv,start_year,end_year)
          ghg = get_ghg1(path = path, file = file_ghg)
          #summary<-c(r,summary,harvest,ghg)
          
          summary_out = c(run_num, summary_out, ghg, Tmax, Tmin, prectot, ph, bulk, clay)
          # summary_out = c(summary_out, max(T_max), min(T_min), sum(prec), pH[1], BD[1], clay, sand)
          write.table(t(summary_out), dataout, sep = "\t", append = FALSE, quote = FALSE, col.names = FALSE, row.names = FALSE)
          
          cat("Run number ", run_num, " of ", runs, "\n",
              "Variable ", grep(sim_id, testvars), " of ", length(testvars), "\n",
              "Running ", treat,  " simulations at ", site, " ", slope, "s \n",
              sep = "")
        }   # End of Monte Carlo simulation loop
        
        # Close output file
        close(dataout)
        cat("Successful Monte Carlo simulation!\n")
      }   # End of simulation loop
      # End routine
      time = Sys.time()
      var = paste(site,treat,slope,sep="_")
      new_time = data.frame(var=var, time=time)
      progress = rbind(progress, new_time)
      write.csv(progress,file=file.path(figdir,"Sensitivity Results", "progress.csv"))
    }
    time = Sys.time()
    var = paste(site,treat,slope,sep="_")
    new_time = data.frame(var=var, time=time)
    progress = rbind(progress, new_time)
    write.csv(progress,file=file.path(figdir,"Sensitivity Results", "progress.csv"))
  }
  time = Sys.time()
  var = paste(site,treat,slope,sep="_")
  new_time = data.frame(var=var, time=time)
  progress = rbind(progress, new_time)
  write.csv(progress,file=file.path(figdir,"Sensitivity Results", "progress.csv"))
}

