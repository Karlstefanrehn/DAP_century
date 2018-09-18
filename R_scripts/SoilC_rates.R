# -----------------------------------------------------------------------------#
### ESTIMATING SOIL CARBON SEQUESTRATION RATES FOR EACH TREATMENT USING LME  ###
# -----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

#load(file.path(Robjsdir,"all_data")) - If running just this script

### GENERATING BASE RATES - Note: WF and WCMF aren't true representations of their treatments so are excluded

meas.soc = meas.raw.slc[meas.raw.slc$trt!="WF"&meas.raw.slc$trt!="WCMF",]
meas.soc = meas.soc[meas.soc$year!=1986&meas.soc$year!=2009,] # 1986 raw data does not make sense compared with published values so removed and published values (1985) used instead
# 2009 data is randomly generated from the mean and standard deviation given by Lucretia. Exclude for now as it's not true data
meas.soc$trt = factor(meas.soc$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland

meas.lme = lme(profilesoc ~ year*trt, random = ~1|site, data=meas.soc, na.action=na.omit, method="ML")
summary(meas.lme)

meas.lme.wcf = lme(profilesoc ~ year, random = ~1|site, data=meas.soc[meas.soc$trt=="WCF",], na.action=na.omit, method="ML")
meas.lme.opp = lme(profilesoc ~ year, random = ~1|site, data=meas.soc[meas.soc$trt=="OPP",], na.action=na.omit, method="ML")
meas.lme.grass = lme(profilesoc ~ year, random = ~1|site, data=meas.soc[meas.soc$trt=="Grass",], na.action=na.omit, method="ML")

mod.soc = all_data[all_data$year>1984&all_data$year<2016&all_data$trt!="WF"&all_data$trt!="WCMF",] # Limit modelled data to same timeframe and treatments so we can compare rates
mod.soc$trt = factor(mod.soc$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland

mod.lme = lme(somtc ~ year*trt, random = ~1|site, data=mod.soc, na.action=na.omit, method="ML")
summary(mod.lme)

mod.lme.wcf = lme(somtc ~ year, random = ~1|site, data=mod.soc[mod.soc$trt=="WCF",], na.action=na.omit, method="ML")
mod.lme.opp = lme(somtc ~ year, random = ~1|site, data=mod.soc[mod.soc$trt=="OPP",], na.action=na.omit, method="ML")
mod.lme.grass = lme(somtc ~ year, random = ~1|site, data=mod.soc[mod.soc$trt=="Grass",], na.action=na.omit, method="ML")

seqrates = data.frame(Treatment="Grass", Measured=summary(meas.lme)$tTable[,1][2], se=summary(meas.lme.grass)$tTable[,2][2],
                      pmeas.to0=summary(meas.lme.grass)$tTable[,5][2], p.meas=NA,
                      Modelled=summary(mod.lme)$tTable[,1][2], se=summary(mod.lme.grass)$tTable[,2][2],
                      pmod.to0=summary(mod.lme.grass)$tTable[,5][2], p.mod=NA)
seqrates = rbind(seqrates, data.frame(Treatment="OPP", Measured=summary(meas.lme)$tTable[,1][5]+summary(meas.lme)$tTable[,1][2], se=summary(meas.lme.opp)$tTable[,2][2],
                                      pmeas.to0=summary(meas.lme.opp)$tTable[,5][2], p.meas=summary(meas.lme)$tTable[,5][5],
                                      Modelled=summary(mod.lme)$tTable[,1][5]+summary(mod.lme)$tTable[,1][2], se=summary(mod.lme.opp)$tTable[,2][2],
                                      pmod.to0=summary(mod.lme.opp)$tTable[,5][2], p.mod=summary(mod.lme)$tTable[,5][5]))
seqrates = rbind(seqrates, data.frame(Treatment="WCF", Measured=summary(meas.lme)$tTable[,1][6]+summary(meas.lme)$tTable[,1][2], se=summary(meas.lme.wcf)$tTable[,2][2],
                                      pmeas.to0=summary(meas.lme.wcf)$tTable[,5][2], p.meas=summary(meas.lme)$tTable[,5][6],
                                      Modelled=summary(mod.lme)$tTable[,1][6]+summary(mod.lme)$tTable[,1][2], se=summary(mod.lme.wcf)$tTable[,2][2],
                                      pmod.to0=summary(mod.lme.wcf)$tTable[,5][2], p.mod=summary(mod.lme)$tTable[,5][6]))

write.csv(seqrates, file=file.path(figdir,"Sequestration_rates.csv"))

# Plot the above to see what they look like using all data years available - average over site and assume all slopes etc are represented (not true for 2015)

meas.soc2 = ddply(meas.raw.slc[meas.raw.slc$trt!="WF"&meas.raw.slc$trt!="WCMF",], c("year","site","trt","source"), summarise,
                 mean = mean(profilesoc),
                 se = sd(profilesoc)/sqrt(length(profilesoc)),
                 max = max(profilesoc),
                 min = min(profilesoc),
                 ymax = mean+se,
                 ymin = mean-se,
                 bd_upper = quantile(profilesoc, probs=0.975),
                 bd_lower = quantile(profilesoc, probs=0.025),
                 N = length(profilesoc))

mod.soc2 = ddply(all_data[all_data$year>1984&all_data$year<2016&all_data$trt!="WF"&all_data$trt!="WCMF",], c("year","site","trt","source"), summarise,
                mean = mean(somtc),
                se = sd(somtc)/sqrt(length(somtc)),
                max = max(somtc),
                min = min(somtc),
                ymax = mean+se,
                ymin = mean-se,
                bd_upper = quantile(somtc, probs=0.975),
                bd_lower = quantile(somtc, probs=0.025),
                N = length(somtc))

p.seqrates = ggplot(mod.soc2, aes(x=year, y=mean, colour=trt)) +
  geom_line() +
  facet_wrap(~site) +
  geom_point(data=meas.soc2) +
  geom_errorbar(data=meas.soc2, aes(ymax=ymax, ymin=ymin), width = 1) +
#  geom_line(aes(y=ymax), linetype="dashed") +
#  geom_line(aes(y=ymin), linetype="dashed")
  ylim(1000,4500) +
  ylab("Soil Carbon kgC/ha") +
  theme_bw() +
  scale_color_manual("Treatment", values=c("firebrick","blue","darkgreen"),labels=c("Grass","OPP","WCF"))

### SAVE AVERAGE SOIL C DATA

temp = all.soilC[all.soilC$year>1984&all.soilC$year<2017&all.soilC$source!="Modelled",]
temp$RCP[temp$source=="Measured"] = "RCP45"
temp1 = temp[temp$year<2010&temp$RCP!="RCP85",]
temp = rbind(temp1, temp[temp$year>2009,])
write.csv(temp, file=file.path(figdir, "soilC_averages.csv"))

rm(temp, temp1)

### DO THE SAME BUT FOR FUTURE SIMULATED DATA ONLY (2015-2045 and 2045-2075)

mod.soc.45 = all_data[all_data$year>2014&all_data$year<2046&all_data$RCP=="RCP45",] # Limit modelled data to the next 30-year timeframe
mod.soc.45$trt = factor(mod.soc.45$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland
mod.soc.85 = all_data[all_data$year>2014&all_data$year<2046&all_data$RCP=="RCP85",] # Limit modelled data to the next 30-year timeframe
mod.soc.85$trt = factor(mod.soc.85$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland

mod.lme.45 = lme(somtc ~ year*trt, random = ~1|site, data=mod.soc.45, na.action=na.omit, method="ML")
summary(mod.lme.45)
mod.lme.85 = lme(somtc ~ year*trt, random = ~1|site, data=mod.soc.85, na.action=na.omit, method="ML")
summary(mod.lme.85)

mod.lme.45.wf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WF",], na.action=na.omit, method="ML")
mod.lme.45.wcf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WCF",], na.action=na.omit, method="ML")
mod.lme.45.wcmf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WCMF",], na.action=na.omit, method="ML")
mod.lme.45.opp = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="OPP",], na.action=na.omit, method="ML")
mod.lme.45.grass = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="Grass",], na.action=na.omit, method="ML")

mod.lme.85.wf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WF",], na.action=na.omit, method="ML")
mod.lme.85.wcf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WCF",], na.action=na.omit, method="ML")
mod.lme.85.wcmf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WCMF",], na.action=na.omit, method="ML")
mod.lme.85.opp = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="OPP",], na.action=na.omit, method="ML")
mod.lme.85.grass = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="Grass",], na.action=na.omit, method="ML")

fut.seqrates = data.frame(Treatment="Grass", RCP="RCP 4.5", Time="2015-2045", Rate=summary(mod.lme.45)$tTable[,1][2],
                          se=summary(mod.lme.45.grass)$tTable[,2][2], pmod.to0=summary(mod.lme.45.grass)$tTable[,5][2],
                          p.mod=NA)

fut.seqrates = rbind(fut.seqrates, data.frame(Treatment="Grass", RCP="RCP 8.5", Time="2015-2045", Rate=summary(mod.lme.85)$tTable[,1][2],
                                              se=summary(mod.lme.85.grass)$tTable[,2][2], pmod.to0=summary(mod.lme.85.grass)$tTable[,5][2],
                                              p.mod=NA))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="OPP", RCP="RCP 4.5", Time="2015-2045", Rate=summary(mod.lme.45)$tTable[,1][7]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.opp)$tTable[,2][2], pmod.to0=summary(mod.lme.45.opp)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][7]),
                     data.frame(Treatment="OPP", RCP="RCP 8.5", Time="2015-2045", Rate=summary(mod.lme.85)$tTable[,1][7]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.opp)$tTable[,2][2], pmod.to0=summary(mod.lme.85.opp)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][7]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WCMF", RCP="RCP 4.5", Time="2015-2045", Rate=summary(mod.lme.45)$tTable[,1][8]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wcmf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wcmf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][8]),
                     data.frame(Treatment="WCMF", RCP="RCP 8.5", Time="2015-2045", Rate=summary(mod.lme.85)$tTable[,1][8]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wcmf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wcmf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][8]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WCF", RCP="RCP 4.5", Time="2015-2045", Rate=summary(mod.lme.45)$tTable[,1][9]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wcf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wcf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][9]),
                     data.frame(Treatment="WCF", RCP="RCP 8.5", Time="2015-2045", Rate=summary(mod.lme.85)$tTable[,1][9]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wcf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wcf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][9]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WF", RCP="RCP 4.5", Time="2015-2045", Rate=summary(mod.lme.45)$tTable[,1][10]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][10]),
                     data.frame(Treatment="WF", RCP="RCP 8.5", Time="2015-2045", Rate=summary(mod.lme.85)$tTable[,1][10]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][10]))

### AND FOR 2045-2075

mod.soc.45 = all_data[all_data$year>2044&all_data$year<2076&all_data$RCP=="RCP45",] # Limit modelled data to the next 30-year timeframe
mod.soc.45$trt = factor(mod.soc.45$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland
mod.soc.85 = all_data[all_data$year>2044&all_data$year<2076&all_data$RCP=="RCP85",] # Limit modelled data to the next 30-year timeframe
mod.soc.85$trt = factor(mod.soc.85$trt, levels = c("Grass","OPP","WCMF","WCF","WF")) # Relevel to compare treatments to grassland

mod.lme.45 = lme(somtc ~ year*trt, random = ~1|site, data=mod.soc.45, na.action=na.omit, method="ML")
summary(mod.lme.45)
mod.lme.85 = lme(somtc ~ year*trt, random = ~1|site, data=mod.soc.85, na.action=na.omit, method="ML")
summary(mod.lme.85)

mod.lme.45.wf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WF",], na.action=na.omit, method="ML")
mod.lme.45.wcf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WCF",], na.action=na.omit, method="ML")
mod.lme.45.wcmf = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="WCMF",], na.action=na.omit, method="ML")
mod.lme.45.opp = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="OPP",], na.action=na.omit, method="ML")
mod.lme.45.grass = lme(somtc ~ year, random = ~1|site, data=mod.soc.45[mod.soc.45$trt=="Grass",], na.action=na.omit, method="ML")

mod.lme.85.wf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WF",], na.action=na.omit, method="ML")
mod.lme.85.wcf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WCF",], na.action=na.omit, method="ML")
mod.lme.85.wcmf = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="WCMF",], na.action=na.omit, method="ML")
mod.lme.85.opp = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="OPP",], na.action=na.omit, method="ML")
mod.lme.85.grass = lme(somtc ~ year, random = ~1|site, data=mod.soc.85[mod.soc.85$trt=="Grass",], na.action=na.omit, method="ML")

fut.seqrates = rbind(fut.seqrates, data.frame(Treatment="Grass", RCP="RCP 4.5", Time="2045-2075", Rate=summary(mod.lme.45)$tTable[,1][2],
                                              se=summary(mod.lme.45.grass)$tTable[,2][2], pmod.to0=summary(mod.lme.45.grass)$tTable[,5][2],
                                              p.mod=NA))

fut.seqrates = rbind(fut.seqrates, data.frame(Treatment="Grass", RCP="RCP 8.5", Time="2045-2075", Rate=summary(mod.lme.85)$tTable[,1][2],
                                              se=summary(mod.lme.85.grass)$tTable[,2][2], pmod.to0=summary(mod.lme.85.grass)$tTable[,5][2],
                                              p.mod=NA))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="OPP", RCP="RCP 4.5", Time="2045-2075", Rate=summary(mod.lme.45)$tTable[,1][7]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.opp)$tTable[,2][2], pmod.to0=summary(mod.lme.45.opp)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][7]),
                     data.frame(Treatment="OPP", RCP="RCP 8.5", Time="2045-2075", Rate=summary(mod.lme.85)$tTable[,1][7]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.opp)$tTable[,2][2], pmod.to0=summary(mod.lme.85.opp)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][7]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WCMF", RCP="RCP 4.5", Time="2045-2075", Rate=summary(mod.lme.45)$tTable[,1][8]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wcmf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wcmf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][8]),
                     data.frame(Treatment="WCMF", RCP="RCP 8.5", Time="2045-2075", Rate=summary(mod.lme.85)$tTable[,1][8]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wcmf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wcmf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][8]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WCF", RCP="RCP 4.5", Time="2045-2075", Rate=summary(mod.lme.45)$tTable[,1][9]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wcf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wcf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][9]),
                     data.frame(Treatment="WCF", RCP="RCP 8.5", Time="2045-2075", Rate=summary(mod.lme.85)$tTable[,1][9]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wcf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wcf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][9]))

fut.seqrates = rbind(fut.seqrates,
                     data.frame(Treatment="WF", RCP="RCP 4.5", Time="2045-2075", Rate=summary(mod.lme.45)$tTable[,1][10]+summary(mod.lme.45)$tTable[,1][2],
                                se=summary(mod.lme.45.wf)$tTable[,2][2], pmod.to0=summary(mod.lme.45.wf)$tTable[,5][2],
                                p.mod=summary(mod.lme.45)$tTable[,5][10]),
                     data.frame(Treatment="WF", RCP="RCP 8.5", Time="2045-2075", Rate=summary(mod.lme.85)$tTable[,1][10]+summary(mod.lme.85)$tTable[,1][2],
                                se=summary(mod.lme.85.wf)$tTable[,2][2], pmod.to0=summary(mod.lme.85.wf)$tTable[,5][2],
                                p.mod=summary(mod.lme.85)$tTable[,5][10]))

# And Save
write.csv(fut.seqrates, file=file.path(figdir,"Future_seq_rates.csv"))
