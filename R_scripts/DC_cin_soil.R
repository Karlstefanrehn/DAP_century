# -------------------------------------------------------------------------------#
### LOADING BOTH 'HISTORIC' (1917 to 2009) AND 'FUTURE' (2010-2100) OUTPUTS OF ###
###   'CARBON INPUTS' AND SOIL C INTO R FROM LIS FILES - PLOTS AS A TIMELINE   ###
# -------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

### DEFINE VARIABLES TO BE IMPORTED

lis_vars = c('cinput','somtc','som2c.2.','abgdefac','petann','prcann','resp.1.','annet') 
# Suggested variables include: 'abgdefac','agcacc','cgrain','cinput','petann','prcann','resp.1.','somtc','som2c.2.' or annet (actual evapotranspiration)
# NOTE: AGCACC and CGRAIN are reset at the harvest date and not at the end of the year so read_lis_ann will not read these correctly in the current format
# Similarly, those variables that report monthly averages and not annual accumulators are not compatible with the function below (NOTE - This includes temperatures)

### FUNCTION TO READ AND IMPORT LIS FILES (ONLY VARIABLES THAT CUMULATE OVER THE YEAR AND RESET ON JAN 1st)
# Essentially does the same as the clim_future.R function but for annual accumulators

read_lis_ann <- function(lis_path, variables) {
  lis = read.table(lis_path, header=TRUE, skip=1)[, c('time',variables)]
  lis$year = floor(lis$time)
  lis$monthfrac = lis$time - lis$year
  lis = subset(lis, lis$monthfrac == 0.0) # Because 0.0 is chosen it is in fact the end of the previous year hence the last lines
  lis = subset(lis, lis[,c(lis_vars)] != 0) # This removes the first month of extended simulations by deleting any rows of cumulative columns where 0 is found
  lis = lis[complete.cases(lis$time),]
  lis$year = lis$year-1 # As above - this corrects the years read in because of using the 0.0 month fraction
  lis$time = lis$time-1 # As above - this corrects the years read in because of using the 0.0 month fraction
  return(lis)
}

##########
### FIRST - IMPORT THE 'HISTORIC' SIMULATION OUTPUTS
##########

main_dir = file.path(resdir, "LAI_LX_Outputs")

siteLIST = c("ste","str","wal")
slopeLIST = c("summit","side","toe")
treatLIST = c("wf","fw","wcf","cfw","fwc","wcmf","cmfw","mfwc","fwcm","opp","grass")

hist_data = data.frame() # Dataframe to put data in
df_list = list() # List to store data as separate list objects (dataframes)

dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(siteLIST)*length(slopeLIST)*length(treatLIST) # Maximum length of loop iterations to enable % complete display

for (site in siteLIST){
  for (slope in slopeLIST) {
    path = file.path(main_dir, paste(site,slope,"output",sep="_"))
    for (treat in treatLIST){
      lis_name = paste(site,"_",slope,"_",treat,".lis",sep="")
      lis_path = file.path(path,lis_name)
      if(file.exists(lis_path)) {
        lis = read_lis_ann(lis_path, variables = lis_vars)
        lis = lis[lis$year > 1900,] # REMOVE THE GRASSLAND THAT IS USED UP UNTIL 1900
        if(nrow(subset(lis,lis$year>=1986))>12) { # Ensure the simulation worked for at least the first 12-year rotiation
          vardf = data.frame(row.names = 1:nrow(lis))
          for(var in lis_vars) {
            tempdf = lis
            if(treat=="wf") {
              newdf = mutate(tempdf, back=lag(tempdf[[var]], order_by=year))
              newdf$dif = newdf[[var]]-newdf$back
              tempdf1 = subset(tempdf, tempdf$year<1986)
              mavg1 = movingAverage(tempdf1[[var]], 12, F) # This calculates moving average over that year and previous 11
              tempdf2 = subset(tempdf, tempdf$year>=1986&tempdf$year<1998)
              mavg2 = movingAverage(tempdf2[[var]], 12, T) # This calculates moving average over that year, the previous 5 and next 6
              tempdf3 = subset(tempdf, tempdf$year>=1998)
              mavg3 = movingAverage(tempdf3[[var]], 12, T) # This calculates moving average over that year, the previous 5 and next 6
              mavg3 = c(mavg1,mavg2,mavg3)
              tempdf = cbind(tempdf,col=mavg3)
              vardf = cbind(vardf, new=newdf$dif)
              vardf = cbind(vardf, col=tempdf$col)
              difdf = mutate(tempdf, prev=lag(col, order_by=year))
              difdf$diff = difdf$col-difdf$prev
              vardf = cbind(vardf, diff=difdf$diff)
              names(vardf)[names(vardf) == "new"] = paste("diff",var,sep="_")
              names(vardf)[names(vardf) == "col"] = paste("mavg",var,sep="_")
              names(vardf)[names(vardf) == "diff"] = paste("mavg","diff",var,sep="_")
            }
            if(treat!="wf") {
              newdf = mutate(tempdf, back=lag(tempdf[[var]], order_by=year))
              newdf$dif = newdf[[var]]-newdf$back
              tempdf1 = subset(tempdf, tempdf$year<1986)
              mavg1 = movingAverage(tempdf1[[var]], 12, F) # This calculates moving average over that year and previous 11
              tempdf2 = subset(tempdf, tempdf$year>=1986)
              mavg2 = movingAverage(tempdf2[[var]], 12, T) # This calculates moving average over that year, the previous 5 and next 6
              mavg3 = c(mavg1,mavg2)
              tempdf = cbind(tempdf,col=mavg3)
              vardf = cbind(vardf, new=newdf$dif)
              vardf = cbind(vardf, col=tempdf$col)
              difdf = mutate(tempdf, prev=lag(col, order_by=year))
              difdf$diff = difdf$col-difdf$prev
              vardf = cbind(vardf, diff=difdf$diff)
              names(vardf)[names(vardf) == "new"] = paste("diff",var,sep="_")
              names(vardf)[names(vardf) == "col"] = paste("mavg",var,sep="_")
              names(vardf)[names(vardf) == "diff"] = paste("mavg","diff",var,sep="_")
            }
          }
          lis = cbind(lis,vardf)
          lis$site = site
          lis$slope = slope
          lis$treat = treat
          lis$GCM = "Pre"
          lis$RCP = "RCP45"
          hist_data = rbind(hist_data, lis)
          df_name = paste(site,slope,treat,sep="_")
          comment(lis) = paste(site,slope,treat,sep="_")
          df_list[[df_name]] <- lis
          dummy = c(dummy,1) # Just used to calculate the progress of this loop
          iteration = ((length(dummy))-1)/iter.n*100 # Just used to calculate the progress of this loop
          print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
        }
      }
    }
  }
}

hist_data = hist_data[hist_data$year > (1900+12),] # Used to remove the errors created when calculating a moving average of only 'before' years when there aren't sufficient fallows to balance out the crops, and vice versa

##########
### SECOND - IMPORT THE 'FUTURE' SIMULATION OUTPUTS
##########

main_dir = file.path(resdir, "LAI_LX_Future")

site_list = c("Sterling", "Stratton", "Walsh")
site_list2 = c("ste", "str", "wal")

crop_rotation_list = c("WF","FW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","OPP","Grass")
crop_rotation_list2 = c("wf","fw","wcf","cfw","fwc","wcmf","cmfw","mfwc","fwcm","opp","grass")

harv_crops = c("WF","FW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","OPP")
harv_crops2 = c("wf","fw","wcf","cfw","fwc","wcmf","cmfw","mfwc","fwcm","opp")

RCP_list = c("RCP45", "RCP85")
slope_list = c("summit", "side", "toe")
GCM_list = c("CNRM","CSIRO","GFDL_ESM2G","HadGEM2_CC","HadGEM2_ES","IPSL_CM5BLR","MIROC5","MIROC_CHEM","MRI_CGCM3","bcc_csm11m","bcc_csm11","CanESM2","BNU","inmcm4","GFDL_ESM2M","IPSL_CM5ALR")

library(dplyr)

dflist = list()

### NOTE THIS WILL LIKELY TAKE 5-10 MINUTES TO DO ALL FUTURE SIMS

dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(site_list)*length(crop_rotation_list)*length(RCP_list) # Maximum length of loop iterations to enable % complete display

for (site in site_list){
  for (lis_rotation in crop_rotation_list){
    for (RCP in RCP_list){
      lis_data = data.frame()
      for (slope in slope_list){
        for (GCM in GCM_list){
          site2 = site_list2[which(site_list==site)]
          crop_rotation2 = crop_rotation_list2[which(crop_rotation_list==lis_rotation)]
          #lis file
          lis_file_name = paste(site2, "_", slope,"_", GCM, "_", crop_rotation2,  ".lis", sep="")
          lis_path = file.path(main_dir, site, lis_rotation, RCP, lis_file_name)
          if(file.exists(lis_path)) {
            lis = read_lis_ann(lis_path, variables = lis_vars)
            lis = lis[lis$year > 2009,] # REMOVE THE 'OLD' SIMULATION RESULTS - See DC_cin_to_soilc.R
            if(nrow(subset(lis,lis$year>=2010))>12) { # Ensure the simulation worked for at least the first 12-year rotiation
              vardf = data.frame(row.names = 1:nrow(lis))
              for(var in lis_vars) {
                tempdf = lis
                newdf = mutate(tempdf, back=lag(tempdf[[var]], order_by=year))
                newdf$dif = newdf[[var]]-newdf$back
                tempdf1 = subset(tempdf, tempdf$year>=2010)
                mavg = movingAverage(tempdf1[[var]], 12, T) # This calculates moving average over that year, the previous 5 and next 6
                tempdf = cbind(tempdf,col=mavg)
                vardf = cbind(vardf, new=newdf$dif)
                vardf = cbind(vardf, col=tempdf$col)
                difdf = mutate(tempdf, prev=lag(col, order_by=year))
                difdf$diff = difdf$col-difdf$prev
                vardf = cbind(vardf, diff=difdf$diff)
                names(vardf)[names(vardf) == "new"] = paste("diff",var,sep="_")
                names(vardf)[names(vardf) == "col"] = paste("mavg",var,sep="_")
                names(vardf)[names(vardf) == "diff"] = paste("mavg","diff",var,sep="_")
              }
              lis = cbind(lis,vardf)
              lis$site = site
              lis$slope = slope
              lis$treat = lis_rotation
              lis$GCM = GCM
              lis$RCP = RCP
              lis_data = rbind(lis_data, lis)
            }
          }
        }
      }
      df_name = paste(site,lis_rotation,RCP,"fut",sep="_")
      comment(lis_data) = paste(site,lis_rotation,RCP,"fut",sep="_")
      dflist[[df_name]] <- lis_data
      dummy = c(dummy,1) # Just used to calculate the progress of this loop
      iteration = ((length(dummy))-1)/iter.n*100 # Just used to calculate the progress of this loop
      print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
    }
  }
}

future_data = rbindlist(dflist)

# I LIKE TO CLEAR UP TO ENVIRONMENT AS I GO SO:

rm(difdf, lis, lis_data, newdf, tempdf, tempdf1, tempdf2, tempdf3, vardf,
   crop_rotation2, df_name, GCM, lis_file_name, lis_name, lis_path, lis_rotation, main_dir,
   mavg, mavg1, mavg2, mavg3, path, RCP, site, site2, slope, treat, var)

##############
### NEXT, IT'S WORTHWHILE COMBINING THE TWO DATASETS AND MAKE THE RESULT CONSISTENT
##############

# However, to ease further data processing it's easiest to have both RCPs represented:

dummy = hist_data
dummy$RCP = "RCP85"
hist_data_all = rbind(hist_data, dummy)
rm(dummy)

all_data = rbind(hist_data_all, future_data)

# SITE AND TREAT HAVE DIFFERENT NAMES FOR THE SAME LEVELS, MAKE THEM CONSISTENT

all_data$site = revalue(all_data$site, c("ste"="Sterling", "str"="Stratton", "wal"="Walsh"))
all_data$treat = revalue(all_data$treat, c("wf"="WF","fw"="FW","wcf"="WCF","cfw"="CFW","fwc"="FWC",
                                           "wcmf"="WCMF","cmfw"="CMFW","mfwc"="MFWC","fwcm"="FWCM",
                                           "opp"="OPP","grass"="Grass"))

# Create new variable that groups rotation entry points as the same rotation type (new named trt)
# Also relevel / reorder factors to aid graphing (and correctly format)

all_data$trt = all_data$treat
all_data$trt = revalue(all_data$trt, c("FW"="WF","CFW"="WCF","FWC"="WCF","CMFW"="WCMF","MFWC"="WCMF","FWCM"="WCMF"))
all_data$trt = factor(all_data$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass"))

all_data$slope = revalue(all_data$slope, c("side"="Sideslope","summit"="Summit","toe"="Toeslope"))
all_data$slope = factor(all_data$slope, levels = c("Summit","Sideslope","Toeslope"))

# Also create variables for 12-year phases and the different 'groups' of simulation

all_data$source = "Emp"
all_data$source[all_data$year<1986] = "Pre"
all_data$source[all_data$year>2009] = "Fut"

all_data$phase = "1986-1997"
all_data$phase[all_data$year>1997&all_data$year<2010] = "1998-2009"
all_data$phase[all_data$year>2009&all_data$year<2022] = "2010-2021"
all_data$phase[all_data$year>2021&all_data$year<2034] = "2022-2033"
all_data$phase[all_data$year>2033&all_data$year<2046] = "2034-2045"
all_data$phase[all_data$year>2045&all_data$year<2058] = "2046-2057"
all_data$phase[all_data$year>2057&all_data$year<2070] = "2058-2069"
all_data$phase[all_data$year>2069&all_data$year<2082] = "2070-2081"
all_data$phase[all_data$year>2081&all_data$year<2094] = "2082-2093"

# Cumulate "cinput" (total carbon inputs) over all future simulated years
# NOTE: This will reset in 2010 when 'future' timepoints inlcude different 'treatments' and multiple GCMs 

cum_data = within(all_data, {
  cumCinput <- ave(cinput, site, slope, treat, RCP, GCM, FUN = cumsum)
})

# 'SIMPLE' PLOT OF ALL 'FUTURE' DATA TO SHOW VARIATION BETWEEN GCMs, SLOPES, SITES AND TREATMENT
# Note - Rotation entry point 'treatments' (i.e. WF and FW) and RCP scenarios need to be plotted on the same figure so need to summarise and go back to given date (consistent with timeline soil C figure below)

# Because each GCM needs to start from the 2009 cumulative we first need to obtain those values
sim8009 = all_data[all_data$year>1979&all_data$year<2010,] # Subset before 2009
sim8009 = within(sim8009, {
  cumCinput <- ave(cinput, site, slope, treat, GCM, RCP, FUN = cumsum) # Cumulate cinput by site, slope, treatment
})
sim09cin = ddply(sim8009[sim8009$year==2009,], c("site","slope","treat","RCP"), summarise,
                 cin09 = mean(cumCinput)) # Get the single cumulative value for each site*slope*treatment combination

# Do the same for all GCMs individually for >2009 data
sim1099 = all_data[all_data$year>2009,] # Subset
sim1099 = within(sim1099, {
  cumCinput <- ave(cinput, site, slope, treat, GCM, RCP, FUN = cumsum) # Cumulate cinputs
})

temp = merge(sim1099, sim09cin, by=c("site","slope","treat","RCP")) # Append the C inputs from 2009
temp$cumCinput = temp$cumCinput + temp$cin09 # Add the existing cumulative from 2009 to all cumulatives after that date
sim1099 = temp[,-45] # Balance dataframes by removing the 2009 cinput column

sim8099 = rbind(sim8009, sim1099) # Combine the pre-2009 and post-2009 data
# Add a time zero so all cumulatives start at 0
t0 = ddply(all_data, c("site","slope","treat","trt","GCM","RCP"), summarise, year = 1979, cumCinput = 0) 
sim8099 = rbind.fill(sim8099, t0)

cin.var.raw = data.table(sim8099)
cin.var.data = cin.var.raw[,list(cCin=.Internal(mean(cumCinput)),N=length(cumCinput)),by=list(year, site, slope, trt, RCP, GCM)]

p.GCM.ccin = ggplot(cin.var.data, aes(x=year, y=cCin/100, colour=GCM, linetype=slope, alpha=site, fill=RCP)) +
#  annotate("rect", xmin=1985.5, xmax=1997.5, ymin=0, ymax=Inf, fill="darkgreen", alpha=0.2) +
#  annotate("rect", xmin=1997.5, xmax=2009.5, ymin=0, ymax=Inf, fill="red", alpha=0.2) +
  geom_vline(aes(xintercept=1985.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=1997.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009.5), linetype="dashed", alpha=0.5) +
  geom_line(data=cin.var.data[cin.var.data$year<2011,], colour='black') +
  geom_line(data=cin.var.data[cin.var.data$year>2009,]) +
#  geom_smooth(data=cin.var.data[cin.var.data$year>2009&cin.var.data$RCP=="RCP45",], se=F, alpha=1, colour='cornflowerblue', linetype='solid') +
#  geom_smooth(data=cin.var.data[cin.var.data$year>2009&cin.var.data$RCP=="RCP85",], se=F, alpha=1, colour='firebrick', linetype='dashed') +
  scale_y_continuous(expand=c(0,0), limits=c(0,350)) +
  scale_x_continuous(expand=c(0,0), limits=c(1979,2100), breaks=c(1985,2005,2025,2045,2065,2085)) +
  ylab(expression(paste("Cumulative Total Inputs (tC ", ha^-1,")"))) +
  xlab(expression(paste("Year"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        axis.text.x = element_text(angle = 45, hjust = 0.8, vjust = 0.8),
        panel.grid = element_blank()) +
  scale_linetype_manual("Slope",
                        values = c(2,1,3),
                        labels = c("Summit","Sideslope","Toeslope")) +
#  scale_colour_manual("Site",
#                      values = c("coral2","cornflowerblue", "darkgreen"),
#                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_alpha_manual("Site", values = c(1,1,1), labels = c("Sterling","Stratton","Walsh"), guide=F) +
  scale_fill_manual("RCP Scenario", values = c("RCP 4.5"="orange","RCP 8.5"="black"))

# To annotate on WF and WCMF facets only we need to create dummy dataframes with all relevant factors
wf_text = data.frame(year=2003, site="Walsh", slope="Summit", GCM="Pre", RCP="RCP45",
                     trt = factor("WF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))
wcmf_text = data.frame(year=2003, site="Walsh", slope="Summit", GCM="Pre", RCP="RCP45",
                       trt = factor("WCMF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))

p.GCM.ccin.1 = p.GCM.ccin + facet_wrap(~trt, ncol=5) + theme(legend.position = "bottom") +
  guides(alpha=F,
         colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  geom_text(data=wf_text, aes(y=200), label="W\nC\nM", colour="black", alpha=1) + 
  geom_text(data=wcmf_text, aes(y=200), label="W\nW\nC\nM", colour="black", alpha=1)
p.GCM.ccin.2 = p.GCM.ccin + facet_wrap(~trt, ncol=1) +
  geom_text(data=wf_text, aes(y=200), label="W\nC\nM", colour="black", alpha=1) + 
  geom_text(data=wcmf_text, aes(y=200), label="W\nW\nC\nM", colour="black", alpha=1)

# Save resulting plot (note - it's a complex/large one!)

ggsave(p.GCM.ccin.1, path=figdir, filename="cinput_variation.pdf", height=125, width=450, units="mm")
ggsave(p.GCM.ccin.2, path=figdir, filename="cinput_variation_tall.pdf", height=450, width=150, units="mm")

# To calculate highest and lowest values in 2100 so they can be included as summary numbers in the publication text
cin.var.2100 = ddply(cin.var.raw[cin.var.raw$year==2100,], c("trt","RCP"), summarise,
                     min = min(cumCinput),
                     max = max(cumCinput),
                     mean = mean(cumCinput),
                     sd = sd(cumCinput),
                     N = length(cumCinput))

write.csv(cin.var.2100, file=file.path(figdir, "cumulative_inputs2100.csv"))

save(all_data, file=file.path(Robjsdir,"all_data"))

# Remove unwanted objects
rm(sim8009, sim09cin, sim1099, sim8099, temp, t0) # Plot objects can be large - can remove these too

### AFTER NOTING THE ABSOLUTE VARIATION IN INPUTS BETWEEN THE DIFFERENT GCMs, SLOPES AND ROTATION ENTRY POINTS
### CALCULATE AVERAGES AND 95% CONFIDENCE INTERVALS ON AN ANNUAL BASIS

### HERE WE CAN ADD MEASURED VALUES TO THE DATASET AND GRAPH COMPARISON OF SOIL C STOCKS:

temp = ddply(cum_data, c("year","site","trt","RCP","source"), summarise,
             mean = mean(somtc),
             bd_upper = quantile(somtc, probs=0.975),
             bd_lower = quantile(somtc, probs=0.025),
             type = "Total C")

everything = merge(temp,meas.mod.slc,all=T)

p.totc.all = ggplot(everything, aes(x=year,pch=source)) +
  geom_point(data=everything[everything$source=="Measured",], aes(y=mean, fill=type)) +
  geom_line(data=everything[everything$source=="Modelled",], aes(y=mean)) +
  geom_line(data=everything[everything$source=="Fut",], aes(y=mean, colour=RCP)) +
  geom_line(data=everything[everything$source=="Fut",], aes(y=bd_upper, colour=RCP), linetype='dotted') +
  geom_line(data=everything[everything$source=="Fut",], aes(y=bd_lower, colour=RCP), linetype='dotted') +
  geom_errorbar(data=everything[everything$source=="Measured",], aes(ymax=ymax, ymin=ymin), width = 0.25, alpha = 1) +
  facet_wrap(~site*trt, ncol=5) +
  scale_x_continuous(expand=c(0,0),
                     limits=c(1900,2100)) +
  scale_y_continuous(expand=c(0,0),
                     limits=c(0,7500)) 

# Not interested in the differences between sites of the figure above for publication (hence below!)
# Also remove certain years (e.g 1986 data as it uses unbalanced averages)

slcyears = c(1985, 1997, 2015) # Choose which years you want to include on this figure - also can plot 1986 and 2009.

meas.slc.yrs = ddply(meas.raw.slc[meas.raw.slc$year %in% slcyears,], c("year", "trt", "source"), summarise,
                     N = length(profilesoc),
                     soilC = mean(profilesoc),
                     se = sd(profilesoc)/sqrt(length(profilesoc)),
                     ymin=mean(profilesoc)-(sd(profilesoc)/sqrt(length(profilesoc))),
                     ymax=mean(profilesoc)+(sd(profilesoc)/sqrt(length(profilesoc))),
                     type = "Total C")

mod.slc.yrs = ddply(mod.raw.slc, c("year", "trt", "source"), summarise,
                    N = length(somtc),
                    soilC = mean(somtc),
                    se = sd(somtc)/sqrt(length(somtc)),
                    ymin=mean(somtc)-(sd(somtc)/sqrt(length(somtc))),
                    ymax=mean(somtc)+(sd(somtc)/sqrt(length(somtc))),
                    type = "Total C")

temp = merge(mod.slc.yrs, meas.slc.yrs, all=T)

temp2 = ddply(cum_data, c("year","site","trt","RCP","source"), summarise,
              N = length(somtc),
              soc = mean(somtc),
              bdhi = quantile(somtc, probs=0.975),
              bdlo = quantile(somtc, probs=0.025),
              type = "Total C")

temp2 = ddply(temp2, c("year","trt","RCP","source","type"), summarise,
              N = length(soc),
              soilC = mean(soc),
              bdhi = mean(bdhi),
              bdlo = mean(bdlo))

all.soilC = merge(temp,temp2,all=T)
all.soilC = all.soilC[all.soilC$year>1974,]

all.soilC$trt = factor(all.soilC$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass")) # Relevel the treatments that are plotted from least intense to most intense
all.soilC2=all.soilC
all.soilC2$trt = revalue(all.soilC2$trt, c("OPP"="CC"))
all.soilC2$trt = factor(all.soilC2$trt, levels = c("WF", "WCF", "WCMF", "CC", "Grass")) # Relevel the treatments that are plotted from least intense to most intense

p.totc.85 = ggplot(all.soilC2, aes(x=year, colour=RCP, fill=RCP, linetype=RCP)) +
#  annotate("rect", xmin=1985.5, xmax=1997, ymin=15, ymax=Inf, fill="darkgreen", alpha=0.2) +
#  annotate("rect", xmin=1997, xmax=2008.5, ymin=15, ymax=Inf, fill="red", alpha=0.2) +
  geom_vline(aes(xintercept=1985.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=1997), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2008.5), linetype="dashed", alpha=0.5) +
  geom_ribbon(data=all.soilC2[all.soilC2$source!="Measured"&!is.na(all.soilC2$bdhi)&all.soilC2$year<=2009,], aes(ymax=bdhi/100, ymin=bdlo/100), fill="grey50", alpha=0.2, colour=NA) +
  geom_ribbon(data=all.soilC2[all.soilC2$source!="Measured"&!is.na(all.soilC2$bdhi)&all.soilC2$year>2008,], aes(ymax=bdhi/100, ymin=bdlo/100), alpha=0.18, colour=NA) +
  geom_line(data=all.soilC2[all.soilC2$source!="Measured"&all.soilC2$source!="Modelled"&all.soilC2$RCP=="RCP45"&all.soilC2$year<2010,], aes(y=soilC/100), colour='black') +
  geom_line(data=all.soilC2[all.soilC2$source!="Measured"&all.soilC2$source!="Modelled"&all.soilC2$year>2008,], aes(y=soilC/100)) +
  geom_point(data=all.soilC2[all.soilC2$source=="Measured",], aes(y=soilC/100), colour='black') +
#  geom_line(data=all.soilC2[all.soilC2$source!="Measured"&all.soilC2$RCP=="RCP45"&!is.na(all.soilC2$bdhi)&all.soilC2$year>2008,], aes(y=bdhi/100), linetype="dotted") +
#  geom_line(data=all.soilC2[all.soilC2$source!="Measured"&all.soilC2$RCP=="RCP85"&!is.na(all.soilC2$bdlo)&all.soilC2$year>2008,], aes(y=bdlo/100), linetype="dotted") +
  geom_errorbar(data=all.soilC2[all.soilC2$source=="Measured"&!is.na(all.soilC2$ymax)&!is.na(all.soilC2$ymin),], aes(ymax=ymax/100, ymin=ymin/100), width=2, colour='black', linetype='solid') +
  ylab(expression(paste("Soil C stock (tC ", ha^-1,")"))) +
  xlab(expression(paste("Year"))) +
  scale_y_continuous(expand=c(0,0), limits=c(15,42)) +
  scale_x_continuous(expand=c(0,0), limits=c(1979,2100), breaks=c(1985,2005,2025,2045,2065,2085)) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle = 45, hjust = 0.8, vjust = 0.8),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_fill_manual("RCP Scenario",
                    values = c("cornflowerblue","firebrick"),
                    labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

# To annotate on WF and WCMF facets only we need to create dummy dataframes with all relevant factors
#wf_text = data.frame(year=2003, soilC=34.5, RCP = "RCP45",
#                     trt = factor("WF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))
#wcmf_text = data.frame(year=2003, soilC=34.5, RCP = "RCP45",
#                     trt = factor("WCMF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))

p.totc.85.1 = p.totc.85 + facet_wrap(~trt, ncol=5) + theme(legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5)) +
  geom_text(data=wf_text, aes(y=34.5), label="W\nC\nM", colour="black") + geom_text(data=wcmf_text, aes(y=34.5), label="W\nW\nC\nM", colour="black")
p.totc.85.2 = p.totc.85 + facet_wrap(~trt, ncol=1) + 
  geom_text(data=wf_text, aes(y=34.5), label="W\nC\nM", colour="black") + geom_text(data=wcmf_text, aes(y=34.5), label="W\nW\nC\nM", colour="black")

ggsave(p.totc.all, file=file.path(figdir, "future_slc_1900.pdf"), width=550, height=300, units="mm")
ggsave(p.totc.85.1, file=file.path(figdir, "future_slc_1985.pdf"), width=450, height=125, units="mm")
ggsave(p.totc.85.2, file=file.path(figdir, "future_slc_1985_tall.pdf"), width=150, height=450, units="mm")

### 1:1 LINE OF MEASURED AND MODELLED SOIL CARBON STOCKS (USING ALL DATA POINTS)

meas.slc = ddply(meas.raw.slc, c("year","site","slope","treat","trt","source"), summarise,
             mean = mean(profilesoc),
             bd_upper = quantile(profilesoc, probs=0.975),
             bd_lower = quantile(profilesoc, probs=0.025),
             N = length(profilesoc))

mod.slc = ddply(all_data, c("year","site","slope","treat","trt","source"), summarise,
                mean = mean(somtc),
                bd_upper = quantile(somtc, probs=0.975),
                bd_lower = quantile(somtc, probs=0.025),
                N = length(somtc))

mod.slc$source = "Modelled" # To ease comparison with measured data

slc.comparison = merge(meas.slc,mod.slc,by=c("year","site","slope","treat","trt"))
slc.comparison$trt = factor(slc.comparison$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass"))
slc.comparison2 = slc.comparison 
slc.comparison2$trt = revalue(slc.comparison2$trt, c("OPP"="CC"))
slc.comparison2$trt = factor(slc.comparison2$trt, levels = c("WF", "WCF", "WCMF", "CC", "Grass"))

# This gives the overall RMSE of measured vs modelled soil C stock values (site*slope*treatment*year)
sqrt(mean((slc.comparison2$mean.y-slc.comparison2$mean.x)^2, na.rm=T)) # Note - in gC/m2

sites = levels(as.factor(slc.comparison2$site))
trts = levels(as.factor(slc.comparison2$trt))

site.rmse.func = function(df){
  output = data.frame(site="Sterling",trt="WF",n=NA,source="Measured",rmse=NA,rsq=NA,mae=NA)
  for(sit in sites){
    for (tret in trts){
      if(nrow(df[df$site==sit&df$trt==tret,])<1) next
      newdf = df[df$site==sit&df$trt==tret,]
      len = nrow(newdf)
      rms = sqrt(mean((newdf$mean.y-newdf$mean.x)^2, na.rm=T))
      me = mean(abs((newdf$mean.y-newdf$mean.x)), na.rm=T)
      print(rms)
      lmod = lm(mean.y~mean.x+0, newdf)
      rs = summary(lmod)$r.squared
      output = rbind(output, data.frame(site=sit,trt=tret,n=len,source="Measured",rmse=rms,rsq=rs,mae=me))
    }
  }
  return(output)
}

slc.rmse.func = function(df){
  output = data.frame(trt="WF",n=NA,source="Measured",rmse=NA,rsq=NA,mae=NA)
  for (tret in trts){
    if(nrow(df[df$trt==tret,])<1) next
    newdf = df[df$trt==tret,]
    len = nrow(newdf)
    rms = sqrt(mean((newdf$mean.y-newdf$mean.x)^2, na.rm=T))
    me = mean(abs((newdf$mean.y-newdf$mean.x)), na.rm=T)
    print(rms)
    lmod = lm(mean.y~mean.x+0, newdf)
    rs = summary(lmod)$r.squared
    output = rbind(output, data.frame(trt=tret,n=len,source="Measured",rmse=rms,rsq=rs,mae=me))
  }
  return(output)
}

slc.rmse.site = site.rmse.func(slc.comparison2)
slc.rmse.site = slc.rmse.site[complete.cases(slc.rmse.site$n),]
slc.rmse = slc.rmse.func(slc.comparison2)
slc.rmse = slc.rmse[complete.cases(slc.rmse$n),]

p.slc.mm = ggplot(slc.comparison2, aes(x = mean.x/100, y = mean.y/100))+
  geom_text(fontface = "italic", data=slc.rmse, aes(x=10, y=32, label = paste("n=", round(n, 0))), size=2.5) +
  geom_text(data=slc.rmse, aes(x=10, y=36,label = paste("R2=", round(rsq, 2))), size=3) +
  geom_text(data=slc.rmse, aes(x=10, y=40,label = paste("RMSE=", round(rmse/100, 2))), size=3) +
  geom_text(data=slc.rmse, aes(x=10, y=44,label = paste("MAE=", round(mae/100, 2))), size=3) +
  geom_point(aes(pch=site)) +
  geom_smooth(method="lm",formula=my.formula,se=F) +
  geom_abline(intercept=0, slope=1, linetype='dotted') +
#  geom_errorbar(aes(ymax=bd_upper.y/100, ymin=bd_lower.y/100, colour=site), alpha = 1) +
#  geom_errorbarh(aes(xmax=bd_upper.x/100, xmin=bd_upper.x/100, colour=site), alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,49)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,49)) +
#  ggtitle("NB - Measured data averaged over all strips") +
  ylab(expression(paste("Modelled Soil C stock (tC ", ha^-1,")"))) +
  xlab(expression(paste("Measured Soil C stock (tC ", ha^-1,")"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_shape_manual("Site",
                      values = c(15,16,17),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_size(guide=F)

p.slc.mm.1 = p.slc.mm + facet_wrap(~trt, ncol = 5) + theme(legend.position = "bottom") +
  guides(shape=guide_legend(title.position = "top", title.hjust = 0.5))
p.slc.mm.2 = p.slc.mm + facet_wrap(~trt, ncol = 1)

ggsave(p.slc.mm.1, file=file.path(figdir, "soilC_1to1_comparison.pdf"), width=450, height=125, units="mm")
ggsave(p.slc.mm.2, file=file.path(figdir, "soilC_1to1_comparison_tall.pdf"), width=150, height=450, units="mm")
mm.slc.all = everything
save(mm.slc.all, file=file.path(Robjsdir, "mm.slc.all"))

# Remove unwanted dataframes

rm(cum_data, everything, temp, temp2, wf_text, wcmf_text)

# Multiplot the facetted plots to compare treatments

multiplot(p.slc.mm.1, p.totc.85.1, p.GCM.ccin.1, cols=1)
