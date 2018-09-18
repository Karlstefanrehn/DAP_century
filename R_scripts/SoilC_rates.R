# -----------------------------------------------------------------------------#
### ESTIMATING SOIL CARBON SEQUESTRATION RATES FOR EACH TREATMENT USING LME  ###
# -----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

### COMPARING SIMULATED CARBON INPUTS TO SIMULATED SOIL C STOCK CHANGES

# Because each GCM needs to start from the 2009 cumulative we first need to obtain those values
sim8609 = all_data[all_data$year>1985&all_data$year<2010,] # Subset before 2009
sim8609 = within(sim8609, {
  cumCinput <- ave(cinput, site, slope, treat, trt, GCM, RCP, FUN = cumsum) # Cumulate cinput by site, slope, treatment
})
sim09cin = ddply(sim8609[sim8609$year==2009,], c("site","slope","treat","trt","RCP"), summarise,
                 cin09 = mean(cumCinput)) # Get the single cumulative value for each site*slope*treatment combination

# Do the same for all GCMs individually for >2009 data
sim1099 = all_data[all_data$year>2009,] # Subset
sim1099 = within(sim1099, {
  cumCinput <- ave(cinput, site, slope, treat, trt, GCM, RCP, FUN = cumsum) # Cumulate cinputs
})

temp = merge(sim1099, sim09cin, by=c("site","slope","treat","trt","RCP")) # Append the C inputs from 2009
temp$cumCinput = temp$cumCinput + temp$cin09 # Add the existing cumulative from 2009 to all cumulatives after that date
sim1099 = temp[,-45] # Balance dataframes by removing the 2009 cinput column

sim8699 = rbind(sim8609, sim1099) # Combine the pre-2009 and post-2009 data

# Obtain total soil C stock before experiment started (in 1985) using same structure as above
sim85soc = ddply(all_data[all_data$year==1985,], c("site","slope","treat","trt","RCP"), summarise,
                 somtc85 = mean(somtc))

test = merge(sim8699, sim85soc, by=c("site","slope","treat","trt","RCP")) # Append the baseline C stock to relevant rows
test$dsoc = test$somtc - test$somtc85 # Find out change in soil C for each year*site*slope*treatment
test$eff = ifelse(test$dsoc<0, ifelse(test$cumCinput<(test$dsoc*-1), 0, test$dsoc/test$cumCinput*100), test$dsoc/test$cumCinput*100) # If the treatment is fallow in the first year there is practically no input and a loss of SOC so efficiency has to be 0

# Average over all sites/slopes/treatment entry points (create error/95% CI for sequestration efficiency)
test2 = ddply(test, c("year","trt","RCP"), summarise,
              seqeff = mean(eff),
              seqeff.se = sd(eff)/sqrt(length(eff)),
              seqeff.up = seqeff + seqeff.se,
              seqeff.dwn = seqeff - seqeff.se,
              seqeff_bdup = quantile(eff, probs=0.975),
              seqeff_bdlow = quantile(eff, probs=0.025),
              avgdsoc = mean(dsoc),
              avgsomtc = mean(somtc),
              avgcinput = mean(cinput),
              avgcumCinput = mean(cumCinput),
              n = length(dsoc))
test2$seqeff2 = test2$avgdsoc/test2$avgcumCinput*100 # If you want you can use this to check - seqeff and seqeff2 should be approximately the same

p.seqeff.all = ggplot(test2, aes(x=year, y=seqeff2, colour=trt, fill=trt)) +
  facet_wrap(~RCP) +
  geom_vline(xintercept=1997.5, linetype='dashed') +
  geom_vline(xintercept=2009.5, linetype='dashed') +
  geom_hline(yintercept = 0, linetype="dashed") +
  annotate("text", x = 2003.5, y= 28, label="WF = WCM") +
  annotate("text", x = 2003.5, y= 25, label="WCMF = WWCM") +
  geom_ribbon(aes(ymax=seqeff_bdup, ymin=seqeff_bdlow), alpha=0.1, colour=NA) +
  geom_line() +
  ylab("Proportion of C inputs retained in soil (%)") +
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
  scale_fill_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen", "orange", "red"),
                      labels = c("WF", "WCF", "WCMF", "OPP", "Grass")) +
  scale_colour_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen", "orange", "red"),
                      labels = c("WF", "WCF", "WCMF", "OPP", "Grass")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

p.seqeff = ggplot(test2[test2$trt!="WF"&test2$trt!="WCMF",], aes(x=year, y=seqeff, colour=trt, fill=trt)) +
  facet_wrap(~RCP) +
  geom_ribbon(aes(ymax=seqeff_bdup, ymin=seqeff_bdlow), alpha=0.15, colour=NA) +
  geom_line() +
  geom_hline(yintercept = 0, linetype="dashed") +
  ylab("Proportion of C inputs retained in soil (%)") +
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
  scale_fill_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("WCF", "OPP", "Grass")) +
  scale_colour_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("WCF", "OPP", "Grass")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

ggsave(p.seqeff.all, file=file.path(figdir, "Sequestration efficiency.pdf"), width=300, height=100, units="mm")
ggsave(p.seqeff, file=file.path(figdir, "Sequestration efficiency_limited.pdf"), width=300, height=100, units="mm")









### Average measured and modelled SOC data (1986-2016) over all treatments (all entry points) 

meas.soc = ddply(meas.raw.slc, c("year","trt","source"), summarise,
                 mean = mean(profilesoc),
                 se = sd(profilesoc)/sqrt(length(profilesoc)),
                 max = max(profilesoc),
                 min = min(profilesoc),
                 ymax = mean+se,
                 ymin = mean-se,
                 bd_upper = quantile(profilesoc, probs=0.975),
                 bd_lower = quantile(profilesoc, probs=0.025),
                 N = length(profilesoc))

mod.soc86.16 = all_data[all_data$year>1985&all_data$year<2017,]

mod.soc = ddply(mod.soc86.16, c("year","trt","source"), summarise,
                mean = mean(somtc),
                se = sd(somtc)/sqrt(length(somtc)),
                max = max(somtc),
                min = min(somtc),
                ymax = mean+se,
                ymin = mean-se,
                bd_upper = quantile(somtc, probs=0.975),
                bd_lower = quantile(somtc, probs=0.025),
                N = length(somtc))

meas.soc = meas.soc[meas.soc$trt!="Additional_trt",]

meas.soc$site = as.factor(meas.soc$site)
meas.soc$slope = as.factor(meas.soc$slope)
meas.soc$trt = as.factor(meas.soc$trt)

meas.soc$combined = paste(meas.soc$site, meas.soc$slope, meas.soc$trt)

meas.lme = lme(mean ~ year, random = ~1|combined, data=meas.soc, na.action=na.omit, method="REML")

summary(meas.lme)

ggplot(mod.soc, aes(x=year, y=mean, colour=trt)) +
  geom_line() +
#  facet_wrap(~site*slope) +
  geom_point(data=meas.soc) +
  geom_errorbar(data=meas.soc, aes(ymax=ymax, ymin=ymin), width = 1) +
  geom_line(aes(y=ymax), linetype="dashed") +
  geom_line(aes(y=ymin), linetype="dashed")










### COMPARING SIMULATED CARBON INPUTS TO SIMULATED SOIL C STOCK CHANGES

# Create a consistent and useful dataframe structure
sim8609 = ddply(all_data[all_data$year>1985&all_data$year<2010,], c("year","site","slope","treat","trt","GCM","RCP","phase","source"), summarise,
                cinput = mean(cinput),
                somtc = mean(somtc),
                som2c.2. = mean(som2c.2.),
                abgdefac = mean(abgdefac),
                petann = mean(petann),
                prcann = mean(prcann),
                resp.1. = mean(resp.1.),
                annet = mean(annet),
                n = length(monthfrac))
nrow(sim8609[sim8609$n!=1,]) # Check - all should 1 so this nrow should be 0

sim09cin = ddply(all_data[all_data$year==2009,], c("site","slope","treat","trt","RCP"), summarise,
                 cin09 = mean(cinput))



# Average over all GCMs and adhere to the structure above
sim1099 = ddply(all_data[all_data$year>2009,], c("year","site","slope","treat","trt","GCM","RCP","phase","source"), summarise,
                cinput = mean(cinput),
                somtc = mean(somtc),
                som2c.2. = mean(som2c.2.),
                abgdefac = mean(abgdefac),
                petann = mean(petann),
                prcann = mean(prcann),
                resp.1. = mean(resp.1.),
                annet = mean(annet),
                n = length(monthfrac))

sim8699 = rbind(sim8609, sim1099) # Combine the pre-2009 and post-2009 data

sim8699 = all_data[all_data$year>1985,]

# Cumulate the carbon input variable by site, slope, treatment (each entry point separately) and RCP
cum_data = within(sim8699, {
  cumCinput <- ave(cinput, site, slope, treat, trt, GCM, RCP, FUN = cumsum)
})

# Obtain total soil C stock before experiment started (in 1985) using same structure as above
sim85soc = ddply(all_data[all_data$year==1985,], c("site","slope","treat","trt","RCP"), summarise,
                 somtc85 = mean(somtc))

test = merge(cum_data, sim85soc, by=c("site","slope","treat","trt","RCP")) # Append the baseline C stock to relevant rows
test$dsoc = test$somtc - test$somtc85 # Find out change in soil C for each year*site*slope*treatment
test$eff = ifelse(test$dsoc<0, ifelse(test$cumCinput<(test$dsoc*-1), 0, test$dsoc/test$cumCinput*100), test$dsoc/test$cumCinput*100) # If the treatment is fallow in the first year there is practically no input and a loss of SOC so efficiency has to be 0

# Average over all sites/slopes/treatment entry points (create error for sequestration efficiency)
test2 = ddply(test, c("year","trt","RCP"), summarise,
              seqeff = mean(eff),
              seqeff.se = sd(eff)/sqrt(length(eff)),
              seqeff.up = seqeff + seqeff.se,
              seqeff.dwn = seqeff - seqeff.se,
              seqeff_bdup = quantile(eff, probs=0.975),
              seqeff_bdlow = quantile(eff, probs=0.025),
              avgdsoc = mean(dsoc),
              avgsomtc = mean(somtc),
              avgcinput = mean(cinput),
              avgcumCinput = mean(cumCinput),
              n = length(dsoc))
test2$seqeff2 = test2$avgdsoc/test2$avgcumCinput*100 # If you want you can use this to check - seqeff and seqeff2 should be approximately the same



ggplot(test2, aes(x=year, y=seqeff, colour=trt)) +
  geom_line() +
  facet_wrap(~RCP) +
  geom_line(aes(y=seqeff_bdup), linetype='dashed') +
  geom_line(aes(y=seqeff_bdlow), linetype='dashed')

p.seqeff = ggplot(test[test$trt!="WF"&test$trt!="WCMF",], aes(x=year, y=eff, colour=trt)) +
  geom_line() +
  facet_wrap(~site*slope*RCP) +
  geom_line(aes(y=seqeff.dwn), linetype='dashed') +
  geom_line(aes(y=seqeff.up), linetype='dashed')


### Average measured and modelled SOC data (1986-2016) over all treatments (all entry points) 

meas.soc = ddply(meas.raw.slc, c("year","trt","source"), summarise,
                 mean = mean(profilesoc),
                 se = sd(profilesoc)/sqrt(length(profilesoc)),
                 max = max(profilesoc),
                 min = min(profilesoc),
                 ymax = mean+se,
                 ymin = mean-se,
                 bd_upper = quantile(profilesoc, probs=0.975),
                 bd_lower = quantile(profilesoc, probs=0.025),
                 N = length(profilesoc))

mod.soc86.16 = all_data[all_data$year>1985&all_data$year<2017,]

mod.soc = ddply(mod.soc86.16, c("year","trt","source"), summarise,
                mean = mean(somtc),
                se = sd(somtc)/sqrt(length(somtc)),
                max = max(somtc),
                min = min(somtc),
                ymax = mean+se,
                ymin = mean-se,
                bd_upper = quantile(somtc, probs=0.975),
                bd_lower = quantile(somtc, probs=0.025),
                N = length(somtc))

meas.soc = meas.soc[meas.soc$trt!="Additional_trt",]

meas.soc$site = as.factor(meas.soc$site)
meas.soc$slope = as.factor(meas.soc$slope)
meas.soc$trt = as.factor(meas.soc$trt)

meas.soc$combined = paste(meas.soc$site, meas.soc$slope, meas.soc$trt)

meas.lme = lme(mean ~ year, random = ~1|combined, data=meas.soc, na.action=na.omit, method="REML")

summary(meas.lme)

ggplot(mod.soc, aes(x=year, y=mean, colour=trt)) +
  geom_line() +
  #  facet_wrap(~site*slope) +
  geom_point(data=meas.soc) +
  geom_errorbar(data=meas.soc, aes(ymax=ymax, ymin=ymin), width = 1) +
  geom_line(aes(y=ymax), linetype="dashed") +
  geom_line(aes(y=ymin), linetype="dashed")


