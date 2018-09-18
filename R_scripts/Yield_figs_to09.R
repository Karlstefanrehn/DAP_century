# ------------------------------------------------------------------------------------#
### CREATES FIGURES THAT COMPARE 1986-2009 YIELD MEASUREMENTS WITH SIMULATED VALUES ###
# ------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

######################
### COMPARE STOVER AND GRAIN YIELDS SEPARATELY AVERAGED OVER SLOPES
######################

# Creating objects with raw data but consistant format/dataframe structures

mod.raw.form = rbind(ddply(mod.raw.ylds, c("year", "rot_phs", "site", "slope", "crop", "treatno", "treat", "trt", "source"), summarise,
                           N = length(cgrain),
                           mean = mean(cgrain),
                           se = sd(cgrain)/sqrt(length(cgrain)),
                           ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                           ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                           type = "Grain"),
                     ddply(mod.raw.ylds, c("year", "rot_phs", "site", "slope", "crop", "treatno", "treat", "trt", "source"), summarise,                     
                           N = length(stvr),
                           mean = mean(stvr),
                           se = sd(stvr)/sqrt(length(stvr)),
                           ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                           ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                           type = "Stover"))

# Measured yields are averaged over both strips (i.e. by treatment) because model outputs are by treatment
meas.raw.form = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("year", "rot_phs", "site", "slope", "crop", "treatno", "treat", "trt", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),         
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("year", "rot_phs", "site", "slope", "crop", "treatno", "treat", "trt", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

# Merge objects for graphing
mm.raw = merge(meas.raw.form, mod.raw.form, by=c("year","rot_phs","site","slope","crop","treatno","treat","trt","type"))
mm.treat = merge(meas.treat, mod.treat, by=c("year","site","rot_phs","crop","treat","type"))
mm.treat.all = merge(meas.treat.all, mod.treat.all, by=c("site","crop","treat","type"))
mm.treat.phs = merge(meas.treat.phs, mod.treat.phs, by=c("rot_phs","site","crop","treat","type"))
mm.trt = merge(meas.trt, mod.trt, by=c("year","site","rot_phs","crop","trt","type"))
mm.trt.all = merge(meas.trt.all, mod.trt.all, by=c("site","crop","trt","type"))
mm.trt.phs = merge(meas.trt.phs, mod.trt.phs, by=c("rot_phs","site","crop","trt","type"))
mm.crp.all = merge(meas.crp.all, mod.crp.all, by=c("site","type"))
mm.crp.treat.all = merge(meas.crp.treat.all, mod.crp.treat.all, by=c("site","treat","type"))
mm.crp.treat.phs = merge(meas.crp.treat.phs, mod.crp.treat.phs, by=c("rot_phs","site","treat","type"))
mm.crp.trt.all = merge(meas.crp.trt.all, mod.crp.trt.all, by=c("site","trt","type"))
mm.crp.trt.phs = merge(meas.crp.trt.phs, mod.crp.trt.phs, by=c("rot_phs","site","trt","type"))
mm.all = merge(meas.all, mod.all, by=c("site","crop","type"))
mm.slp.phs = merge(meas.slp.phs, mod.slp.phs, by=c("rot_phs","site","crop","slope","type"))
mm.slp.treat.all = merge(meas.slp.treat.all, mod.slp.treat.all, by=c("site","crop","treat","slope","type"))
mm.slp.trt.all = merge(meas.slp.trt.all, mod.slp.trt.all, by=c("site","crop","trt","slope","type"))
mm.ylds = merge(meas.ylds, mod.ylds, by=c("year","rot_phs","site","crop","type"))
mm.phs = merge(meas.phs, mod.phs, by=c("rot_phs","site","crop","type"))

# RAW COMPARISON OBJECT (USED FOR STATS)
mm.raw = mm.raw[mm.raw$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),] # Choose the crops you want to compare

# AVERAGE OBJECT OVER ALL SLOPES/TREATS/YEARS (USED FOR GRAPHS)
mm.all = mm.all[mm.all$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),] # Choose the crops you want to compare

# DATAFRAME STRUCTURE - FACTOR LEVELS (used to create all permeatations balancing graph objects)
years = c(1985:2010)
phases = c("1986-1997","1998-2009")
sites = c("Sterling","Stratton","Walsh")
slopes = c("Summit","Sideslope","Toeslope")
crops = c("Corn","Wheat","Sorghum","Millet")
treats = c("WF","FW","WCM","CMW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","WCMW","CMWW","MWWC","WWCM","OPP")
trts = c("WF","WCM","WCF","WCMF","WWCM","OPP")
treatnos = c(1:10)
types = c("Grain","Stover")
sources = c("Modelled","Measured")

expanded = expand.grid(site=sites,crop=crops,type=types) # All combinations of sites/crops/yield types
temp = rbind(mod.all,meas.all) # Bind average objects (same as mm.all but rbind, not cbind)
temp = temp[temp$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),] # Limit the dataset to key crops
temp = merge(temp,expanded,all=T) # Merge to create all permeatations

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

dummy = mm.rmse.func(mm.raw)
temp = merge(dummy,temp,all=T)

### GRAPH THE RESULTING COMPARISON DISPLAYING:
# Measured and modelled grain and stover yields compared at the site-crop level
# Sample size used to create RMSE and R2 values are shown (n=) as well as RMSE and R2

p.yld.mm.all = ggplot(temp, aes(x = type, y = mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=210, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=235,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=255,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=275,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*crop, ncol=4, nrow=3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,285)) +
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

### GRAPHING THE USUAL 1:1 GRAPHS WE EXPECT TO SEE (COLOURED BY SITE)

my.formula = y ~ x - 1 # Formula used to define desired relationship - for measured-modelled comparison this is 1:1 with no intercept

mm.ylds = mm.ylds[mm.ylds$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),] # Choose the crops you want to compare

### STOVER
p.stv.mm = ggplot(mm.ylds[mm.ylds$type=="Stover",], aes(x = mean.x, y = mean.y, colour = site)) +
  geom_point() +
  geom_smooth(method="lm",formula=my.formula,se=F) +
  geom_abline(intercept=0, slope=1, linetype='dotted') +
  facet_wrap(~crop, nrow = 2) +
  geom_errorbar(aes(ymax=ymax.y, ymin=ymin.y), alpha = 1) +
  geom_errorbarh(aes(xmax=ymax.x, xmin=ymin.x), alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,599)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,599)) +
  ggtitle("Stover yields averaged over all treatments and all slopes") +
  ylab(expression(paste("Modelled Stover Yield (gC ", m^-2,")"))) +
  xlab(expression(paste("Measured Stover Yield (gC ", m^-2,")"))) +
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
  scale_fill_manual("Site",
                    values = c("coral2","cornflowerblue", "darkgreen"),
                    labels = c("Sterling", "Stratton", "Walsh")) +
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

### GRAIN
p.grn.mm = ggplot(mm.ylds[mm.ylds$type=="Grain",], aes(x = mean.x, y = mean.y, colour = site)) +
  geom_point() +
  geom_smooth(method="lm",formula=my.formula,se=F) +
  geom_abline(intercept=0, slope=1, linetype='dotted') +
  facet_wrap(~crop, nrow = 2) +
  geom_errorbar(aes(ymax=ymax.y, ymin=ymin.y), alpha = 1) +
  geom_errorbarh(aes(xmax=ymax.x, xmin=ymin.x), alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,299)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,299)) +
  ggtitle("Grain yields averaged over all treatments and all slopes") +
  ylab(expression(paste("Modelled Grain Yield (gC ", m^-2,")"))) +
  xlab(expression(paste("Measured Grain Yield (gC ", m^-2,")"))) +
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
  scale_fill_manual("Site",
                    values = c("coral2","cornflowerblue", "darkgreen"),
                    labels = c("Sterling", "Stratton", "Walsh")) +
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

### USING ALL YEARS TO PLOT TIME-COURSE

temp = rbind(mod.ylds, meas.ylds) # Rbind object used for next graph
dummy = expand.grid(year=years,site=sites,crop=crops,type=types,source=sources) # All combinations to make graph look better
temp = merge(temp,dummy,all=T)
temp = temp[temp$crop %in% c("Corn", "Wheat", "Sorghum", "Millet"),] # Choose the crops you want to compare

### STOVER TIME-COURSE
p.stover.yld = ggplot(temp[temp$type=="Stover",], aes(x = year, y = mean, fill = source)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1) +
  facet_wrap(~site*crop, nrow = 3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin), position = dodge, width = 0.25, alpha = 1) +
  #  geom_text(fontface = "italic", aes(label = paste("n=", round(N, 0))), position = dodge, vjust=-3, size=4) +
  scale_y_continuous(expand=c(0,0), limits=c(0,499)) +
  scale_x_continuous(expand=c(0,0), limits=c(1984, 2010)) +
  ylab(expression(paste("Stover Yield (gC ", m^-2,")"))) +
  ggtitle("Averaged over all treatments and all slopes") +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

### GRAIN TIME-COURSE
p.grain.yld = ggplot(temp[temp$type=="Grain",], aes(x = year, y = mean, fill = source)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1) +
  facet_wrap(~site*crop, nrow = 3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin), position = dodge, width = 0.25, alpha = 1) +
  #  geom_text(fontface = "italic", aes(label = paste("n=", round(N, 0))), position = dodge, vjust=-3, size=4) +
  scale_y_continuous(expand=c(0,0), limits=c(0,499)) +
  scale_x_continuous(expand=c(0,0), limits=c(1984, 2010)) +
  ylab(expression(paste("Grain Yield (gC ", m^-2,")"))) +
  ggtitle("Averaged over all treatments and all slopes") +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_text(size=14),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

ggsave(p.yld.mm.all, file=file.path(figdir,"mm_all_avgs.pdf"), width=300, height=300, units="mm")
ggsave(p.grn.mm, file=file.path(figdir,"mm_grn_bycrop.pdf"), width=350, height=350, units="mm")
ggsave(p.stv.mm, file=file.path(figdir,"mm_stv_bycrop.pdf"), width=350, height=350, units="mm")
ggsave(p.stover.yld, file=file.path(figdir,"mm_stv_overyrs.pdf"), width=550, height=250, units="mm")
ggsave(p.grain.yld, file=file.path(figdir,"mm_grn_overyrs.pdf"), width=550, height=250, units="mm")

########################
### INSTEAD OF USING EACH CROP WE CAN AVERAGE OVER ROTATION (trt)
########################

# Doesn't matter what crop is growing
# Create rbind object - average yields over all years, slopes, crops and entry-points:

mm.rotations = rbind(ddply(mm.raw, c("site", "trt", "type"), summarise,
                        N=length(mean.x),
                        mean=mean(mean.x),
                        se=sd(mean.x)/sqrt(length(mean.x)),
                        ymin=mean(mean.x)-(sd(mean.x)/sqrt(length(mean.x))),
                        ymax=mean(mean.x)+(sd(mean.x)/sqrt(length(mean.x))),
                        source="Measured"),
                     ddply(mm.raw, c("site", "trt", "type"), summarise,
                        N=length(mean.y),                                             
                        mean=mean(mean.y),
                        se=sd(mean.y)/sqrt(length(mean.y)),
                        ymin=mean(mean.y)-(sd(mean.y)/sqrt(length(mean.y))),
                        ymax=mean(mean.y)+(sd(mean.y)/sqrt(length(mean.y))),
                        source="Modelled"))

# Create new RMSE function and comparing model predictions to raw data

trt.rmse.func = function(df){
  output = data.frame(site="Sterling",trt="WF",type="Grain",source="Measured",rmse=NA,rsq=NA,mae=NA)
  for(sit in sites){
    for (tret in trts){
      for (typ in types){
        if(nrow(df[df$site==sit&df$type==typ&df$trt==tret,])<1) next
        newdf = df[df$site==sit&df$type==typ&df$trt==tret,]
        rms = sqrt(mean((newdf$mean.y-newdf$mean.x)^2, na.rm=T))
        me = mean(abs((newdf$mean.y-newdf$mean.x)), na.rm=T)
        print(rms)
        lmod = lm(mean.y~mean.x+0, newdf)
        rs = summary(lmod)$r.squared
        output = rbind(output, data.frame(site=sit,trt=tret,type=typ,source="Measured",rmse=rms,rsq=rs,mae=me))
      }
    }
  }
  return(output)
}

rotation.rmse = trt.rmse.func(mm.raw)

expanded = expand.grid(site=sites,trt=trts,type=types) # All combinations of sites/rotations/yield types
temp = merge(mm.rotations,expanded,all=T) # Merge to create all permeatations

temp = merge(rotation.rmse,temp,all=T)

# GRAPH AS WITH CROPS BUT FOR TREATMENTS

p.rotation.ylds = ggplot(temp, aes(x = type, y = mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=235, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=250,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=265,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=temp[!rowSums(is.na(temp)),], aes(y=280,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*trt, nrow=3) +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,290)) +
  ylab(expression(paste("Yields (gC ", m^-2,")"))) +
#  ggtitle("Averaged over all years and all slopes") +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

########################
### FINALLY CREATE THE SAME BUT ALSO INCLUDE PHASE 
### (NOTE - WF and WCMF are only phase 1 and WCM and WWCM are phase 2
########################

# Doesn't matter what crop is growing
# Create rbind object - average yields over all years, slopes, crops and entry-points:

mm.phs.rotations = rbind(ddply(mm.raw, c("site", "trt", "rot_phs", "type"), summarise,
                           N=length(mean.x),
                           mean=mean(mean.x),
                           se=sd(mean.x)/sqrt(length(mean.x)),
                           ymin=mean(mean.x)-(sd(mean.x)/sqrt(length(mean.x))),
                           ymax=mean(mean.x)+(sd(mean.x)/sqrt(length(mean.x))),
                           source="Measured"),
                     ddply(mm.raw, c("site", "trt", "rot_phs", "type"), summarise,
                           N=length(mean.y),                                             
                           mean=mean(mean.y),
                           se=sd(mean.y)/sqrt(length(mean.y)),
                           ymin=mean(mean.y)-(sd(mean.y)/sqrt(length(mean.y))),
                           ymax=mean(mean.y)+(sd(mean.y)/sqrt(length(mean.y))),
                           source="Modelled"))

# Create new RMSE function and comparing model predictions to raw data

trtphs.rmse.func = function(df){
  output = data.frame(site="Sterling",rot_phs="1986-1997",trt="WF",type="Grain",source="Measured",rmse=NA,rsq=NA,mae=NA)
  for(sit in sites){
    for(phs in phases){
      for (tret in trts){
        for (typ in types){
          if(nrow(df[df$site==sit&df$rot_phs==phs&df$trt==tret&df$type==typ,])<1) next
          newdf = df[df$site==sit&df$rot_phs==phs&df$trt==tret&df$type==typ,]
          rms = sqrt(mean((newdf$mean.y-newdf$mean.x)^2, na.rm=T))
          me = mean(abs((newdf$mean.y-newdf$mean.x)), na.rm=T)
          print(rms)
          lmod = lm(mean.y~mean.x+0, newdf)
          rs = summary(lmod)$r.squared
          output = rbind(output, data.frame(site=sit,rot_phs=phs,trt=tret,type=typ,source="Measured",rmse=rms,rsq=rs,mae=me))
        }
      }
    }
  }
  return(output)
}

phs.rotation.rmse = trtphs.rmse.func(mm.raw)

expanded = expand.grid(site=sites,rot_phs=phases,trt=trts,type=types) # All combinations of sites/rotations/yield types
temp = merge(mm.phs.rotations,expanded,all=T) # Merge to create all permeatations

temp = merge(phs.rotation.rmse,temp,all=T)

# GRAPH AS WITH CROPS BUT FOR TREATMENTS

gm2.to.kgha = 10 # CONVERTER TO CHANGED gC.m2 into kgC.ha

temp1 = temp[temp$rot_phs=="1986-1997",]

p.phs.rotation.ylds1 = ggplot(temp1, aes(x = type, y = mean*gm2.to.kgha)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=2350, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=temp1[!rowSums(is.na(temp1)),], aes(y=2500,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=temp1[!rowSums(is.na(temp1)),], aes(y=2650,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=temp1[!rowSums(is.na(temp1)),], aes(y=2800,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*trt, nrow=3) +
  geom_errorbar(aes(ymax=ymax*gm2.to.kgha, ymin=ymin*gm2.to.kgha, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,2900)) +
  ylab(expression(paste("Yields (kg C ", ha^-1,")"))) +
  ggtitle("1986 to 1997") +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        legend.position = "none",
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_fill_manual(breaks=c("Measured","Modelled"),
                    values=c("coral2","cornflowerblue", "#555555"))

temp2 = temp[temp$rot_phs=="1998-2009",]

p.phs.rotation.ylds2 = ggplot(temp2, aes(x = type, y = mean*gm2.to.kgha)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=2350, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(data=temp2[!rowSums(is.na(temp2)),], aes(y=2500,label = paste("R2=", round(rsq, 2))), position=dodge, size=3) +
  geom_text(data=temp2[!rowSums(is.na(temp2)),], aes(y=2650,label = paste("RMSE=", round(rmse, 0))), position=dodge, size=3) +
  geom_text(data=temp2[!rowSums(is.na(temp2)),], aes(y=2800,label = paste("MAE=", round(mae, 0))), position=dodge, size=3) +
  facet_wrap(~site*trt, nrow=3) +
  geom_errorbar(aes(ymax=ymax*gm2.to.kgha, ymin=ymin*gm2.to.kgha, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,2900)) +
  ylab(expression(paste("Yields (kg C ", ha^-1,")"))) +
  ggtitle("1998 to 2009") +
  theme(legend.title = element_blank(),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_fill_manual(breaks=c("Measured","Modelled"),
                    values=c("coral2","cornflowerblue", "#555555"))


multiplot(p.phs.rotation.ylds1, p.phs.rotation.ylds2, cols=2)

### AND SAVE!

ggsave(p.rotation.ylds, file=file.path(figdir,"rotations.pdf"), width=350, height=300, units="mm")
ggsave(p.phs.rotation.ylds1, file=file.path(figdir,"phase1_rotations.pdf"), width=300, height=300, units="mm")
ggsave(p.phs.rotation.ylds2, file=file.path(figdir,"phase2_rotations.pdf"), width=350, height=300, units="mm")

# Remove unwanted objects

rm(expanded)