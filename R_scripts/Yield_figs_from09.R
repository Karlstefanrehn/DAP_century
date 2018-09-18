# ------------------------------------------------------------------------------#
### PRODUCES FIGURES TO REPRESENT SIMULATED GRAIN AND STOVER YIELDS 2009-2100 ###
# ------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

###############
## IMPORT HARVEST OBJECTS FROM FUTURE SCENARIOS
###############

### VARIABLES TO BE IMPORTED

harv_vars = c('agcacc','cgrain') # These are the variables you wish to import from the harvest.csv model output file
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

# To see full grain yield variability over time

ggplot(fut_harvs, aes(x=time, y=mavg_cgrain, colour=GCM, linetype=slope, alpha=RCP)) +
  geom_line() +
  facet_wrap(~site*trt)

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

save(fut_harvs, file=file.path(Robjsdir, "fut_harvs"))

# Average over all entry points to reduce number of facets
fut.yld.summary = ddply(fut_harvs, c("year","site","slope","trt","GCM","RCP","rot_phs","source"), summarise,
                        agcacc.x = mean(agcacc),
                        cgrain.x = mean(cgrain),
                        stvr.x = mean(stvr),
                        n = length(cgrain)) # Assumes same number of observations for all variables

# To plot variation of all yield measurements we need to plot cumulative values 

fut.ylds = within(fut.yld.summary, {
  cumagc <- ave(agcacc.x, site, slope, trt, GCM, RCP, FUN = cumsum)
  cumstvr <- ave(stvr.x, site, slope, trt, GCM, RCP, FUN = cumsum)
  cumgrn <- ave(cgrain.x, site, slope, trt, GCM, RCP, FUN = cumsum)
})

p.grn.var = ggplot(fut.ylds, aes(x=year, y=cumgrn, colour=GCM, linetype=slope, alpha=RCP)) +
  geom_line() +
  facet_wrap(~site*trt, nrow=3) +
  scale_y_continuous(expand=c(0,0), limits=c(0,max(fut.ylds$cumgrn)*1.05)) +
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
  scale_alpha_manual(values=c(0.5, 1))

p.stv.var = ggplot(fut.ylds, aes(x=year, y=cumstvr, colour=GCM, linetype=slope, alpha=RCP)) +
  geom_line() +
  facet_wrap(~site*trt, nrow=3) +
  scale_y_continuous(expand=c(0,0), limits=c(0,max(fut.ylds$cumstvr)*1.05)) +
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
        panel.grid = element_blank()) +
  scale_alpha_manual(values=c(0.5, 1))

p.agc.var = ggplot(fut.ylds, aes(x=year, y=cumagc, colour=GCM, linetype=slope, alpha=RCP)) +
  geom_line() +
  facet_wrap(~site*trt, nrow=3) +
  scale_y_continuous(expand=c(0,0), limits=c(0,max(fut.ylds$cumagc)*1.05)) +
  ylab(expression(paste("Cumulative aboveground C (gC ", m^-2,")"))) +
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
  scale_alpha_manual(values=c(0.5, 1))

ggsave(p.grn.var, file=file.path(figdir, "Future_grain_variability.pdf"), width=500, height=300, units="mm")
ggsave(p.stv.var, file=file.path(figdir, "Future_stover_variability.pdf"), width=500, height=300, units="mm")
ggsave(p.agc.var, file=file.path(figdir, "Future_abovegroundC_variability.pdf"), width=500, height=300, units="mm")

# Creating average annual yields for each treatment to have a consistant format/dataframe structure - disregards crop type

fut.raw.ann = fut_harvs[complete.cases(fut_harvs$rot_phs),] # Disregard the final 'phase' as it is not a complete 12-year period

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

test = as.data.table(fut.raw.ann) # Subsetting is usually quicker using data tables rather than dataframes

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

fut.raw.ann = rbindlist(yldlist) # Convert the list of dataframes to a single rbind'ed dataframe

fut.raw.ann = rbind(ddply(fut.raw.ann, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "RCP", "GCM", "source"), summarise,
                          N = length(cgrain),
                          cum = sum(cgrain),
                          ann = cum/N,
                          type = "Grain"),
                    ddply(fut.raw.ann, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "RCP", "GCM", "source"), summarise,                     
                          N = length(stvr),
                          cum = sum(stvr),
                          ann = cum/N,
                          type = "Stover"))

### Cumulative values should be correct for modelled data but this keeps as consistent with earlier process

fut.raw.ann$cum[fut.raw.ann$trt=="WF"] = fut.raw.ann$ann[fut.raw.ann$trt=="WF"]*6 # 6 harvests over the 12-year phase for WF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCF"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCF"]*8 # 8 harvests over the 12-year phase for WCF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="WCMF"] = fut.raw.ann$ann[fut.raw.ann$trt=="WCMF"]*9 # 9 harvests over the 12-year phase for WCMF rotations
fut.raw.ann$cum[fut.raw.ann$trt=="OPP"] = fut.raw.ann$ann[fut.raw.ann$trt=="OPP"]*12 # 12 harvests (in theory) over the 12-year phase for OPP rotations

# Annualizing yields over each phase (12-year period) - essentially same as dividing by rotation length

fut.raw.ann$anlz = fut.raw.ann$cum/12 

future.annualised = ddply(fut.raw.ann, c("rot_phs", "site", "trt", "RCP", "type", "source"), summarise,
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

future.annualised2 = ddply(fut.raw.ann, c("rot_phs", "trt", "RCP", "type", "source"), summarise,
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

p.anlz.fut = ggplot(future.annualised, aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=150, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~site*trt*RCP, nrow=4) +
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

p.anlz.fut2 = ggplot(future.annualised2, aes(x=rot_phs, y=anlz.mean)) +
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

ggsave(p.anlz.fut, file=file.path(figdir, "Future yields annualised_bysite.pdf"), width=450, height=300, units="mm")
ggsave(p.anlz.fut2, file=file.path(figdir, "Future yields annualised.pdf"), width=450, height=300, units="mm")

save(fut.raw.ann, file=file.path(Robjsdir, "fut.raw.ann"))

# Remove unwanted dataframes

rm(harvest, harvest_data, newdf, test)