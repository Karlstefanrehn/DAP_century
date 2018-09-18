# -------------------------------------------------------------------------#
### PLOTS FUTURE TEMPERATURE AND PRECIPITATION DATA USED FOR SIMULATIONS ###
# -------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

#################################################################################
### PRODUCING FIGURES TO REPRESENT THE CLIMATE VARIABILITY OF GCM SIMULATIONS ###
#################################################################################

### VARIABLES TO BE IMPORTED

lis_vars = c('rain', 'stemp', 'tave', 'cinput') # Have to have 'cinput' (a cumulative variable) to remove 'extended' years

### FUNCTION TO READ AND IMPORT LIS FILES (ONLY VARIABLES THAT CUMULATE OVER THE YEAR AND RESET ON JAN 1st)

read_lis_month <- function(lis_path, variables) {
  lis = read.table(lis_path, header=TRUE, skip=1)[, c('time',variables)]
  lis$year = floor(lis$time)
  lis$monthfrac = lis$time - lis$year
  lis = subset(lis, lis[,'cinput'] != 0) # This removes the first month of extended simulations by deleting any rows of cumulative columns where 0 is found
  lis$year[lis$monthfrac==0] = lis$year[lis$monthfrac==0]-1 # Month 0.0 is in fact December of the previous year
  lis$monthfrac[lis$monthfrac==0] = 1 # Month 0.0 is in fact December of the previous year
  lis$month = round(lis$monthfrac*12,0)
  lis = lis[complete.cases(lis$time),]
  return(lis)
}

##################### Main ######################################

main_dir = file.path(resdir,"LAI_LX_Future")

# This assumes that soil temperature, rainfall and air temperature are all the same for a given site, regardless of soil and treatment. This is not quite true but discrepency should be less than 0.1 degC

site_list = c("Sterling", "Stratton", "Walsh")
site_list2 = c("ste", "str", "wal")

RCP_list = c("RCP45", "RCP85")
GCM_list = c("CNRM","CSIRO","GFDL_ESM2G","HadGEM2_CC","HadGEM2_ES","IPSL_CM5BLR","MIROC5","MIROC_CHEM","MRI_CGCM3","bcc_csm11m","bcc_csm11","CanESM2","BNU","inmcm4","GFDL_ESM2M","IPSL_CM5ALR")


### NOTE THIS WILL TAKE A FEW MINUTES TO DO ALL FUTURE SIMS

dflist = list() # Create empty list to put dataframes into
dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(site_list)*length(RCP_list)*length(GCM_list) # Maximum length of loop iterations to enable % complete display

for(site in site_list){
  for (RCP in RCP_list){
    for (GCM in GCM_list){
      site2 = site_list2[which(site_list==site)]
      lis_file_name = paste(site2, "_side_", GCM, "_grass.lis", sep="") # Grass is chosen as the managements are identical from 1985 to 2100 limiting any issues with soil temperature
      lis_path = file.path(main_dir, site, "Grass", RCP, lis_file_name)
      if(file.exists(lis_path)) { # Only try to import if the file exists!
        lis = read_lis_month(lis_path, variables = lis_vars) # Import lis file but only selected variables
        if(nrow(subset(lis,lis$year>=1985))>12) { # Ensure the simulation worked for at least the first 12-year phase
          if(site == "Sterling"){
            lis$ref.rain = 44/12
            lis$ref.stemp = 11.9
            lis$ref.tave = 9.3
          }
          if(site == "Stratton"){
            lis$ref.rain = 41.5/12
            lis$ref.stemp = 12.0
            lis$ref.tave = 10.8
          }
          if(site == "Walsh"){
            lis$ref.rain = 39.5/12
            lis$ref.stemp = 14.5
            lis$ref.tave = 12.2
          }
          lis$site = site
          lis$GCM = GCM
          lis$RCP = RCP
          lis$date = ISOdatetime(lis$year, lis$month, 14,1,1,1, tz="UTC") # Include a date column using year and month
          cum_rain = within(lis, { # Calculate the cumulative rainfall (site variables aren't needed below but used for clarity)
            c.rain <- ave(rain, site, RCP, GCM, FUN = cumsum)
          })
          ref_rain = within(lis, { # Calculate the cumulative rainfall (site variables aren't needed below but used for clarity)
            r.rain <- ave(ref.rain, site, RCP, GCM, FUN = cumsum)
          })
          mavg_st = movingAverage(lis$stemp, 12, F) # This calculates moving average over that month and previous 11 (continuous throughout lis file)
          mavg_at = movingAverage(lis$tave, 12, F) # This calculates moving average over that month and previous 11 (continuous throughout lis file)
          lis = cbind(lis, c.rain=cum_rain$c.rain, r.rain=ref_rain$r.rain, a.stemp=mavg_st, a.tave=mavg_at) # Combine cumulative rain, and moving averages of soil temp and air temp
          df_name = paste(site,RCP,GCM,"fut",sep="_") # Get name for dataframe
          comment(lis) = paste(site,RCP,GCM,"fut",sep="_") # Assign it as a comment so name is saved when written to list
          dflist[[df_name]] <- lis # Write the lis file to the list of dataframes
          dummy = c(dummy,1) # Just used to calculate the progress of this loop
          iteration = ((length(dummy))-1)/iter.n*100 # Just used to calculate the progress of this loop
          print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
        }
      }
    }
  }
}

future_clim = rbindlist(dflist) # Convert the list of dataframes to a single rbind'ed dataframe

### PLOTTING FUTURE CLIMATE CHANGE!

# RAINFALL
# If we only care about cumulative rainfall after 2009 a new column is needed to subtract 2009 total

ste_09_rain = future_clim$c.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Sterling"][1]
str_09_rain = future_clim$c.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Stratton"][1]
wal_09_rain = future_clim$c.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Walsh"][1]

future_clim$d.rain[future_clim$site=="Sterling"] = future_clim$c.rain[future_clim$site=="Sterling"] - ste_09_rain
future_clim$d.rain[future_clim$site=="Stratton"] = future_clim$c.rain[future_clim$site=="Stratton"] - str_09_rain
future_clim$d.rain[future_clim$site=="Walsh"] = future_clim$c.rain[future_clim$site=="Walsh"] - wal_09_rain

# Also put a reference column in
ste_09_rain2 = future_clim$r.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Sterling"][1]
str_09_rain2 = future_clim$r.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Stratton"][1]
wal_09_rain2 = future_clim$r.rain[future_clim$year==2009&future_clim$month==12&future_clim$site=="Walsh"][1]

future_clim$r.rain[future_clim$site=="Sterling"] = future_clim$r.rain[future_clim$site=="Sterling"] - ste_09_rain2
future_clim$r.rain[future_clim$site=="Stratton"] = future_clim$r.rain[future_clim$site=="Stratton"] - str_09_rain2
future_clim$r.rain[future_clim$site=="Walsh"] = future_clim$r.rain[future_clim$site=="Walsh"] - wal_09_rain2

# Remove unwanted objects
rm(cum_rain,ref_rain,lis,temp1,temp2,temp3,crop_rotation2,d,df_name,dummy,GCM,
   iter.n,iteration,keep,lis_file_name,lis_rotation,obj1,obj2,
   obj_ste,obj_str,obj_wal,RCP,rows,s,s2p,site,site2,sitelist,slope,
   ste_09_rain, str_09_rain, wal_09_rain, ste_09_rain2, str_09_rain2, wal_09_rain2)

#####################################
##### PLOTS FOR PUBLICATION #########
#####################################
# Simple plot of climate (cumulative rainfall) variation according to GCMs between 2009 and 2100
p.GCM.rain = ggplot(future_clim[future_clim$year>2009,], aes(x=date)) +
  geom_line(aes(y=d.rain*10, colour=GCM)) +
  geom_line(aes(y=r.rain*10), linetype='dashed', size=1, alpha=0.75) +
  facet_wrap(~site*RCP, ncol=2) +
  scale_y_continuous(expand=c(0,0), limits=c(0,50000)) +
  scale_x_datetime(expand=c(0,0)) +
  ggtitle("Variation in Cumulative rainfall over time") +
  ylab(expression(paste("Cumulative Rainfall (mm)"))) +
  xlab(expression(paste("Time"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

# TEMPERATURE

p.GCM.stemp = ggplot(future_clim[future_clim$year>2009,], aes(x=date)) +
  geom_line(aes(y=a.stemp, colour=GCM)) +
  geom_line(aes(y=ref.stemp), linetype='dashed', size=1, alpha=0.75) +
  geom_smooth(aes(y=a.stemp), se=T) +
  facet_wrap(~site*RCP, ncol=2) +
  scale_y_continuous(expand=c(0,0), limits=c(0,27)) +
  scale_x_datetime(expand=c(0,0)) +
  ggtitle("Variation in monthly average soil temperature over time") +
  ylab(expression(paste("Soil temperature (deg C)"))) +
  xlab(expression(paste("Time"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

p.GCM.tave = ggplot(future_clim[future_clim$year>2009,], aes(x=date)) +
  geom_line(aes(y=a.tave, colour=GCM)) +
  geom_line(aes(y=ref.tave), linetype='dashed', size=1, alpha=0.75) +
  geom_smooth(aes(y=a.tave), se=T) +
  facet_wrap(~site*RCP, ncol=2) +
  scale_y_continuous(expand=c(0,0), limits=c(0,27)) +
  scale_x_datetime(expand=c(0,0)) +
  ggtitle("Variation in monthly average air temperature over time") +
  ylab(expression(paste("Air temperature (deg C)"))) +
  xlab(expression(paste("Time"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

ggsave(p.GCM.rain, file=file.path(figdir,"rainfall_variation.pdf"), width=300, height=350, units="mm")
ggsave(p.GCM.stemp, file=file.path(figdir,"soil_temp_variation.pdf"), width=400, height=350, units="mm")
ggsave(p.GCM.tave, file=file.path(figdir,"air_temp_variation.pdf"), width=400, height=350, units="mm")
