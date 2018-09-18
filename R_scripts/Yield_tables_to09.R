# -----------------------------------------------------------------------------#
### PRODUCES TABLES THAT COMPARE SIMULATED YIELD RESULTS AND MEASURED VALUES ###
# -----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

#####################################################
### COMPARING MEASURED AND MODELLED GRAIN ADN STOVER YIELDS ACROSS THE WHOLE MEASUREMENT PERIOD (1985-2009)
### --- NORMALISING FOR THE CROP ITSELF IN THE DIFFERENT TREATMENTS TO ALLOW DIRECT COMPARISONS USING THE CODE BELOW
#####################################################

temp = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "crop"), summarise,
                   avg = mean(gr_yld),
                   type="Grain"),
             ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "crop"), summarise,
                   avg = mean(st_yld),
                   type="Stover"))
temp = temp[temp$crop %in% c("Corn","Wheat","Millet","Sorghum"),] # Limit to only those crops of interest (i.e. don't normalise for Soybean - those yields are removed instead)

temp2 = data.frame()
for(sit in levels(as.factor(temp$site))) {
  for(typ in levels(as.factor(temp$type))) {
    for(phs in levels(as.factor(temp$rot_phs))) {
    df = temp[temp$site==sit&temp$type==typ&temp$rot_phs==phs,]
    df$norm = mean(df$avg)/df$avg
    temp2 = rbind(temp2, df)
    }
  }
}

temp = merge(temp2, meas.raw.ylds)
tempx = temp[temp$type=="Stover",]
tempx$new = tempx$st_yld*tempx$norm
tempy = temp[temp$type=="Grain",]
tempy$new = tempy$gr_yld*tempy$norm
meas.raw.ylds2 = rbind(tempx, tempy)

temp = merge(temp2, mod.raw.ylds)
tempx = temp[temp$type=="Stover",]
tempx$new = tempx$stvr*tempx$norm
tempy = temp[temp$type=="Grain",]
tempy$new = tempy$cgrain*tempy$norm
mod.raw.ylds2 = rbind(tempx, tempy)
mod.raw.ylds2$strip = 1

raw.ylds = rbind(ddply(meas.raw.ylds2[complete.cases(meas.raw.ylds2$new),], c("rot_phs", "site", "slope", "strip", "treatno", "treat", "trt", "type", "source"), summarise,
                       N = length(new),
                       cum = sum(new),
                       ann = cum/N),
                 ddply(mod.raw.ylds2[complete.cases(mod.raw.ylds2$new),], c("rot_phs", "site", "slope", "strip", "treatno", "treat", "trt", "type", "source"), summarise,
                       N = length(new),
                       cum = sum(new),
                       ann = cum/N))

raw.ylds = raw.ylds[,!(names(raw.ylds) %in% "strip")]
raw.ylds$rot_phs = revalue(raw.ylds$rot_phs, c("1986-1997"="1986 - 1997","1998-2009"="1998 - 2009"))

raw.ylds$cum[raw.ylds$trt=="WF"] = raw.ylds$ann[raw.ylds$trt=="WF"]*6 # 6 harvests over the 12-year phase for WF rotations
raw.ylds$cum[raw.ylds$trt=="WCF"] = raw.ylds$ann[raw.ylds$trt=="WCF"]*8 # 8 harvests over the 12-year phase for WCF rotations
raw.ylds$cum[raw.ylds$trt=="WCMF"] = raw.ylds$ann[raw.ylds$trt=="WCMF"]*9 # 9 harvests over the 12-year phase for WCMF rotations
raw.ylds$cum[raw.ylds$trt=="OPP"] = raw.ylds$ann[raw.ylds$trt=="OPP"]*12 # 12 harvests (in theory) over the 12-year phase for OPP rotations
# Note - Opportunity cropped rotations may include non-grain-yield crops (e.g. Hay Millet) which weights the average slightly
raw.ylds$cum[raw.ylds$trt=="WCM"] = raw.ylds$ann[raw.ylds$trt=="WCM"]*12 # 12 harvests over the 12-year phase for WCM rotations
raw.ylds$cum[raw.ylds$trt=="WWCM"] = raw.ylds$ann[raw.ylds$trt=="WWCM"]*12 # 12 harvests over the 12-year phase for WWCM rotations

raw.ylds$anlz = raw.ylds$cum/12 

ylds.normalized = ddply(raw.ylds, c("trt", "type", "source"), summarise,
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

write.csv(ylds.normalized, file=file.path(figdir, "Normalized_crop_ylds.csv"))

# Note - compare cumulative values with caution 
new = ylds.normalized
All = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
All2 = paste(formatC(round(new$cum.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$cum.se,1),format="f",digits=1), sep="")
All3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")

table = data.frame(Rotation=new[,1],Variable=paste(new[,3],new[,2],sep=" "),
                   Averaged=All, Cumulative=All2, Annualized=All3)

write.csv(table, file=file.path(figdir, "Normalised yield summary.csv"))

ylds.normalized$trt = factor(ylds.normalized$trt, levels = c("WF","WCF","WCMF","WCM","WWCM","OPP")) # Relevel the treatments that are plotted from least intense to most intense

p.anlz.norm = ggplot(ylds.normalized, aes(x=type, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=177, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,185)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2, yr^-1,")"))) +
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

ggsave(p.anlz.norm, file=file.path(figdir, "Normalized_annualised yield averages by treatment.pdf"), width=300, height=200, units="mm")

######################
### COMPARE ANNUALISED STOVER AND GRAIN YIELDS SEPARATELY AVERAGED FOR EACH TREATMENT AT EACH SITE
### --- WITHOUT NORMALISING FOR CROP, SIMPLY IGNORING CROP TYPE ---
######################

# Creating average annual yields for each strip to have consistant format/dataframe structures - disregards crop type

mod.raw.ann = rbind(ddply(mod.raw.ylds, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "source"), summarise,
                          N = length(cgrain),
                          cum = sum(cgrain),
                          ann = cum/N,
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "source"), summarise,                     
                          N = length(stvr),
                          cum = sum(stvr),
                          ann = cum/N,
                          type = "Stover"))

meas.raw.ann = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "slope", "strip", "treatno", "treat", "trt", "source"), summarise,                     
                            N = length(st_yld),
                            cum = sum(st_yld),
                            ann = cum/N,
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "slope", "strip", "treatno", "treat", "trt", "source"), summarise,                     
                            N = length(gr_yld),
                            cum = sum(gr_yld),
                            ann = cum/N,
                            type="Grain"))

meas.raw.ann = meas.raw.ann[,!(names(meas.raw.ann) %in% "strip")] # Drop strip column from measured data as model only has 1 strip per treatment

# Unfortunately the import from the other script has rotations without a space around the years, this needs correcting to make graphs consistent
meas.raw.ann$rot_phs = revalue(meas.raw.ann$rot_phs, c("1986-1997"="1986 - 1997","1998-2009"="1998 - 2009"))
mod.raw.ann$rot_phs = revalue(mod.raw.ann$rot_phs, c("1986-1997"="1986 - 1997","1998-2009"="1998 - 2009"))

# Creating average annual C inputs from modelled data in a format consistent with those above
# Note - We need to remove years <1986 and create phase and 'overall' treatment columns first

mod.cinputs = mod.raw.annuals[mod.raw.annuals$year>1985,]
mod.cinputs$rot_phs = "1986 - 1997"
mod.cinputs$rot_phs[mod.cinputs$year>1997] = "1998 - 2009"

mod.cinputs$trt[mod.cinputs$treatno == 1 & mod.cinputs$rot_phs == "1986 - 1997"] = "WF"
mod.cinputs$trt[mod.cinputs$treatno == 2 & mod.cinputs$rot_phs == "1986 - 1997"] = "WF"
mod.cinputs$trt[mod.cinputs$treatno == 1 & mod.cinputs$rot_phs == "1998 - 2009"] = "WCM"
mod.cinputs$trt[mod.cinputs$treatno == 2 & mod.cinputs$rot_phs == "1998 - 2009"] = "WCM"
mod.cinputs$trt[mod.cinputs$treatno == 6 & mod.cinputs$rot_phs == "1998 - 2009"] = "WWCM"
mod.cinputs$trt[mod.cinputs$treatno == 7 & mod.cinputs$rot_phs == "1998 - 2009"] = "WWCM"
mod.cinputs$trt[mod.cinputs$treatno == 8 & mod.cinputs$rot_phs == "1998 - 2009"] = "WWCM"
mod.cinputs$trt[mod.cinputs$treatno == 9 & mod.cinputs$rot_phs == "1998 - 2009"] = "WWCM"

mod.cinputs$trt = factor(mod.cinputs$trt, levels = c("WF","WCM","WCF","WCMF","WWCM","OPP","Grass")) # Ensure levels in the treatment factor variable are correct

raw.inputs = ddply(mod.cinputs, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "source"), summarise,
                   N = length(cinput),
                   cum = sum(cinput),
                   ann = cum/N,
                   anlz = cum/12,
                   type = "C Inputs")

# Just for comparison's sake, check the values when phase is removed (i.e. WCF and OPP use all 24 years to average/cumulate over)
raw.inputs.nophs = ddply(mod.cinputs, c("site", "slope", "treatno", "treat", "trt", "source"), summarise,
                   N = length(cinput),
                   cum = sum(cinput),
                   ann = cum/N,
                   type = "C Inputs")

### Cumulative values should be correct for modelled data but due to missing years of measured data the cumulatives need to be recalculated from annualised values 

ann.mm = rbind(meas.raw.ann, mod.raw.ann) # Apply same to modelled data as measured data (cumulatives calculated from annualised)
ann.mm$cum[ann.mm$trt=="WF"] = ann.mm$ann[ann.mm$trt=="WF"]*6 # 6 harvests over the 12-year phase for WF rotations
ann.mm$cum[ann.mm$trt=="WCF"] = ann.mm$ann[ann.mm$trt=="WCF"]*8 # 8 harvests over the 12-year phase for WCF rotations
ann.mm$cum[ann.mm$trt=="WCMF"] = ann.mm$ann[ann.mm$trt=="WCMF"]*9 # 9 harvests over the 12-year phase for WCMF rotations
ann.mm$cum[ann.mm$trt=="OPP"] = ann.mm$ann[ann.mm$trt=="OPP"]*12 # 12 harvests (in theory) over the 12-year phase for OPP rotations
# Note - Opportunity cropped rotations may include non-grain-yield crops (e.g. Hay Millet) which weights the average slightly
ann.mm$cum[ann.mm$trt=="WCM"] = ann.mm$ann[ann.mm$trt=="WCM"]*12 # 12 harvests over the 12-year phase for WCM rotations
ann.mm$cum[ann.mm$trt=="WWCM"] = ann.mm$ann[ann.mm$trt=="WWCM"]*12 # 12 harvests over the 12-year phase for WWCM rotations

# Annualizing yields over each phase (12-year period) - essentially same as dividing by rotation length

ann.mm$anlz = ann.mm$cum/12 

ann.raw = rbind(raw.inputs, ann.mm) # Combine all measured and modelled data (stover, grain and total cin)

average.annualised = ddply(ann.raw, c("rot_phs", "site", "trt", "type", "source"), summarise,
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

# Do the same as above but remove phase from averaging - therefore WF, WCM, WCMF and WWCM use 12 years of data, WCF and OPP use 24 years of data
# NOTE - Cumulative values are no longer comparable when phase is removed - the cumulatives are over different amounts of time. Compare annualized values with caveat that climate changed over second phase
average.annualised.nophs = ddply(ann.raw, c("site", "trt", "type", "source"), summarise,
                           N=length(ann),
                           ann.mean=mean(ann),
                           ann.se=sd(ann)/sqrt(length(ann)), 
                           ann.ymin=mean(ann)-(sd(ann)/sqrt(length(ann))),
                           ann.ymax=mean(ann)+(sd(ann)/sqrt(length(ann))),
                           anlz.mean=mean(anlz),
                           anlz.se=sd(anlz)/sqrt(length(anlz)), 
                           anlz.ymin=mean(anlz)-(sd(anlz)/sqrt(length(anlz))),
                           anlz.ymax=mean(anlz)+(sd(anlz)/sqrt(length(anlz))))

### TEST STATISTICAL DIFFERENCE BETWEEN MEASURED AND MODELLED AVERAGE ANNUAL YIELDS (can check cumulative/annualised as well if you want)

# All data
ann.lm = lm(ann ~ source, data = ann.mm)
summary(ann.lm)
anova(ann.lm)
confint(ann.lm)

# Split to examine stover data alone (carbon inputs estimated accurately?)
ann.mm2 = ann.mm[ann.mm$type=="Stover",]
ann.lm2 = lm(ann ~ source, data = ann.mm2)
summary(ann.lm2)
anova(ann.lm2)
confint(ann.lm2)

### PLOTTING ANNUALISED

p.anlz.avg = ggplot(average.annualised[average.annualised$type!="C Inputs",], aes(x=type, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=235, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~site*rot_phs*trt, nrow=3) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2, yr^-1,")"))) +
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

p.anlz.avg.nophs = ggplot(average.annualised.nophs, aes(x=type, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=235, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~site*trt, nrow=3) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2, yr^-1,")"))) +
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

### PLOTTING CUMULATIVE

p.cum.avg = ggplot(average.annualised[average.annualised$type!="C Inputs",], aes(x=type, y=cum.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=2850, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~site*rot_phs*trt, nrow=3) +
  geom_errorbar(aes(ymax=cum.ymax, ymin=cum.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,3000)) +
  ylab(expression(paste("Cumulative yield (gC ", m^-2,")"))) +
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

# Save raw data in full dataset

write.csv(average.annualised, file=file.path(figdir, "Annualised Cinputs and harvests by phase.csv"))
ggsave(p.anlz.avg.nophs, file=file.path(figdir, "Annualised averages.pdf"), width=450, height=300, units="mm")
ggsave(p.cum.avg, file=file.path(figdir, "Cumulative averages by phase.pdf"), width=450, height=300, units="mm")

### REFORMATTING THE ABOVE TABLE (average.annualised) FOR PUBLICATION

new = average.annualised[average.annualised$site=="Sterling"&average.annualised$rot_phs=="1986 - 1997",]
Ste = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Ste2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Ste3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised[average.annualised$site=="Stratton"&average.annualised$rot_phs=="1986 - 1997",]
Str = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Str2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Str3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised[average.annualised$site=="Walsh"&average.annualised$rot_phs=="1986 - 1997",]
Wal = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Wal2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Wal3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")

table = data.frame(Phase=new[,1],Rotation=new[,3],Variable=paste(new[,5],new[,4],sep=" "),
                   Sterling=Ste,Stratton=Str,Walsh=Wal,Ste_cum=Ste2,Str_cum=Str2,Wal_cum=Wal2,
                   Ste_anlz=Ste3,Str_anlz=Str3,Wal_anlz=Wal3)

new = average.annualised[average.annualised$site=="Sterling"&average.annualised$rot_phs=="1998 - 2009",]
Ste = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Ste2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Ste3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised[average.annualised$site=="Stratton"&average.annualised$rot_phs=="1998 - 2009",]
Str = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Str2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Str3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised[average.annualised$site=="Walsh"&average.annualised$rot_phs=="1998 - 2009",]
Wal = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Wal2 = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
Wal3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")

table = rbind(table, data.frame(Phase=new[,1],Rotation=new[,3],Variable=paste(new[,5],new[,4],sep=" "),
                                Sterling=Ste,Stratton=Str,Walsh=Wal,Ste_cum=Ste2,Str_cum=Str2,Wal_cum=Wal2,
                                Ste_anlz=Ste3,Str_anlz=Str3,Wal_anlz=Wal3))

write.csv(table, file=file.path(figdir, "Ann_C_table.csv"))

# Same as above but also note that cumulatives cannot be compared effectively as some treatments are over 12 years and others 24 years
new = average.annualised.nophs[average.annualised.nophs$site=="Sterling",]
Ste = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Ste3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised.nophs[average.annualised.nophs$site=="Stratton",]
Str = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Str3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
new = average.annualised.nophs[average.annualised.nophs$site=="Walsh",]
Wal = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
Wal3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")

table = data.frame(Rotation=new[,2],Variable=paste(new[,4],new[,3],sep=" "),
                   Sterling=Ste,Stratton=Str,Walsh=Wal,
                   Ste_anlz=Ste3,Str_anlz=Str3,Wal_anlz=Wal3)

write.csv(table, file=file.path(figdir, "Ann_C_table_nophs.csv"))

#####
## DISREGARDING SITE (i.e. KEEPING PHASE TO BE TRUE TO TREATMENTS) - AND THEN PHASE
## CUMULATE INPUTS AVERAGED OVER PHASE AND ARE NOT COMPARABLE WHEN PHASE IS DISREGARDED
#####

nosite.annualised = ddply(ann.raw, c("rot_phs", "trt", "type", "source"), summarise,
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

nosite.nophs.annualised = ddply(ann.raw, c("trt", "type", "source"), summarise,
                                N=length(ann),
                                ann.mean=mean(ann),
                                ann.se=sd(ann)/sqrt(length(ann)), 
                                ann.ymin=mean(ann)-(sd(ann)/sqrt(length(ann))),
                                ann.ymax=mean(ann)+(sd(ann)/sqrt(length(ann))),
                                anlz.mean=mean(anlz),
                                anlz.se=sd(anlz)/sqrt(length(anlz)), 
                                anlz.ymin=mean(anlz)-(sd(anlz)/sqrt(length(anlz))),
                                anlz.ymax=mean(anlz)+(sd(anlz)/sqrt(length(anlz))))

p.anlz.avg2 = ggplot(nosite.annualised, aes(x=type, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=177, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~rot_phs*trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,185)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2, yr^-1,")"))) +
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

nosite.nophs.annualised$trt = factor(nosite.nophs.annualised$trt, levels = c("WF","WCF","WCMF","WCM","WWCM","OPP")) # Relevel the treatments that are plotted from least intense to most intense

p.anlz.avg.nophs2 = ggplot(nosite.nophs.annualised[nosite.nophs.annualised$type!="C Inputs",], aes(x=type, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=source)) +
  geom_text(fontface = "italic", aes(y=177, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=source), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,185)) +
  ylab(expression(paste("Annualized yield (gC ", m^-2, yr^-1,")"))) +
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

# Note - cumulative values cannot be compared reliably
new = nosite.nophs.annualised
All = paste(formatC(round(new$ann.mean,1),format="f",digits=1), " \u00b1 ", formatC(round(new$ann.se,1),format="f",digits=1), sep="")
All3 = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")

table = data.frame(Rotation=new[,1],Variable=paste(new[,3],new[,2],sep=" "),
                   Averaged=All,Annualized=All3)

write.csv(table, file=file.path(figdir, "Annualised Cinputs and harvests_no site or phase.csv"))
ggsave(p.anlz.avg.nophs2, file=file.path(figdir, "Annualised averages_no site or phase.pdf"), width=300, height=200, units="mm")

# Remove unwanted objects

rm(new, table, Ste, Ste2, Ste3, Str, Str2, Str3, Wal, Wal2, Wal3, All, All3)
