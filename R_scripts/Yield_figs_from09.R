# ------------------------------------------------------------------------------#
### PRODUCES FIGURES TO REPRESENT SIMULATED GRAIN AND STOVER YIELDS 2009-2100 ###
# ------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

###############
## IMPORT HARVEST OBJECTS FROM FUTURE SCENARIOS
###############

### VARIABLES TO BE IMPORTED

harv_vars = c('agcacc','cgrain','crpval') # These are the variables you wish to import from the harvest.csv model output file
harv_vars2 = c('stvr','cgrain') # These are the variables you wish to calculate a moving average for over time

### FUNCTION TO READ AND IMPORT HARV FILES (ONLY VARIABLES THAT CUMULATE OVER THE YEAR AND RESET ON JAN 1st)

read_harvest <- function(harvest_path, harv_vars){
  harvest = read.csv(harvest_path)[ , c("time", harv_vars)]
  harvest$year = floor(harvest$time)
  harvest = harvest[c(harv_vars[1])!=0,]
  return(harvest)
}

### FUNCTION TO CALCULATE UNCERTAINTY FROM GCMs - NOT CURRENTLY USED

analyze_uncert <- function(data_tb){
  range_df <- data.frame()
  for (i in unique(data_tb$year)){
    bd_upper <- quantile(data_tb$value[data_tb$year==i], 0.025)
    bd_lower <- quantile(data_tb$value[data_tb$year==i], 0.975)
    range_df <- rbind(range_df, data.frame(bd_upper=bd_upper, bd_lower=bd_lower, year= i))
  }
}

# Extract and save yields

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

harvdfs = list()
dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(site_list)*length(harv_crops)*length(RCP_list) # Maximum length of loop iterations to enable % complete display

for (site in site_list){
  for (harv_rotation in harv_crops){
    for (RCP in RCP_list){
      harvest_data = data.frame()
      for (slope in slope_list){
        for (GCM in GCM_list){
          site2 = site_list2[which(site_list==site)]
          crop_rotation2 = harv_crops2[which(harv_crops==harv_rotation)]
          harvest_file_name = paste(site2, "_", slope,"_", GCM, "_", crop_rotation2, "_", "harvest.csv", sep="")
          harvest_path = file.path(main_dir, site, harv_rotation, RCP, harvest_file_name)
          if(file.exists(harvest_path)) {
            harvest = read_harvest(harvest_path, harv_vars)
            if(nrow(subset(harvest,harvest$year>=2010))>12) { # Ensure the simulation worked for at least the first 12-year rotiation
              harvest = harvest[harvest$year > 2009,] # Only interested in future sims
              harvest$stvr = harvest$agcacc-harvest$cgrain
              vardf = data.frame(row.names = 1:nrow(harvest))
              for(var in harv_vars2) {
                mavg = movingAverage(harvest[[var]], 12, T) # This calculates moving average over that year, the previous 5 and next 6
                vardf = cbind(vardf,col=mavg)
                names(vardf)[names(vardf) == "col"] = paste("mavg",var,sep="_")
              }
              harvest=cbind(harvest,vardf)
              harvest$site = site
              harvest$slope = slope
              harvest$treat = harv_rotation
              harvest$GCM = GCM
              harvest$RCP = RCP
              harvest_data = rbind(harvest_data, harvest)
            }
          }
        }
      }
      df_name = paste(site,harv_rotation,RCP,"fut",sep="_")
      comment(harvest_data) = paste(site,harv_rotation,RCP,"fut",sep="_")
      harvdfs[[df_name]] <- harvest_data
      harvest$GCM = GCM
      harvest$slope = slope
      harvest_data = rbind(harvest_data, harvest)
      dummy = c(dummy,1) # Just used to calculate the progress of this loop
      iteration = ((length(dummy))-1)/iter.n*100 # Just used to cal culate the progress of this loop
      print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
    }
  }
}

fut_harvs = rbindlist(harvdfs) # Convert the list of dataframes to a single rbind'ed dataframe

# Rename crop codes to be consistent with measured data and to ease further analysis
fut_harvs$crpval = as.character(fut_harvs$crpval)
fut_harvs$crpval[fut_harvs$crpval=="'W3SG83'"] = "Wheat"
fut_harvs$crpval[fut_harvs$crpval=="'W3SN90'"] = "Wheat"
fut_harvs$crpval[fut_harvs$crpval=="'W3WS99'"] = "Wheat"
fut_harvs$crpval[fut_harvs$crpval=="'C6SG66'"] = "Corn"
fut_harvs$crpval[fut_harvs$crpval=="'C6SN73'"] = "Corn"
fut_harvs$crpval[fut_harvs$crpval=="'C6WS82'"] = "Corn"
fut_harvs$crpval[fut_harvs$crpval=="'MILO89'"] = "Millet"
fut_harvs$crpval[fut_harvs$crpval=="'SW3H112'"] = "Wheat"
fut_harvs$crpval = as.factor(fut_harvs$crpval)

names(fut_harvs)[names(fut_harvs) == 'crpval'] = 'crop' # Change name of crop column

# Preparing for graphing and rotation annualization

fut_harvs$treatno[fut_harvs$treat == "WF"] = 1
fut_harvs$treatno[fut_harvs$treat == "FW"] = 2
fut_harvs$treatno[fut_harvs$treat == "WCF"] = 3
fut_harvs$treatno[fut_harvs$treat == "CFW"] = 4
fut_harvs$treatno[fut_harvs$treat == "FWC"] = 5
fut_harvs$treatno[fut_harvs$treat == "WCMF"] = 6
fut_harvs$treatno[fut_harvs$treat == "CMFW"] = 7
fut_harvs$treatno[fut_harvs$treat == "MFWC"] = 8
fut_harvs$treatno[fut_harvs$treat == "FWCM"] = 9
fut_harvs$treatno[fut_harvs$treat == "OPP"] = 10
fut_harvs$treatno[fut_harvs$treat == "Grass"] = 11

fut_harvs$treat = factor(fut_harvs$treat, levels = c("WF","FW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","OPP","Grass"))
fut_harvs$trt = fut_harvs$treat
fut_harvs$trt = revalue(fut_harvs$trt, c("FW"="WF","CFW"="WCF","FWC"="WCF","CMFW"="WCMF","MFWC"="WCMF","FWCM"="WCMF"))
fut_harvs$trt = factor(fut_harvs$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass"))

fut_harvs$slope = revalue(fut_harvs$slope, c("side"="Sideslope","summit"="Summit","toe"="Toeslope"))
fut_harvs$slope = factor(fut_harvs$slope, levels = c("Summit","Sideslope","Toeslope"))

fut_harvs$rot_phs[fut_harvs$year>2009&fut_harvs$year<2022] = "2010 - 2021"
fut_harvs$rot_phs[fut_harvs$year>2021&fut_harvs$year<2034] = "2022 - 2033"
fut_harvs$rot_phs[fut_harvs$year>2033&fut_harvs$year<2046] = "2034 - 2045"
fut_harvs$rot_phs[fut_harvs$year>2045&fut_harvs$year<2058] = "2046 - 2057"
fut_harvs$rot_phs[fut_harvs$year>2057&fut_harvs$year<2070] = "2058 - 2069"
fut_harvs$rot_phs[fut_harvs$year>2069&fut_harvs$year<2082] = "2070 - 2081"
fut_harvs$rot_phs[fut_harvs$year>2081&fut_harvs$year<2094] = "2082 - 2093"

fut_harvs$source = "Modelled" # This is used for comparison with measured yields when graphing/sub-setting

save(fut_harvs, file=file.path(Robjsdir, "fut_harvs")) # Save the resulting future harvest data

# To estimate average yields for the different crops over time combine measured and modelled data pre and post 2009
# First simplify the total future dataframe to create consistent structure using site, slope, treatments, crops, GCMs and RCPs
temp = fut_harvs[,list(grn=.Internal(mean(cgrain)),
                       agc=.Internal(mean(agcacc)),
                       stvr=.Internal(mean(stvr)),
                       N=length(cgrain)),by=list(year,site,slope,treat,trt,crop,GCM,RCP)]
temp$source = "Modelled"

# Do the same with pre-2009 modelled data
temp2 = as.data.table(mod.raw.ylds)
temp2 = temp2[,list(grn=.Internal(mean(cgrain)),
                    agc=.Internal(mean(agcacc)),
                    stvr=.Internal(mean(stvr)),
                    N=length(cgrain)),by=list(year,site,slope,treat,trt,crop)]
temp2$source = "Modelled"

temp2$GCM = "Pre" # Useful to complete the dataframe
temp2$RCP = "RCP45" # Useful to complete the dataframe
temp3 = temp2
temp3$RCP = "RCP85"

# Do the same for measured data
temp4 = as.data.table(meas.raw.ylds)
temp4 = temp4[,list(grn=.Internal(mean(gr_yld)),
                    agc=.Internal(mean(gr_yld+st_yld)),
                    stvr=.Internal(mean(st_yld)),
                    N=length(gr_yld)),by=list(year,site,slope,treat,trt,crop)]
temp4$source = "Measured"
temp4 = temp4[complete.cases(temp4$agc),]

temp4$GCM = "Pre"
temp4$RCP = "RCP45"
temp5 = temp4
temp5$RCP = "RCP85"

all_ylds=rbind(temp, temp2, temp3, temp4, temp5) # Combine to get all raw yield data

all_ylds = all_ylds[all_ylds$crop %in% c("Wheat", "Corn", "Millet")] # Limit this to the core crops only (could add sorghum)

# Instead of looking at individual years look at each 12-year phase
all_ylds$rot_phs[all_ylds$year>1985&all_ylds$year<1998] = "1986 - 1997"
all_ylds$rot_phs[all_ylds$year>1997&all_ylds$year<2010] = "1998 - 2009"
all_ylds$rot_phs[all_ylds$year>2009&all_ylds$year<2022] = "2010 - 2021"
all_ylds$rot_phs[all_ylds$year>2021&all_ylds$year<2034] = "2022 - 2033"
all_ylds$rot_phs[all_ylds$year>2033&all_ylds$year<2046] = "2034 - 2045"
all_ylds$rot_phs[all_ylds$year>2045&all_ylds$year<2058] = "2046 - 2057"
all_ylds$rot_phs[all_ylds$year>2057&all_ylds$year<2070] = "2058 - 2069"
all_ylds$rot_phs[all_ylds$year>2069&all_ylds$year<2082] = "2070 - 2081"
all_ylds$rot_phs[all_ylds$year>2081&all_ylds$year<2094] = "2082 - 2093"

all_ylds$phsno[all_ylds$year>1985&all_ylds$year<1998] = 1
all_ylds$phsno[all_ylds$year>1997&all_ylds$year<2010] = 2
all_ylds$phsno[all_ylds$year>2009&all_ylds$year<2022] = 3
all_ylds$phsno[all_ylds$year>2021&all_ylds$year<2034] = 4
all_ylds$phsno[all_ylds$year>2033&all_ylds$year<2046] = 5
all_ylds$phsno[all_ylds$year>2045&all_ylds$year<2058] = 6
all_ylds$phsno[all_ylds$year>2057&all_ylds$year<2070] = 7
all_ylds$phsno[all_ylds$year>2069&all_ylds$year<2082] = 8
all_ylds$phsno[all_ylds$year>2081&all_ylds$year<2094] = 9

# Average the grain and stover yields by different RCP scenarios, phases and crops
yld_summary = ddply(all_ylds, c("rot_phs","phsno","crop","RCP","source"), summarise,
                    grn.x = mean(grn),
                    grnhi = mean(grn) + sd(grn)/sqrt(length(grn)),
                    grnlo = mean(grn) - sd(grn)/sqrt(length(grn)),
                    stvr.x = mean(stvr),
                    stvrhi =  mean(stvr) + sd(stvr)/sqrt(length(stvr)),
                    stvrlo = mean(stvr) - sd(stvr)/sqrt(length(stvr)),
                    agc.x = mean(agc),
                    agchi = mean(agc) + sd(agc)/sqrt(length(agc)),
                    agclo = mean(agc) - sd(agc)/sqrt(length(agc)),
                    N = length(year))

# Write the resulting table of data to filepath
write.csv(yld_summary, file=file.path(figdir, "Average yields by phase.csv"))

### TO CREATE A VISUAL REPRESENTATION ESTIMATE EVERY SINGLE 12-YEAR PERIOD FROM BEGINNING TO END

all_ylds2 = list()
for(i in 1985:2087) {
  tempdf = all_ylds[all_ylds$year>i&all_ylds$year<(i+13),]
  tempdf$phase = paste((i+1),(i+12),sep="-")
  tempdf$phaseno = i+6 # This depends how you want to present the data but +6 means the middle of the 12-year period assessed
  all_ylds2[[i]] <- tempdf
}

yld_data = rbindlist(all_ylds2)

# Average over treatment entry points and slopes to get the general crop-and-site-specific yields
crp_summary = yld_data[,list(grn=.Internal(mean(grn)),
                             agc=.Internal(mean(agc)),
                             stvr=.Internal(mean(stvr)),
                             N=length(grn)),by=list(year,crop,GCM,RCP,phase,phaseno,source)]

# Use the summary data to then estimate 95% confidence around modelled data and standard errors around 'annual' measured data
graphdf = rbind(ddply(crp_summary[crp_summary$source=="Modelled",], c("crop","RCP","phase","phaseno","source"), summarise,
                      grn.x = mean(grn),
                      grnhi = quantile(grn, probs=0.975),
                      grnlo = quantile(grn, probs=0.025),
                      stvr.x = mean(stvr),
                      stvrhi = quantile(stvr, probs=0.975),
                      stvrlo = quantile(stvr, probs=0.025),
                      agc.x = mean(agc),
                      agchi = quantile(agc, probs=0.975),
                      agclo = quantile(agc, probs=0.025),
                      N = length(year)),
                ddply(crp_summary[crp_summary$source=="Measured",], c("crop","RCP","phase","phaseno","source"), summarise,
                      grn.x = mean(grn),
                      grnhi = mean(grn) + sd(grn)/sqrt(length(grn)),
                      grnlo = mean(grn) - sd(grn)/sqrt(length(grn)),
                      stvr.x = mean(stvr),
                      stvrhi =  mean(stvr) + sd(stvr)/sqrt(length(stvr)),
                      stvrlo = mean(stvr) - sd(stvr)/sqrt(length(stvr)),
                      agc.x = mean(agc),
                      agchi = mean(agc) + sd(agc)/sqrt(length(agc)),
                      agclo = mean(agc) - sd(agc)/sqrt(length(agc)),
                      N = length(year)))

p.grn.yrs = ggplot(graphdf, aes(x=phaseno+6, y=grn.x/crn.c.gr/kgha2gm2, linetype=RCP, fill=RCP, colour=RCP)) +
  geom_ribbon(data=graphdf[graphdf$source=="Modelled",], aes(ymin=grnlo/crn.c.gr/kgha2gm2, ymax=grnhi/crn.c.gr/kgha2gm2), alpha=0.2, colour=NA) +
  geom_line(data=graphdf[graphdf$source=="Modelled",]) +
  facet_wrap(~crop) +
  geom_vline(aes(xintercept=1997.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009.5), linetype="dashed", alpha=0.5) +
  scale_y_continuous(expand=c(0,0), limits=c(0,8500)) +
  scale_x_continuous(expand=c(0,0), limits=c(1995,2100), breaks=c(1995,2015,2035,2055,2075,2095)) +
  ylab(expression(paste("Average annual grain yield (kg ", ha^-1,")"))) +
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
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  scale_fill_manual("RCP Scenario",
                    values = c("cornflowerblue","firebrick"),
                    labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype_manual("RCP Scenario",
                      values = c(1,2),
                      labels = c("RCP 4.5", "RCP 8.5")) 

p.stvr.yrs = ggplot(graphdf, aes(x=phaseno+6, y=stvr.x/crn.c.st/kgha2gm2, linetype=RCP, fill=RCP, colour=RCP)) +
  geom_ribbon(data=graphdf[graphdf$source=="Modelled",], aes(ymin=stvrlo/crn.c.st/kgha2gm2, ymax=stvrhi/crn.c.st/kgha2gm2), alpha=0.2, colour=NA) +
  geom_line(data=graphdf[graphdf$source=="Modelled",]) +
  facet_wrap(~crop) +
  geom_vline(aes(xintercept=1997.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009.5), linetype="dashed", alpha=0.5) +
  scale_y_continuous(expand=c(0,0), limits=c(0,8500)) +
  scale_x_continuous(expand=c(0,0), limits=c(1995,2100), breaks=c(1995,2015,2035,2055,2075,2095)) +
  ylab(expression(paste("Average annual stover yield (kg ", ha^-1,")"))) +
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
        panel.grid = element_blank(),
        legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  scale_fill_manual("RCP Scenario",
                    values = c("cornflowerblue","firebrick"),
                    labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) 

p.agc.yrs = ggplot(graphdf, aes(x=phaseno+6, y=agc.x/crn.c.gr/kgha2gm2, linetype=RCP, fill=RCP, colour=RCP)) +
  geom_ribbon(data=graphdf[graphdf$source=="Modelled",], aes(ymin=agclo/crn.c.gr/kgha2gm2, ymax=agchi/crn.c.gr/kgha2gm2), alpha=0.2, colour=NA) +
  geom_line(data=graphdf[graphdf$source=="Modelled",]) +
  facet_wrap(~crop) +
  geom_vline(aes(xintercept=1997.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009.5), linetype="dashed", alpha=0.5) +
  scale_y_continuous(expand=c(0,0), limits=c(0,15000)) +
  scale_x_continuous(expand=c(0,0), limits=c(1995,2100), breaks=c(1995,2015,2035,2055,2075,2095)) +
  ylab(expression(paste("Average annual aboveground biomass (kg ", ha^-1,")"))) +
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
        panel.grid = element_blank(),
        legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  scale_fill_manual("RCP Scenario",
                    values = c("cornflowerblue","firebrick"),
                    labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5"))

# Arrange the stover and grain yields into one figure and save
library(ggplot2)
library(gridExtra)
library(grid)

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="top") +
                    guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
                           fill=guide_legend(title.position = "top", title.hjust = 0.5),
                           linetype=guide_legend(title.position = "top", title.hjust = 0.5)))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 1,
    heights = unit.c(unit(1, "npc") - lheight, lheight))
}

p.ylds.yrs = grid_arrange_shared_legend(p.grn.yrs,p.stvr.yrs, ncol = 1) 
ggsave(p.ylds.yrs, file=file.path(figdir, "Yields over time by RCP.pdf"), width=300, height=200, units="mm")

### Now plotting the variation of the same yield variables
# Average over all entry points to reduce number of facets
fut.yld.summary = ddply(fut_harvs, c("year","rot_phs","site","slope","trt","GCM","RCP","source"), summarise,
                        cgrain.x = mean(cgrain),
                        agcacc.x = mean(agcacc),
                        stvr.x = mean(stvr),
                        N = length(year))

# To plot variation of all yield measurements we need to plot cumulative values 

fut.ylds = within(fut.yld.summary, {
  cumagc <- ave(agcacc.x, site, slope, trt, GCM, RCP, FUN = cumsum)
  cumstvr <- ave(stvr.x, site, slope, trt, GCM, RCP, FUN = cumsum)
  cumgrn <- ave(cgrain.x, site, slope, trt, GCM, RCP, FUN = cumsum)
})

p.grn.var = ggplot(fut.ylds, aes(x=year, y=cumgrn, colour=GCM, linetype=site, alpha=slope, fill=RCP)) +
  geom_line() +
  facet_wrap(~trt, nrow=1) +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP45",], se=F, alpha=1, colour='cornflowerblue', linetype='solid') +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP85",], se=F, alpha=1, colour='firebrick', linetype='dashed') +
  scale_y_continuous(expand=c(0,0), limits=c(0,16500)) +
  ylab(expression(paste("Cumulative grain yield (gC ", m^-2,")"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_alpha_manual(values=c(1,1,1), guide=F) +
  scale_linetype(guide=F) +
  guides(colour=F, fill=F)

p.stvr.var = ggplot(fut.ylds, aes(x=year, y=cumstvr, colour=GCM, linetype=site, alpha=slope, fill=RCP)) +
  geom_line() +
  facet_wrap(~trt, nrow=1) +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP45",], se=F, alpha=1, colour='cornflowerblue', linetype='solid') +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP85",], se=F, alpha=1, colour='firebrick', linetype='dashed') +
  scale_y_continuous(expand=c(0,0), limits=c(0,16500)) +
  ylab(expression(paste("Cumulative stover yield (gC ", m^-2,")"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank(),
        legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  scale_alpha_manual(values=c(1,1,1), guide = F)

p.agc.var = ggplot(fut.ylds, aes(x=year, y=cumagc, colour=GCM, linetype=site, alpha=slope, fill=RCP)) +
  geom_line() +
  facet_wrap(~trt, nrow=1) +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP45",], se=F, alpha=1, colour='cornflowerblue', linetype='solid') +
  geom_smooth(data=fut.ylds[fut.ylds$RCP=="RCP85",], se=F, alpha=1, colour='firebrick', linetype='dashed') +
  scale_y_continuous(expand=c(0,0), limits=c(0,27000)) +
  ylab(expression(paste("Cumulative aboveground yield (gC ", m^-2,")"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank(),
        legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  scale_alpha_manual(values=c(1,1,1), guide = F)

p.ylds.var = gridExtra::grid.arrange(p.grn.var,p.stvr.var, ncol = 1) 
ggsave(p.ylds.var, file=file.path(figdir, "Yields variability from 2009.pdf"), width=300, height=300, units="mm")
ggsave(p.agc.var, file=file.path(figdir, "Future_abovegroundC_variability.pdf"), width=250, height=150, units="mm")

### ANNUALIZING AND PLOTTING YIELD DATA USING FUTURE DATA ONLY IF USING DEFAULT FUT_HARV DATAFRAME. USE ALL_YLDS INSTEAD TO USE ALL DATA INCLUDING MEASURED AND MODELLED Pre-2009 DATA
# Creating average annual yields for each treatment to have a consistant format/dataframe structure - disregards crop type

fut.raw.ann = all_ylds[complete.cases(all_ylds$rot_phs),] # Disregard the final 'phase' as it is not a complete 12-year period

### TO CREATE A VISUAL REPRESENTATION ESTIMATE EVERY SINGLE 12-YEAR PERIOD FROM BEGINNING TO END
# Note - Everything that includes 1997 to 2009 data will not be applicable to summarise over treatments! But should work over crops

fut.ann2 = list()
for(i in 1985:2087) {
  tempdf = all_ylds[all_ylds$year>i&all_ylds$year<(i+13),]
  tempdf$phase = paste((i+1),(i+12),sep="-")
  tempdf$phaseno = i+6 # This depends how you want to present the data but +6 means the middle of the 12-year period assessed
  fut.ann2[[i]] <- tempdf
}

fut.raw.ann2 = rbindlist(fut.ann2)

### ANNOYINGLY NOT ALL GCM DATASETS WERE COMPLETE AND THEREFORE NEED TO REMOVE INCOMPLETE ONES 
# Note - the RCP4.5 data for the BNU GCM at Walsh is incomplete and ends ~2060 therefore phases after the last complete one need removing
# We can check by applying the assumption that different rotations should have a certain number of yield events within a phase
# For WF treatments it should be 36 (3 slopes, 2 entry points, 6 harvests), 72 for WCF (3*3*8), 108 for WCMF (3*4*9) and 36 for OPP (3*1*12)
# There are no HARVEST events for grass treatments so not included but this WILL need including for cinput calculations

newdf = data.frame()
yldlist = list()
phaselist = levels(as.factor(fut.raw.ann$rot_phs))
trtlist = levels(as.factor(fut.raw.ann$trt))
dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(site_list)*length(phaselist)*length(trtlist) # Maximum length of loop iterations to enable % complete display

temp = as.data.table(fut.raw.ann) # Subsetting is usually quicker using data tables rather than dataframes
test = temp[temp$year>2009,]

for(sit in site_list) {
  for(phas in phaselist) {
    for(tr in trtlist) {
      for(RC in RCP_list) {
        for(GC in GCM_list) {
          if(tr!="Grass") {
            if(tr=="WF") {
              if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
                newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                yldlist[[df_name]] <- newdf
              }
            }
            if(tr=="WCF") {
              if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==72) {
                newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                yldlist[[df_name]] <- newdf
              }
            }
            if(tr=="WCMF") {
              if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==108) {
                newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                yldlist[[df_name]] <- newdf
              }
            }
            if(tr=="OPP") {
              if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
                newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
                yldlist[[df_name]] <- newdf
              }
            }
          }
        }
      }
      dummy = c(dummy,1) # Just used to calculate the progress of this loop
      iteration = ((length(dummy))-1)/iter.n*100 # Just used to cal culate the progress of this loop
      print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
    }
  }
}

save(yldlist, file=file.path(Robjsdir, "yldlist")) # Maybe not needed for this one but definitely required for the next!
fut.raw.ann = rbindlist(yldlist) # Convert the list of dataframes to a single rbind'ed dataframe
save(fut.raw.ann, file=file.path(Robjsdir, "fut.raw.ann"))
fut.raw.ann = rbind(fut.raw.ann, temp[temp$year<2009,])

### Do the same for every single 12-year rotation

# ONLY RUN THIS IF YOU HAVE TO - IT WILL TAKE HOURS!!! INSTEAD, LOAD THE SAVED OBJECT FROM BEFORE

#newdf = data.frame()
#yldlist = list()
#phaselist = levels(as.factor(fut.raw.ann2$phase)) # DIFFERENT PHASE LIST
#trtlist = levels(as.factor(fut.raw.ann2$trt)) # Should be the same
#dummy=1 # Used to calculate the % completion of the loop below
#iter.n = length(site_list)*length(phaselist)*length(trtlist) # Maximum length of loop iterations to enable % complete display

temp = as.data.table(fut.raw.ann2) # Subsetting is usually quicker using data tables rather than dataframes
#test = temp[temp$year>2009,]

# THIS WILL TAKE HOURS!!!!! LOAD THE SAVED OBJECT INSTEAD IF NOTHING HAS CHANGED
load(file=file.path(Robjsdir, "fut.raw.ann2"))

#for(sit in site_list) {
#  for(phas in phaselist) {
#    for(tr in trtlist) {
#      for(RC in RCP_list) {
#        for(GC in GCM_list) {
#          if(tr!="Grass") {
#            if(tr=="WF") {
#              if(nrow(test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
#                newdf = test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
#                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                yldlist[[df_name]] <- newdf
#              }
#            }
#            if(tr=="WCF") {
#              if(nrow(test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==72) {
#                newdf = test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
#                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                yldlist[[df_name]] <- newdf
#              }
#            }
#            if(tr=="WCMF") {
#              if(nrow(test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==108) {
#                newdf = test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
#                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                yldlist[[df_name]] <- newdf
#              }
#            }
#            if(tr=="OPP") {
#              if(nrow(test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
#                newdf = test[which(phase==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
#                df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
#                yldlist[[df_name]] <- newdf
#              }
#            }
#          }
#        }
#      }
#      dummy = c(dummy,1) # Just used to calculate the progress of this loop
#      iteration = ((length(dummy))-1)/iter.n*100 # Just used to cal culate the progress of this loop
#      print(paste(round(iteration,2), " % complete", sep="")) # Just used to calculate the progress of this loop
#    }
#  }
#}

#save(yldlist, file=file.path(Robjsdir, "yldlist")) # Save the object as it took hours to run! Note - this will overwrite the last one
#fut.raw.ann2 = rbindlist(yldlist) # Convert the list of dataframes to a single rbind'ed dataframe
#save(fut.raw.ann2, file=file.path(Robjsdir, "fut.raw.ann2")) # This should be around 40 Mb
fut.raw.ann2 = rbind(fut.raw.ann2, temp[temp$year<=2009,])

temp = fut.raw.ann[,list(avg=mean(grn),
                         cum=sum(grn),
                         ann=sum(grn)/length(grn),
                         N=length(grn)),
                   by=list(rot_phs,site,slope,crop,treat,trt,RCP,GCM,source)]
temp$type = "Grain"
temp2 = fut.raw.ann[,list(avg=mean(stvr),
                          cum=sum(stvr),
                          ann=sum(stvr)/length(stvr),
                          N=length(stvr)),
                    by=list(rot_phs,site,slope,crop,treat,trt,RCP,GCM,source)]
temp2$type = "Stover"

fut.raw.ann = rbind(as.data.frame(temp), as.data.frame(temp2))

# Do the same with the 12-year phases for all years
temp = fut.raw.ann2[,list(avg=mean(grn),
                          cum=sum(grn),
                          ann=sum(grn)/length(grn),
                          N=length(grn)),
                    by=list(phase,phaseno,site,slope,crop,treat,trt,RCP,GCM,source)]
temp$type = "Grain"
temp2 = fut.raw.ann2[,list(avg=mean(stvr),
                           cum=sum(stvr),
                           ann=sum(stvr)/length(stvr),
                           N=length(stvr)),
                     by=list(phase,phaseno,site,slope,crop,treat,trt,RCP,GCM,source)]
temp2$type = "Stover"

fut.raw.ann2 = rbind(as.data.frame(temp), as.data.frame(temp2))

### Cumulative values should be correct for modelled data but this keeps as consistent with earlier process

fut.raw.ann$cum[fut.raw.ann$trt=="WF"&fut.raw.ann$crop=="Wheat"] = fut.raw.ann$ann[fut.raw.ann$trt=="WF"&fut.raw.ann$crop=="Wheat"]*6 # 6 wheat harvests over the 12-year phase for WF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCF"&fut.raw.ann$crop=="Wheat"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCF"&fut.raw.ann$crop=="Wheat"]*4 # 4 wheat harvests over the 12-year phase for WCF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCF"&fut.raw.ann$crop=="Corn"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCF"&fut.raw.ann$crop=="Corn"]*4 # 4 corn harvests over the 12-year phase for WCF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Wheat"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Wheat"]*3 # 3 wheat harvests over the 12-year phase for WCMF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Corn"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Corn"]*3 # 3 corn harvests over the 12-year phase for WCMF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Millet"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCMF"&fut.raw.ann$crop=="Millet"]*3 # 3 millet harvests over the 12-year phase for WCMF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="OPP"&fut.raw.ann$crop=="Wheat"] = fut.raw.ann$ann[fut.raw.ann$trt=="OPP"&fut.raw.ann$crop=="Wheat"]*12 # 12 wheat harvests (in theory) over the 12-year phase for OPP rotations

fut.raw.ann2$cum[fut.raw.ann2$trt=="WF"&fut.raw.ann2$crop=="Wheat"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WF"&fut.raw.ann2$crop=="Wheat"]*6 # 6 wheat harvests over the 12-year phase for WF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="WCF"&fut.raw.ann2$crop=="Wheat"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WCF"&fut.raw.ann2$crop=="Wheat"]*4 # 4 wheat harvests over the 12-year phase for WCF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="WCF"&fut.raw.ann2$crop=="Corn"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WCF"&fut.raw.ann2$crop=="Corn"]*4 # 4 corn harvests over the 12-year phase for WCF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Wheat"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Wheat"]*3 # 3 wheat harvests over the 12-year phase for WCMF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Corn"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Corn"]*3 # 3 corn harvests over the 12-year phase for WCMF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Millet"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="WCMF"&fut.raw.ann2$crop=="Millet"]*3 # 3 millet harvests over the 12-year phase for WCMF rotations
fut.raw.ann2$cum[fut.raw.ann2$trt=="OPP"&fut.raw.ann2$crop=="Wheat"] = fut.raw.ann2$ann[fut.raw.ann2$trt=="OPP"&fut.raw.ann2$crop=="Wheat"]*12 # 12 wheat harvests (in theory) over the 12-year phase for OPP rotations

# Annualizing yields over each phase (12-year period) - essentially same as dividing by rotation length

fut.raw.ann$anlz = ifelse(fut.raw.ann$N==12,fut.raw.ann$ann,fut.raw.ann$ann*(1-(fut.raw.ann$N/12)))
fut.raw.ann2$anlz = ifelse(fut.raw.ann2$N==12,fut.raw.ann2$ann,fut.raw.ann2$ann*(1-(fut.raw.ann2$N/12))) 

### PLOT RESULTING YIELD DATA IN DIFFERENT WAYS (CONTINUOUS/DISCRETE PHASES/BY CROP/TREATMENT)

fut.phs.annualised = ddply(fut.raw.ann, c("rot_phs", "crop", "trt", "RCP", "type", "source"), summarise,
                           N=length(ann),
                           ann.mean=mean(ann),
                           ann.se=sd(ann)/sqrt(length(ann)), 
                           ann.ymin=mean(ann)-(sd(ann)/sqrt(length(ann))),
                           ann.ymax=mean(ann)+(sd(ann)/sqrt(length(ann))),
                           cum.mean=mean(cum),
                           cum.se=sd(cum)/sqrt(length(cum)), 
                           cum.ymin=mean(cum)-(sd(cum)/sqrt(length(cum))),
                           cum.ymax=mean(cum)+(sd(cum)/sqrt(length(cum))),
                           anlz.mean=mean(anlz),
                           anlz.se=sd(anlz)/sqrt(length(anlz)), 
                           anlz.ymin=mean(anlz)-(sd(anlz)/sqrt(length(anlz))),
                           anlz.ymax=mean(anlz)+(sd(anlz)/sqrt(length(anlz))))

future.annualised = ddply(fut.raw.ann2, c("phaseno", "phase", "crop", "trt", "RCP", "type", "source"), summarise,
                           N=length(ann),
                           ann.mean=mean(ann),
                           ann.ymin=quantile(ann, probs=0.025),
                           ann.ymax=quantile(ann, probs=0.975),
                           cum.mean=mean(cum),
                           cum.ymin=quantile(cum, probs=0.025),
                           cum.ymax=quantile(cum, probs=0.975),
                           anlz.mean=mean(anlz),
                           anlz.ymin=quantile(anlz, probs=0.025),
                           anlz.ymax=quantile(anlz, probs=0.975))

fut.crp.annualised = ddply(fut.raw.ann, c("rot_phs", "crop", "RCP", "type", "source"), summarise,
                          N=length(ann),
                          ann.mean=mean(ann),
                          ann.se=sd(ann)/sqrt(length(ann)), 
                          ann.ymin=mean(ann)-(sd(ann)/sqrt(length(ann))),
                          ann.ymax=mean(ann)+(sd(ann)/sqrt(length(ann))),
                          cum.mean=mean(cum),
                          cum.se=sd(cum)/sqrt(length(cum)), 
                          cum.ymin=mean(cum)-(sd(cum)/sqrt(length(cum))),
                          cum.ymax=mean(cum)+(sd(cum)/sqrt(length(cum))),
                          anlz.mean=mean(anlz),
                          anlz.se=sd(anlz)/sqrt(length(anlz)), 
                          anlz.ymin=mean(anlz)-(sd(anlz)/sqrt(length(anlz))),
                          anlz.ymax=mean(anlz)+(sd(anlz)/sqrt(length(anlz))))

fut.phs.annualised2 = ddply(fut.raw.ann, c("rot_phs", "trt", "RCP", "type", "source"), summarise,
                          N=length(ann),
                          ann.mean=mean(ann),
                          ann.se=sd(ann)/sqrt(length(ann)), 
                          ann.ymin=mean(ann)-(sd(ann)/sqrt(length(ann))),
                          ann.ymax=mean(ann)+(sd(ann)/sqrt(length(ann))),
                          cum.mean=mean(cum),
                          cum.se=sd(cum)/sqrt(length(cum)), 
                          cum.ymin=mean(cum)-(sd(cum)/sqrt(length(cum))),
                          cum.ymax=mean(cum)+(sd(cum)/sqrt(length(cum))),
                          anlz.mean=mean(anlz),
                          anlz.se=sd(anlz)/sqrt(length(anlz)), 
                          anlz.ymin=mean(anlz)-(sd(anlz)/sqrt(length(anlz))),
                          anlz.ymax=mean(anlz)+(sd(anlz)/sqrt(length(anlz))))

future.annualised2 = ddply(fut.raw.ann2, c("phase", "phaseno", "trt", "RCP", "type", "source"), summarise,
                           N=length(ann),
                           ann.mean=mean(ann),
                           ann.ymin=quantile(ann, probs=0.025),
                           ann.ymax=quantile(ann, probs=0.975),
                           cum.mean=mean(cum),
                           cum.ymin=quantile(cum, probs=0.025),
                           cum.ymax=quantile(cum, probs=0.975),
                           anlz.mean=mean(anlz),
                           anlz.ymin=quantile(anlz, probs=0.025),
                           anlz.ymax=quantile(anlz, probs=0.975))

fut.crp.annualised2 = ddply(fut.raw.ann2, c("phaseno", "phase", "crop", "RCP", "type", "source"), summarise,
                           N=length(ann),
                           ann.mean=mean(ann),
                           ann.ymin=quantile(ann, probs=0.025),
                           ann.ymax=quantile(ann, probs=0.975),
                           cum.mean=mean(cum),
                           cum.ymin=quantile(cum, probs=0.025),
                           cum.ymax=quantile(cum, probs=0.975),
                           anlz.mean=mean(anlz),
                           anlz.ymin=quantile(anlz, probs=0.025),
                           anlz.ymax=quantile(anlz, probs=0.975))

# The averaging as above will not work over treatments before 2009 because of the changes to WF and WCMF between 1997 and 2009
futphases = c("2010 - 2021","2022 - 2033","2034 - 2045","2046 - 2057","2058 - 2069","2070 - 2081","2082 - 2093")

p.anlz.crp = ggplot(fut.phs.annualised[fut.phs.annualised$rot_phs %in% futphases,], aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=150, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~RCP*crop*trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,160)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

p.anlz.crp2 = ggplot(future.annualised[future.annualised$phaseno>=2015,], aes(x=phaseno, y=anlz.mean)) +
  geom_line(aes(colour=type, linetype=type)) +
  facet_wrap(~RCP*crop*trt, nrow=2) +
  geom_ribbon(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), alpha = 0.2) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_fill_manual("Yield Type",
                    values = c("darkorchid4","forestgreen"),
                    labels = c("Grain", "Stover")) +
  scale_linetype_manual("Yield Type",
                    values = c("solid","dashed"),
                    labels = c("Grain", "Stover")) +
  scale_colour_manual("Yield Type",
                      values = c("darkorchid4","forestgreen"),
                      labels = c("Grain", "Stover"))

p.anlz.fut = ggplot(fut.phs.annualised2[fut.phs.annualised2$rot_phs %in% futphases,], aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=150, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~trt*RCP, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,160)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

p.anlz.fut2 = ggplot(future.annualised2[future.annualised2$phaseno>=2015,], aes(x=phaseno, y=anlz.mean)) +
  geom_line(aes(colour=type, linetype=type)) +
  facet_wrap(~trt*RCP, nrow=4) +
  geom_ribbon(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), alpha = 0.2) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

p.anlz.notrt = ggplot(fut.crp.annualised[fut.crp.annualised$source=="Modelled",], aes(x=rot_phs, y=ann.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=195, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~RCP*crop, nrow=2) +
  geom_errorbar(aes(ymax=ann.ymax, ymin=ann.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,210)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.text.x = element_text(angle=-90, vjust=0.5),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

temp = fut.crp.annualised[fut.crp.annualised$source=="Measured",]
temp$phaseno = ifelse(temp$rot_phs=="1986 - 1997", 1996, 2008)

p.anlz.notrt2 = ggplot(fut.crp.annualised2[fut.crp.annualised2$source=="Modelled"&fut.crp.annualised2$RCP=="RCP85",], aes(x=phaseno-5, y=ann.mean)) +
  geom_vline(aes(xintercept=1997.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009.5), linetype="dashed", alpha=0.5) +
  geom_line(aes(colour=type, linetype=type)) +
  geom_point(data=temp[temp$RCP=="RCP85",], aes(colour=type)) +
  geom_errorbar(data=temp[temp$RCP=="RCP85",], aes(ymin=ann.ymin, ymax=ann.ymax, colour=type), width=2) +
  facet_wrap(~crop, nrow=1) +
  geom_ribbon(aes(ymax=ann.ymax, ymin=ann.ymin, fill=type), alpha = 0.2) +
  scale_x_continuous(expand=c(0,0), limits=c(1984,2100), breaks=c(1985,2005,2025,2045,2065,2085)) +
  scale_y_continuous(expand=c(0,0), limits=c(0,350)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2,")"))) +
  xlab("Year") +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        axis.text.x = element_text(angle = 45, hjust = 0.8, vjust = 0.8),
        panel.grid = element_blank())

# DECIDE HOW YOU WANT TO COMPARE 'RELATIVE' VALUES - WHAT IS THE BASELINE

temp = fut.raw.ann2[fut.raw.ann2$source=="Measured",] # Baseline is average of all available measured yield data between 1985 and 2009 (Most accurate to compare to measured data)
#temp = fut.raw.ann2[fut.raw.ann2$source=="Modelled"&fut.raw.ann2$phaseno>1990&fut.raw.ann2$phaseno<2015,] # Baseline is average of all available modelled yield data between 1985 and 2009 (Should be roughly accurate display of above and below 0 before 2009)
#temp = fut.raw.ann2[fut.raw.ann2$source=="Measured"&fut.raw.ann2$phaseno==2014,] # Baseline is 2009 measured values (last year of measured yield data)
#temp = fut.raw.ann2[fut.raw.ann2$source=="Modelled"&fut.raw.ann2$phaseno==2015,] # Baseline is 2010 modelled values (most aesthetically pleasing)

crngrain = mean(temp$ann[temp$crop=="Corn"&temp$type=="Grain"&temp$RCP=="RCP45"])
whtgrain = mean(temp$ann[temp$crop=="Wheat"&temp$type=="Grain"&temp$RCP=="RCP45"])
crnstvr = mean(temp$ann[temp$crop=="Corn"&temp$type=="Stover"&temp$RCP=="RCP45"])
whtstvr = mean(temp$ann[temp$crop=="Wheat"&temp$type=="Stover"&temp$RCP=="RCP45"])

# MILLET BASELINE MUST BE DIFFERENT AS THE DATASET IS UNBALANCED IN YEARS AND YIELDS ARE VARIBALE
temp = fut.raw.ann2[fut.raw.ann2$source=="Modelled"&fut.raw.ann2$phaseno>2001,] # Baseline is average of all available measured yield data between 1985 and 2009 (Most accurate to compare to measured data)
mltgrain = mean(temp$ann[temp$crop=="Millet"&temp$type=="Grain"&temp$RCP=="RCP45"])
mltstvr = mean(temp$ann[temp$crop=="Millet"&temp$type=="Stover"&temp$RCP=="RCP45"])

#temp = fut.crp.annualised2[fut.crp.annualised2$source=="Modelled"&fut.crp.annualised2$phaseno<2015,] # Baseline is average of averaged modelled yield data between 1985 and 2009 (Most accurate display of above and below 0 before 2009)

#crngrain = mean(temp$ann.mean[temp$crop=="Corn"&temp$type=="Grain"&temp$RCP=="RCP45"])
#whtgrain = mean(temp$ann.mean[temp$crop=="Wheat"&temp$type=="Grain"&temp$RCP=="RCP45"])
#mltgrain = mean(temp$ann.mean[temp$crop=="Millet"&temp$type=="Grain"&temp$RCP=="RCP45"])
#crnstvr = mean(temp$ann.mean[temp$crop=="Corn"&temp$type=="Stover"&temp$RCP=="RCP45"])
#whtstvr = mean(temp$ann.mean[temp$crop=="Wheat"&temp$type=="Stover"&temp$RCP=="RCP45"])
#mltstvr = mean(temp$ann.mean[temp$crop=="Millet"&temp$type=="Stover"&temp$RCP=="RCP45"])

temp = fut.crp.annualised2[fut.crp.annualised2$type=="Grain",]
temp$chng[temp$crop=="Wheat"] = (100-(temp$ann.mean[temp$crop=="Wheat"]/whtgrain*100))*-1
temp$chngmn[temp$crop=="Wheat"] = (100-(temp$ann.ymin[temp$crop=="Wheat"]/whtgrain*100))*-1
temp$chngmx[temp$crop=="Wheat"] = (100-(temp$ann.ymax[temp$crop=="Wheat"]/whtgrain*100))*-1
temp$chng[temp$crop=="Corn"] = (100-(temp$ann.mean[temp$crop=="Corn"]/crngrain*100))*-1
temp$chngmn[temp$crop=="Corn"] = (100-(temp$ann.ymin[temp$crop=="Corn"]/crngrain*100))*-1
temp$chngmx[temp$crop=="Corn"] = (100-(temp$ann.ymax[temp$crop=="Corn"]/crngrain*100))*-1
temp$chng[temp$crop=="Millet"] = (100-(temp$ann.mean[temp$crop=="Millet"]/mltgrain*100))*-1
temp$chngmn[temp$crop=="Millet"] = (100-(temp$ann.ymin[temp$crop=="Millet"]/mltgrain*100))*-1
temp$chngmx[temp$crop=="Millet"] = (100-(temp$ann.ymax[temp$crop=="Millet"]/mltgrain*100))*-1

temp2 = fut.crp.annualised2[fut.crp.annualised2$type=="Stover",]
temp2$chng[temp2$crop=="Wheat"] = (100-(temp2$ann.mean[temp2$crop=="Wheat"]/whtstvr*100))*-1
temp2$chngmn[temp2$crop=="Wheat"] = (100-(temp2$ann.ymin[temp2$crop=="Wheat"]/whtstvr*100))*-1
temp2$chngmx[temp2$crop=="Wheat"] = (100-(temp2$ann.ymax[temp2$crop=="Wheat"]/whtstvr*100))*-1
temp2$chng[temp2$crop=="Corn"] = (100-(temp2$ann.mean[temp2$crop=="Corn"]/crnstvr*100))*-1
temp2$chngmn[temp2$crop=="Corn"] = (100-(temp2$ann.ymin[temp2$crop=="Corn"]/crnstvr*100))*-1
temp2$chngmx[temp2$crop=="Corn"] = (100-(temp2$ann.ymax[temp2$crop=="Corn"]/crnstvr*100))*-1
temp2$chng[temp2$crop=="Millet"] = (100-(temp2$ann.mean[temp2$crop=="Millet"]/mltstvr*100))*-1
temp2$chngmn[temp2$crop=="Millet"] = (100-(temp2$ann.ymin[temp2$crop=="Millet"]/mltstvr*100))*-1
temp2$chngmx[temp2$crop=="Millet"] = (100-(temp2$ann.ymax[temp2$crop=="Millet"]/mltstvr*100))*-1

temp = rbind(temp,temp2)
temp$year = temp$phaseno-5
temp = temp[temp$year!=2009,] # Simple fix for spike caused by extending simulation

p.crop.ylds = ggplot(temp[temp$source=="Modelled"&temp$year>=2010,], aes(x=year, y=chng)) +
  geom_vline(aes(xintercept=1997.5), linetype="dotted", alpha=0.5) +
  geom_vline(aes(xintercept=2010), linetype="dotted", alpha=0.5) +
  geom_hline(aes(yintercept=0), linetype="dashed", colour='black') +
  geom_line(aes(colour=RCP, linetype=RCP)) +
  geom_line(data=temp[temp$source=="Modelled"&temp$year<=2010,], colour='black', alpha=0.5) +
#  geom_line(data=temp[temp$source=="Measured",], colour='darkgreen') +
#  geom_point(data=temp[temp$RCP=="RCP85",], aes(colour=type)) +
#  geom_errorbar(data=temp[temp$RCP=="RCP85",], aes(ymin=ann.ymin, ymax=ann.ymax, colour=type), width=2) +
  facet_wrap(~crop*type, nrow=3) +
#  geom_ribbon(aes(ymax=chngmx, ymin=chngmn, fill=RCP), alpha = 0.2) +
#  geom_ribbon(data=temp[temp$source=="Modelled"&temp$year<=2010,], fill='black', alpha=0.5, aes(ymax=chngmx, ymin=chngmn, fill=RCP)) +
  scale_x_continuous(expand=c(0,0), limits=c(1986,2086), breaks=c(1986,2006,2026,2046,2066,2086), labels=c(1985,2005,2025,2045,2065,2085)) +
  scale_y_continuous(expand=c(0,0), limits=c(-70,70), breaks=c(-50,-25,0,25,50)) +
  ylab(expression(paste("Relative change in yield (%)"))) +
  xlab("Year") +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        axis.text.x = element_text(angle = 45, hjust = 0.8, vjust = 0.8),
        panel.grid = element_blank()) +
  scale_fill_manual("RCP Scenario",
                    values = c("cornflowerblue","firebrick"),
                    labels = c("RCP 4.5", "RCP 8.5"), guide=F) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) 

ggsave(p.crop.ylds, file=file.path(figdir, "FigureX - Crop yields relative.pdf"), width=250, height=200, units="mm")
ggsave(p.anlz.notrt, file=file.path(figdir, "Crop yields no trts annualised_byphs.pdf"), width=450, height=300, units="mm")
ggsave(p.anlz.notrt2, file=file.path(figdir, "FigureX - Crop yields timeline.pdf"), width=400, height=150, units="mm")
ggsave(p.anlz.crp, file=file.path(figdir, "Future crop yields annualised_byphs.pdf"), width=450, height=300, units="mm")
ggsave(p.anlz.crp2, file=file.path(figdir, "Future crop yields annualised.pdf"), width=450, height=200, units="mm")
ggsave(p.anlz.fut, file=file.path(figdir, "Future yields annualised_byphs.pdf"), width=450, height=300, units="mm")
ggsave(p.anlz.fut2, file=file.path(figdir, "Future yields annualised.pdf"), width=450, height=300, units="mm")

write.csv(fut.crp.annualised, file=file.path(figdir, "crop yields by phase.csv"))

# Remove unwanted dataframes

rm(harvest, harvest_data, newdf, test)
