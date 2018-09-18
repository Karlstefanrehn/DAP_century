# -----------------------------------------------------------------------------#
### PRODUCES FIGURES TO COMPARE SIMULATION YIELD RESULTS AND MEASURED VALUES ###
### calibration and validation treated discretely examining 1986-2009 yields ###
# -----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

dodge = position_dodge(width=0.9) # Needed for figures

######################
### COMPARE STOVER AND GRAIN YIELDS SEPARATELY AVERAGED OVER SLOPES AND TREATMENTS
######################

# USED FOR PARAMETERIZATION/VALIDATION - half used to parameterise, half to validate
mod.evens = mod.raw.ylds[mod.raw.ylds$year%%2==0,]
mod.odds = mod.raw.ylds[mod.raw.ylds$year%%2==1,]
meas.evens = meas.raw.ylds[meas.raw.ylds$year%%2==0,]
meas.odds = meas.raw.ylds[meas.raw.ylds$year%%2==1,]

# TWO DATASETS ARE NEEDED FOR THE CALIBRATION:
# 1) Full dataset used to compare measured and modelled data statistically (evens.raw and odds.raw below)
# 2) Averaged dataset used to graph the values as they are averaged and their standard errors (evens.all and odds.all below)

mod.evens.raw = rbind(ddply(mod.evens[complete.cases(mod.evens$cgrain),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                           N = length(cgrain),
                           mean = mean(cgrain),
                           se = sd(cgrain)/sqrt(length(cgrain)),
                           ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                           ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                           type = "Grain"),
                     ddply(mod.evens[complete.cases(mod.evens$stvr),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,                     
                           N = length(stvr),
                           mean = mean(stvr),
                           se = sd(stvr)/sqrt(length(stvr)),
                           ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                           ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                           type = "Stover"))

mod.odds.raw = rbind(ddply(mod.odds[complete.cases(mod.odds$cgrain),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                            N = length(cgrain),
                            mean = mean(cgrain),
                            se = sd(cgrain)/sqrt(length(cgrain)),
                            ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                            ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                            type = "Grain"),
                      ddply(mod.odds[complete.cases(mod.odds$stvr),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,                     
                            N = length(stvr),
                            mean = mean(stvr),
                            se = sd(stvr)/sqrt(length(stvr)),
                            ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                            ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                            type = "Stover"))

meas.evens.raw = rbind(ddply(meas.evens[complete.cases(meas.evens$st_yld),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),         
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.evens[complete.cases(meas.evens$gr_yld),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.odds.raw = rbind(ddply(meas.odds[complete.cases(meas.odds$st_yld),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                             N=length(st_yld),
                             mean=mean(st_yld),
                             se=sd(st_yld)/sqrt(length(st_yld)),         
                             ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                             ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                             type="Stover"),  
                       ddply(meas.odds[complete.cases(meas.odds$gr_yld),], c("year", "rot_phs", "site", "slope", "crop", "treat", "trt", "source"), summarise,
                             N=length(gr_yld),                                             
                             mean=mean(gr_yld),
                             se=sd(gr_yld)/sqrt(length(gr_yld)),
                             ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                             ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                             type="Grain"))

evens.raw = merge(meas.evens.raw, mod.evens.raw, by=c("year","rot_phs","site","slope","crop","treat","trt","type"))
odds.raw = merge(meas.odds.raw, mod.odds.raw, by=c("year","rot_phs","site","slope","crop","treat","trt","type"))

# Creating objects with raw data but consistant format/dataframe structures (even at top level measured has 2 strips but modelled is only 1)
# NOTE - This averaging depends on the determination (i.e. does slope or treatment need to be accounted for when calibrating parameters?)

# FOR THIS CALIBRATION THE SITE AND CROP ARE ALL THAT WAS DEEMED ESSENTIAL FOR CALIBRATION WITH RATIONALE THAT A LARGER SAMPLE SIZE IS MORE REPRESENTATIVE OF SAID CROP (PARAMETERS WERE CALIBRATED FOR DIFFERENT SITES SEPERATELY)

evens.all = rbind(ddply(mod.evens[complete.cases(mod.evens$cgrain),], c("site", "crop", "source"), summarise,
                        N = length(cgrain),
                        mean = mean(cgrain),
                        se = sd(cgrain)/sqrt(length(cgrain)),
                        ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                        ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                        type = "Grain"),
                  ddply(mod.evens[complete.cases(mod.evens$stvr),], c("site","crop", "source"), summarise,                     
                        N = length(stvr),
                        mean = mean(stvr),
                        se = sd(stvr)/sqrt(length(stvr)),
                        ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                        ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                        type = "Stover"),
                  ddply(meas.evens[complete.cases(meas.evens$gr_yld),], c("site", "crop", "source"), summarise,
                        N = length(gr_yld),
                        mean = mean(gr_yld),
                        se = sd(gr_yld)/sqrt(length(gr_yld)),
                        ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                        ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                        type = "Grain"),
                  ddply(meas.evens[complete.cases(meas.evens$st_yld),], c("site","crop", "source"), summarise,                     
                        N = length(st_yld),
                        mean = mean(st_yld),
                        se = sd(st_yld)/sqrt(length(st_yld)),
                        ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                        ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                        type = "Stover"))

odds.all = rbind(ddply(mod.odds[complete.cases(mod.odds$cgrain),], c("site", "crop", "source"), summarise,
                        N = length(cgrain),
                        mean = mean(cgrain),
                        se = sd(cgrain)/sqrt(length(cgrain)),
                        ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                        ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                        type = "Grain"),
                  ddply(mod.odds[complete.cases(mod.odds$stvr),], c("site","crop", "source"), summarise,                     
                        N = length(stvr),
                        mean = mean(stvr),
                        se = sd(stvr)/sqrt(length(stvr)),
                        ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                        ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                        type = "Stover"),
                  ddply(meas.odds[complete.cases(meas.odds$gr_yld),], c("site", "crop", "source"), summarise,
                        N = length(gr_yld),
                        mean = mean(gr_yld),
                        se = sd(gr_yld)/sqrt(length(gr_yld)),
                        ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                        ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                        type = "Grain"),
                  ddply(meas.odds[complete.cases(meas.odds$st_yld),], c("site","crop", "source"), summarise,                     
                        N = length(st_yld),
                        mean = mean(st_yld),
                        se = sd(st_yld)/sqrt(length(st_yld)),
                        ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                        ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                        type = "Stover"))

### LIMIT THE DATASET TO KEY CROPS ONLY - insufficient data for lesser crops

evens.all = evens.all[evens.all$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),]
odds.all = odds.all[odds.all$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),]
evens.all = evens.all[evens.all$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),]
odds.all = odds.all[odds.all$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),]

### NOW THAT OBJECTS ARE CREATED WE CAN CALCULATE THE RMSE AND R2 (and other metrics if you wish)

# DATAFRAME STRUCTURE - FACTOR LEVELS (used to create all permeatations balancing graph objects)
years = c(1985:2010) # Unused in initial calibration
phases = c("1986-1997","1998-2009") # Unused in initial calibration
sites = c("Sterling","Stratton","Walsh")
slopes = c("Summit","Sideslope","Toeslope") # Unused in initial calibration
crops = c("Corn","Wheat","Sorghum","Millet")
treats = c("WF","FW","WCM","CMW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","WCMW","CMWW","MWWC","WWCM","OPP") # Unused in initial calibration 
trts = c("WF","WCM","WCF","WCMF","WWCM","OPP") # Unused in initial calibration
treatnos = c(1:10) # Unused in initial calibration
types = c("Grain","Stover")
sources = c("Modelled","Measured")

dummy = expand.grid(site=sites,crop=crops,type=types) # All combinations of sites/crops/yield types
# NOTE - IF YOU WISH TO CALIBRATE SMALLER DATASETS (i.e. OVER SLOPE) THIS WILL NEED TO BE ABOVE

cal.df = evens.all # Decide on which dataset will be calibration and which will be validation
cal.stat = evens.raw # Choose the same as above
cal.df = merge(cal.df,dummy,all=T) # Merge to create all permeatations

### FUNCTION NEEDED TO CALCULATE RMSE AND R2 WHEN COMPARING MEASURED/MODELLED

# This function requires the name of the 'cbind' dataframe used to house raw modelled/measured yieds
# and outputs a new dataframe with RMSE and R2 for linear regressions between each site-crop-yield type
# Additionally for() loops can easily be added to include other factors (e.g. rot_phs) using objects above

mm.rmse.func = function(df){
  output = data.frame(site="Sterling",crop="Sorghum",type="Grain",source="Measured",rmse=NA,rsq=NA,mae=NA)
  for(sit in sites){
    for (crp in crops){
      for (typ in types){
        if(nrow(df[df$site==sit&df$crop==crp&df$type==typ,])<1) next
        newdf = df[df$site==sit&df$crop==crp&df$type==typ,]
        rms = sqrt(mean((newdf$mean.y-newdf$mean.x)^2, na.rm=T))
        me = mean(abs((newdf$mean.y-newdf$mean.x)), na.rm=T)
        print(rms)
        lmod = lm(mean.y~mean.x+0, newdf)
        rs = summary(lmod)$r.squared
        output = rbind(output, data.frame(site=sit,crop=crp,type=typ,source="Measured",rmse=rms,rsq=rs,mae=me))
      }
    }
  }
  return(output)
}

cal.rmse = mm.rmse.func(cal.stat)
cal.rmse = merge(cal.rmse,cal.df,all=T)

### GRAPH THE RESULTING COMPARISON DISPLAYING:
# Measured and modelled grain and stover yields compared at the site-crop level
# Sample size used to create RMSE and R2 values are shown (n=) as well as RMSE and R2

p.yld.calibration = ggplot(cal.rmse, aes(x = type, y = mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=250, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=cal.rmse[!rowSums(is.na(cal.rmse)),], aes(y=272,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=cal.rmse[!rowSums(is.na(cal.rmse)),], aes(y=292,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=cal.rmse[!rowSums(is.na(cal.rmse)),], aes(y=312,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*crop, ncol=4, nrow=3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,319)) +
  ylab(expression(paste("Yields (gC ", m^-2,")"))) +
  ggtitle("Averaged over all treatments and all slopes") +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

### REPEAT ABOVE FOR VALIDATION AND SAVE BOTH FIGURES

val.df = odds.all
val.stat = odds.raw
val.df = val.df[val.df$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),]
val.df = merge(val.df,dummy,all=T)
val.rmse = mm.rmse.func(val.stat)
val.rmse = merge(val.rmse,val.df,all=T)

p.yld.validation = ggplot(val.rmse, aes(x = type, y = mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=250, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=val.rmse[!rowSums(is.na(val.rmse)),], aes(y=272,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=val.rmse[!rowSums(is.na(val.rmse)),], aes(y=292,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=val.rmse[!rowSums(is.na(val.rmse)),], aes(y=312,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*crop, ncol=4, nrow=3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,319)) +
  ylab(expression(paste("Yields (gC ", m^-2,")"))) +
  ggtitle("Averaged over all treatments and all slopes") +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

ggsave(p.yld.calibration, file=file.path(figdir, "calibration.pdf"), width=325, height=325, units="mm")
ggsave(p.yld.validation, file=file.path(figdir, "validation.pdf"), width=325, height=325, units="mm")

# Remove unwanted objects

rm(evens.all, evens.raw, odds.all, odds.raw)
