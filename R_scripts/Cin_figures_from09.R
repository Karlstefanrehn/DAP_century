# -----------------------------------------------------------------------------#
### PRODUCES FIGURES TO REPRESENT SIMULATED TOTAL C INPUT TO SOILS 2009-2100 ###
# -----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

# First we can very simply use the moving-averages calculated and saved in all_data to summarise over the different treatments
temp = ddply(all_data, c("year","trt","RCP"), summarise,
             cin = mean(mavg_cinput),
             cinhi = quantile(mavg_cinput, probs=0.975),
             cinlo = quantile(mavg_cinput, probs=0.025),
             N = length(mavg_cinput))

temp2=temp
temp2$trt = revalue(temp2$trt, c("OPP"="CC"))
temp2$trt = factor(temp2$trt, levels = c("WF", "WCF", "WCMF", "CC", "Grass")) # Relevel the treatments that are plotted from least intense to most intense

p.cin.timeline = ggplot(temp2, aes(x=year, y=cin/100, colour=RCP, fill=RCP, linetype=RCP)) +
  geom_vline(aes(xintercept=1984.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=1996.5), linetype="dashed", alpha=0.5) +
  geom_vline(aes(xintercept=2009), linetype="dashed", alpha=0.5) +
  geom_ribbon(data=temp2[temp2$year<=2009&temp2$RCP=="RCP45",], aes(ymin=cinlo/100, ymax=cinhi/100), colour=NA, fill='black', alpha=0.2) +
  geom_ribbon(data=temp2[temp2$year>=2009,], aes(ymin=cinlo/100, ymax=cinhi/100), colour=NA, alpha=0.18) +
  geom_line(data=temp2[temp2$year<=2009&temp2$RCP=="RCP45",], colour='black') +
  geom_line(data=temp2[temp2$year>=2009,]) +
  scale_y_continuous(expand=c(0,0), limits=c(0,4.2)) +
  scale_x_continuous(expand=c(0,0), limits=c(1979,2100), breaks=c(1984,2004,2024,2044,2064,2084), labels=c(1985,2005,2025,2045,2065,2085)) +
  ylab(expression(paste("Annual C inputs (tC ", ha^-1,")"))) +
  xlab("Year") +
  theme(legend.title = element_text(size=14),
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
                    labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("RCP Scenario",
                      values = c("cornflowerblue","firebrick"),
                      labels = c("RCP 4.5", "RCP 8.5")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) 

# To annotate on WF and WCMF facets only we need to create dummy dataframes with all relevant factors
wf_text = data.frame(year=2002.5, RCP="RCP45", trt = factor("WF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))
wcmf_text = data.frame(year=2002.5, RCP="RCP45", trt = factor("WCMF", levels = c("WF", "WCF", "WCMF", "OPP", "Grass")))

p.cin.timeline = p.cin.timeline + facet_wrap(~trt, ncol=5) + theme(legend.position = "bottom") +
  guides(colour=guide_legend(title.position = "top", title.hjust = 0.5),
         fill=guide_legend(title.position = "top", title.hjust = 0.5),
         linetype=guide_legend(title.position = "top", title.hjust = 0.5)) +
  geom_text(data=wf_text, aes(y=3), label="W\nC\nM", colour="black") + geom_text(data=wcmf_text, aes(y=3), label="W\nW\nC\nM", colour="black")

ggsave(p.cin.timeline, file=file.path(figdir, "Cinputs_timeline.pdf"), width=450, height=125, units="mm")

### TO CREATE ONE COMPOSITE PLOT WITH CORNER LABELS:
  
test1 = arrangeGrob(p.slc.mm.1, top = textGrob("a)",
                                               x = unit(0, "npc"), y = unit(1, "npc"),
                                               just=c("left","top"), gp=gpar(col="black", fontsize=14)))

test2 = arrangeGrob(p.totc.85.1, top = textGrob("b)",
                                                x = unit(0, "npc"), y = unit(1, "npc"),
                                                just=c("left","top"), gp=gpar(col="black", fontsize=14)))

test3 = arrangeGrob(p.cin.timeline, top = textGrob("c)",
                                                   x = unit(0, "npc"), y = unit(1, "npc"),
                                                   just=c("left","top"), gp=gpar(col="black", fontsize=14)))

p.Figure1 = gridExtra::grid.arrange(test1, test2, test3, ncol = 1) 
ggsave(p.Figure1, file=file.path(figdir, "Figure1.pdf"), width=400, height=300, units="mm")

### TO DO MORE DETAILED GRAPHING AND CREATE SUMMARY TABLES RUN THE CODE BELOW
# Only interested in 'future' data and select columns

keep = c("time", "year", "site", "slope", "treat", "GCM", "RCP", "cinput", "mavg_cinput") # Include somtc if you want
temp = as.data.frame(future_data)
fut.cin = temp[keep]
rm(temp)

# As above, prepare for graphing and rotation annualization

fut.cin$treatno[fut.cin$treat == "WF"] = 1
fut.cin$treatno[fut.cin$treat == "FW"] = 2
fut.cin$treatno[fut.cin$treat == "WCF"] = 3
fut.cin$treatno[fut.cin$treat == "CFW"] = 4
fut.cin$treatno[fut.cin$treat == "FWC"] = 5
fut.cin$treatno[fut.cin$treat == "WCMF"] = 6
fut.cin$treatno[fut.cin$treat == "CMFW"] = 7
fut.cin$treatno[fut.cin$treat == "MFWC"] = 8
fut.cin$treatno[fut.cin$treat == "FWCM"] = 9
fut.cin$treatno[fut.cin$treat == "OPP"] = 10
fut.cin$treatno[fut.cin$treat == "Grass"] = 11

fut.cin$treat = factor(fut.cin$treat, levels = c("WF","FW","WCF","CFW","FWC","WCMF","CMFW","MFWC","FWCM","OPP","Grass"))
fut.cin$trt = fut.cin$treat
fut.cin$trt = revalue(fut.cin$trt, c("FW"="WF","CFW"="WCF","FWC"="WCF","CMFW"="WCMF","MFWC"="WCMF","FWCM"="WCMF"))
fut.cin$trt = factor(fut.cin$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass"))

fut.cin$slope = revalue(fut.cin$slope, c("side"="Sideslope","summit"="Summit","toe"="Toeslope"))
fut.cin$slope = factor(fut.cin$slope, levels = c("Summit","Sideslope","Toeslope"))

fut.cin$rot_phs[fut.cin$year>2009&fut.cin$year<2022] = "2010 - 2021"
fut.cin$rot_phs[fut.cin$year>2021&fut.cin$year<2034] = "2022 - 2033"
fut.cin$rot_phs[fut.cin$year>2033&fut.cin$year<2046] = "2034 - 2045"
fut.cin$rot_phs[fut.cin$year>2045&fut.cin$year<2058] = "2046 - 2057"
fut.cin$rot_phs[fut.cin$year>2057&fut.cin$year<2070] = "2058 - 2069"
fut.cin$rot_phs[fut.cin$year>2069&fut.cin$year<2082] = "2070 - 2081"
fut.cin$rot_phs[fut.cin$year>2081&fut.cin$year<2094] = "2082 - 2093"

fut.cin$source = "Modelled" # This is used for comparison with measured yields when graphing/sub-setting

# To see full "cinput" variability over time

#ggplot(fut.cin, aes(x=time, y=mavg_cinput, colour=GCM, linetype=slope, alpha=RCP)) +
#  geom_line() +
#  facet_wrap(~site*treat)

# APPLY SAME CUMULATING TECHNIQUE AS ABOVE (NOTE - No treatno column but GCM and RCP required!)

fut.cin.ann = fut.cin[complete.cases(fut.cin$rot_phs),] # Disregard the final 'phase' as it is not a complete 12-year period

### As above, need to remove incomplete GCM datasets- BUT THE NUMBERS ARE NOW HIGHER AS CINPUT IS FOR EVERY YEAR!
# WF = 3 slopes, 2 rotation entry points, 12 years (72). WCF = 108. WCMF = 144. OPP = 36. Grass = 36

newdf = data.frame()
cinlist = list()
dummy=1 # Used to calculate the % completion of the loop below
iter.n = length(site_list)*length(phaselist)*length(trtlist) # Maximum length of loop iterations to enable % complete display

test = as.data.table(fut.cin.ann) # Subsetting is usually quicker using data tables rather than dataframes

for(sit in site_list) {
  for(phas in phaselist) {
    for(tr in trtlist) {
      for(RC in RCP_list) {
        for(GC in GCM_list) {
          if(tr=="Grass") {
            if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
              newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
              df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              cinlist[[df_name]] <- newdf
            }
          }
          if(tr=="WF") {
            if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==72) {
              newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
              df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              cinlist[[df_name]] <- newdf
            }
          }
          if(tr=="WCF") {
            if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==108) {
              newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
              df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              cinlist[[df_name]] <- newdf
            }
          }
          if(tr=="WCMF") {
            if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==144) {
              newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
              df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              cinlist[[df_name]] <- newdf
            }
          }
          if(tr=="OPP") {
            if(nrow(test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)])==36) {
              newdf = test[which(rot_phs==phas&site==sit&RCP==RC&GCM==GC&trt==tr)]
              df_name = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              comment(newdf) = paste(sit,phas,tr,RC,GC,"edit",sep="_")
              cinlist[[df_name]] <- newdf
              
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

fut.cin.ann = rbindlist(cinlist) # Convert the list of dataframes to a single rbind'ed dataframe

fut.cin.ann = rbind(ddply(fut.cin.ann, c("rot_phs", "site", "slope", "treatno", "treat", "trt", "RCP", "GCM", "source"), summarise,
                          N = length(cinput),
                          cum = sum(cinput),
                          ann = cum/N,
                          type = "C Inputs"))

### Cumulative values should have been calculated from 12 values (years) so check: (if 0 then all is well)

nrow(fut.cin.ann[fut.cin.ann$N!=12,])

# Annualizing yields over each phase (12-year period) - will be identical to "ann" for cinput dataset as there are always 12 years

fut.cin.ann$anlz = fut.cin.ann$cum/12 

future.cinputs = ddply(fut.cin.ann, c("site", "rot_phs", "trt", "RCP", "type", "source"), summarise,
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

future.cinputs2 = ddply(fut.cin.ann, c("rot_phs", "trt", "RCP", "type", "source"), summarise,
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

p.anlz.cin = ggplot(future.cinputs, aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=245, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~site*trt*RCP, nrow=5) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,260)) +
  ylab(expression(paste("Annualized C inputs (gC ", m^-2,")"))) +
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

p.anlz.cin2 = ggplot(future.cinputs2, aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=235, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~RCP*trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Annualized C inputs (gC ", m^-2,")"))) +
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

ggsave(p.anlz.cin, file=file.path(figdir, "Future C inputs annualised_bysite.pdf"), width=450, height=300, units="mm")
ggsave(p.anlz.cin2, file=file.path(figdir, "Future C inputs annualised.pdf"), width=450, height=300, units="mm")

write.csv(future.cinputs2, file=file.path(figdir, "cinputs_by phase.csv"))

##############
### COMBINE TO PUT YIELDS AND C INPUTS ON THE SAME FIGURE
##############

future.all = rbind(fut.phs.annualised2, future.cinputs2)

p.anlz.fut.RCP = ggplot(future.all, aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=220, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~RCP*trt, nrow=2) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,230)) +
  ylab(expression(paste("Annualized yields/inputs (gC ", m^-2,")"))) +
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

nosite.annualised$RCP = "RCP45"
all.all = rbind(nosite.annualised, future.all)

p.anlz.all = ggplot(all.all[all.all$RCP=="RCP45"&all.all$source=="Modelled"&all.all$trt!="WCM"&all.all$trt!="WWCM",], aes(x=rot_phs, y=anlz.mean)) +
  geom_bar(stat = 'identity', position = dodge, alpha = 1, aes(fill=type)) +
  geom_text(fontface = "italic", aes(y=220, label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  facet_wrap(~RCP*trt, nrow=1) +
  geom_errorbar(aes(ymax=anlz.ymax, ymin=anlz.ymin, fill=type), position = dodge, width = 0.25, alpha = 1) +
  scale_y_continuous(expand=c(0,0), limits=c(0,230)) +
  ylab(expression(paste("Annualized yields/inputs (gC ", m^-2,")"))) +
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

ggsave(p.anlz.fut.RCP, file=file.path(figdir, "Annualized future estimates.pdf"), width=500, height=300, units="mm")
ggsave(p.anlz.all, file=file.path(figdir, "Annualised estimates by phase_RCP45.pdf"), width=500, height=200, units="mm")

save(all.all, file=file.path(Robjsdir, "all.all"))

# Remove unwanted dataframes

#rm()
