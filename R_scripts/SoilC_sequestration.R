# ---------------------------------------------------------------------------------------#
### ESTIMATING SOIL CARBON SEQUESTRATION EFFICIENCY BY RELATING TO SIMULATED C INPUTS  ###
# ---------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

### COMPARING SIMULATED CARBON INPUTS TO SIMULATED SOIL C STOCK CHANGES

styr = 1985 # Choose the year you want to compare the inputs to - can read the figures as "proportion of cumulative C inputs retained in soils starting from this year" (must be before 2010)

# Because each GCM needs to start from the 2009 cumulative we first need to obtain those values
sim8609 = all_data[all_data$year>styr&all_data$year<2010,] # Subset before 2009
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
sim85soc = ddply(all_data[all_data$year==styr,], c("site","slope","treat","trt","RCP"), summarise,
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
              seqeff_bdhi = quantile(eff, probs=0.975),
              seqeff_bdlo = quantile(eff, probs=0.025),
              avgdsoc = mean(dsoc),
              avgsomtc = mean(somtc),
              avgcinput = mean(cinput),
              avgcumCinput = mean(cumCinput),
              n = length(dsoc))
test2$seqeff2 = test2$avgdsoc/test2$avgcumCinput*100 # If you want you can use this to check - seqeff and seqeff2 should be approximately the same

p.seqeff.all = ggplot(test2, aes(x=year, y=seqeff, colour=trt, fill=trt)) +
  facet_wrap(~RCP) +
  geom_vline(xintercept=1997.5, linetype='dotted') +
  geom_vline(xintercept=2009, linetype='dotted') +
  geom_hline(yintercept = 0, linetype="dashed") +
  annotate("text", x = 2003.5, y= 30, label="WF=WCM", size=2) +
  annotate("text", x = 2003.5, y= 25, label="WCMF=WWCM", size=2) +
  geom_ribbon(data=test2[test2$year>2008,], aes(ymax=seqeff_bdhi, ymin=seqeff_bdlo), alpha=0.15, colour=NA) +
  geom_line() +
  ylab("Cumulative C inputs retained\nin soil since 1985 (%)") +
  xlab("Year") +
  scale_x_continuous(expand=c(0,0), limits=c(1986,2100)) +
  scale_y_continuous(expand=c(0,0), limits=c(-4,33)) +
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
                      labels = c("WF", "WCF", "WCMF", "CC", "Grass")) +
  scale_colour_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen", "orange", "red"),
                      labels = c("WF", "WCF", "WCMF", "CC", "Grass")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

p.seqeff = ggplot(test2[test2$trt!="WF"&test2$trt!="WCMF",], aes(x=year, y=seqeff, colour=trt, fill=trt)) +
  facet_wrap(~RCP) +
  geom_vline(xintercept=2009, linetype='dotted') +
  geom_ribbon(data=test2[test2$year>2008&test2$trt!="WF"&test2$trt!="WCMF",], aes(ymax=seqeff_bdhi, ymin=seqeff_bdlo), alpha=0.1, colour=NA) +
  geom_line() +
  geom_hline(yintercept = 0, linetype="dashed") +
  ylab("Cumulative C inputs retained\nin soil since 1985 (%)") +
  xlab("Year") +
  scale_x_continuous(expand=c(0,0), limits=c(1986,2100)) +
  scale_y_continuous(expand=c(0,0), limits=c(-4,33)) +
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
                      labels = c("WCF", "CC", "Grass")) +
  scale_colour_manual("Treatment",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("WCF", "CC", "Grass")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

ggsave(p.seqeff.all, file=file.path(figdir, "Sequestration efficiency.pdf"), width=300, height=100, units="mm")
ggsave(p.seqeff, file=file.path(figdir, "Sequestration efficiency_limited.pdf"), width=300, height=100, units="mm")

### PLOTTING CIN vs SOC BY PHASE
# Note - assumes all_data has already had factors and levels sorted

cum_data = within(all_data, {
  cumCinput <- ave(cinput, site, slope, treat, RCP, GCM, FUN = cumsum)
})

# DDPLY CAN BE SLOW WORKING WITH LARGE DATA FRAMES SO USE DATA TABLE INSTEAD - should be the same output
#simple.sum = ddply(cum_data, c("year","site","trt","RCP","phase","source"), summarise,
#                cinx = mean(cinput),
#                tcx = mean(somtc),
#                prc = mean(prcann),
#                pet = mean(petann),
#                N = length(time))

simple.sum = cum_data[,list(cinx = mean(cinput),
                            tcx = mean(somtc),
                            prc = mean(prcann),
                            resp = mean(resp.1.),
                            pet = mean(petann),
                            N = length(time)),
                      by=list(year,site,trt,RCP,phase,source)]

simple.sum = as.data.frame(simple.sum)

# Shows the difference between inputs and outputs on an annual basis (in gC/m2)
ggplot(simple.sum[simple.sum$year>=1985,], aes(x=year, y=cinx-resp, colour=trt)) +
  geom_smooth(span=0.1,se=F) +
  facet_wrap(~site*RCP) +
  geom_hline(yintercept=0)

# OTHER FACTORS THAT COULD BE GRAPHED
#             cin.upper = quantile(cinput, probs=0.975),
#             cin.lower = quantile(cinput, probs=0.025),
#             tc.upper = quantile(somtc, probs=0.975),
#             tc.lower = quantile(somtc, probs=0.025),
#             slw = mean(som2c.2.),
#             slw.upper = quantile(som2c.2., probs=0.975),
#             slw.lower = quantile(som2c.2., probs=0.025),
#             prc = mean(prcann),
#             prc.upper = quantile(prcann, probs=0.975),
#             prc.lower = quantile(prcann, probs=0.025),
#             pet = mean(petann),
#             pet.upper = quantile(petann, probs=0.975),
#             pet.lower = quantile(petann, probs=0.025),
#             resp = mean(resp.1.),
#             resp.upper = quantile(resp.1., probs=0.975),
#             resp.lower = quantile(resp.1., probs=0.025),
#             defac = mean(abgdefac),
#             defac.upper = quantile(abgdefac, probs=0.975),
#             defac.lower = quantile(abgdefac, probs=0.025),
#             net = mean(annet),
#             net.upper = quantile(annet, probs=0.975),
#             net.lower = quantile(annet, probs=0.025),
#             agc = mean(agcacc),
#             agc.upper = quantile(agcacc, probs=0.975),
#             agc.lower = quantile(agcacc, probs=0.025),
#             grn = mean(cgrain),
#             grn.upper = quantile(cgrain, probs=0.975),
#             grn.lower = quantile(cgrain, probs=0.025),
#             abcin = mean((agcacc-cgrain)),
#             abcin.upper = quantile((agcacc-cgrain), probs=0.975),
#             abcin.lower = quantile((agcacc-cgrain), probs=0.025),

graphdf = ddply(simple.sum, c("site","trt","RCP","phase","source"), summarise,
                cin = sum(cinx),
                tc = last(tcx)-first(tcx),
                prc = sum(prc),
                resp = sum(resp),
                pet = sum(pet),
                N = length(year))

# OTHER FACTORS THAT COULD BE GRAPHED
#             slw = last(slw)-first(slw),
#             prc = sum(prc),
#             pet = sum(pet),
#             resp = sum(resp),
#             defac = mean(defac),
#             net = sum(net),
#             agc = sum(agc),
#             grn = sum(grn),
#             abcin = sum((abcin)),

nrow(graphdf[graphdf$N!=12,]) # Check how many points aren't made up of 12 years (they should be!)
graphdf = graphdf[graphdf$N==12,] # Limit the dataframe to only those with 12 years of points

graphdf$RCP[graphdf$RCP=="RCP45"] = "RCP 4.5" # Just to be more correct in publishing
graphdf$RCP[graphdf$RCP=="RCP85"] = "RCP 8.5" # Just to be more correct in publishing

graphdf2 = rbind(graphdf[graphdf$phase!="1998-2009",], graphdf[graphdf$phase=="1998-2009"&graphdf$trt!="WF"&graphdf$trt!="WCMF",]) # Remove WF and WCMF from phase #2 as they aren't consistent

p.cin_tc.phs = ggplot(graphdf2, aes(x=cin, y=tc, colour=trt)) +
  geom_point(size=3, aes(pch=RCP)) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase, ncol=3) +
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
  scale_shape_manual("RCP Scenario",
                     values = c(15,17),
                     labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) +
  scale_size(guide=F)

##### MORE POINTS ON THE FIGURES

# DDPLY CAN BE SLOW WORKING WITH LARGE DATA FRAMES SO USE DATA TABLE INSTEAD - should be the same output
#detail.sum = ddply(cum_data, c("year","site","treat","trt","GCM","RCP","phase","source"), summarise,
#                   cinx = mean(cinput),
#                   tcx = mean(somtc),
#                   prc = mean(prcann),
#                   pet = mean(petann),
#                   net = mean(annet),
#                   defac = mean(abgdefac),
#                   N = length(time))

detail.sum = cum_data[,list(cinx = mean(cinput),
                            tcx = mean(somtc),
                            prc = mean(prcann),
                            pet = mean(petann),
                            net = mean(annet),
                            resp = mean(resp.1.),
                            defac = mean(abgdefac),
                            N = length(time)),
                      by=list(year,site,treat,trt,GCM,RCP,phase,source)]

detail.sum = as.data.frame(detail.sum)

# OTHER FACTORS THAT COULD BE GRAPHED
#             cin.upper = quantile(cinput, probs=0.975),
#             cin.lower = quantile(cinput, probs=0.025),
#             tc.upper = quantile(somtc, probs=0.975),
#             tc.lower = quantile(somtc, probs=0.025),
#             slw = mean(som2c.2.),
#             slw.upper = quantile(som2c.2., probs=0.975),
#             slw.lower = quantile(som2c.2., probs=0.025),
#             prc = mean(prcann),
#             prc.upper = quantile(prcann, probs=0.975),
#             prc.lower = quantile(prcann, probs=0.025),
#             pet = mean(petann),
#             pet.upper = quantile(petann, probs=0.975),
#             pet.lower = quantile(petann, probs=0.025),
#             resp = mean(resp.1.),
#             resp.upper = quantile(resp.1., probs=0.975),
#             resp.lower = quantile(resp.1., probs=0.025),
#             defac = mean(abgdefac),
#             defac.upper = quantile(abgdefac, probs=0.975),
#             defac.lower = quantile(abgdefac, probs=0.025),
#             net = mean(annet),
#             net.upper = quantile(annet, probs=0.975),
#             net.lower = quantile(annet, probs=0.025),
#             agc = mean(agcacc),
#             agc.upper = quantile(agcacc, probs=0.975),
#             agc.lower = quantile(agcacc, probs=0.025),
#             grn = mean(cgrain),
#             grn.upper = quantile(cgrain, probs=0.975),
#             grn.lower = quantile(cgrain, probs=0.025),
#             abcin = mean((agcacc-cgrain)),
#             abcin.upper = quantile((agcacc-cgrain), probs=0.975),
#             abcin.lower = quantile((agcacc-cgrain), probs=0.025),

graphdf = ddply(detail.sum, c("site","treat","trt","GCM","RCP","phase","source"), summarise,
                cin = sum(cinx),
                tc = last(tcx)-first(tcx),
                prc = sum(prc),
                pet = sum(pet),
                resp = sum(resp),
                net = sum(net),
                defac = mean(defac),
                N = length(year))

# OTHER FACTORS THAT COULD BE GRAPHED
#             slw = last(slw)-first(slw),
#             prc = sum(prc),
#             pet = sum(pet),
#             resp = sum(resp),
#             defac = mean(defac),
#             net = sum(net),
#             agc = sum(agc),
#             grn = sum(grn),
#             abcin = sum((abcin)),

nrow(graphdf[graphdf$N!=12,]) # Check how many points aren't made up of 12 years (they should be!)
graphdf = graphdf[graphdf$N==12,] # Limit the dataframe to only those with 12 years of points

graphdf$RCP[graphdf$RCP=="RCP45"] = "RCP 4.5" # Just to be more correct in publishing
graphdf$RCP[graphdf$RCP=="RCP85"] = "RCP 8.5" # Just to be more correct in publishing

graphdf2 = rbind(graphdf[graphdf$phase!="1998-2009",], graphdf[graphdf$phase=="1998-2009"&graphdf$trt!="WF"&graphdf$trt!="WCMF",]) # Remove WF and WCMF from phase #2 as they aren't consistent

# Comparing SOC to inputs (as above but with all points)
p.cin_tc.phs_all = ggplot(graphdf2, aes(x=cin, y=tc, colour=trt)) +
  geom_point(size=2, aes(pch=RCP), alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase, ncol=3) +
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
  scale_shape_manual("RCP Scenario",
                     values = c(15,17),
                     labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) +
  scale_size(guide=F)

# Limited panels from above to go into publication
p.cin_tc.phs_lim = ggplot(graphdf2[graphdf2$phase %in% c("2010-2021", "2082-2093"),], aes(x=cin, y=tc, colour=trt)) +
  geom_point(size=2, alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase*RCP, ncol=2) +
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
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_size(guide=F)

p.cin_resp.phs_lim = ggplot(graphdf2[graphdf2$phase %in% c("2010-2021", "2082-2093"),], aes(x=cin, y=resp, colour=trt)) +
  geom_point(size=2, alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Total Soil CO2 emissions (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase*RCP, ncol=2) +
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
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_size(guide=F)
  
p.resp_tc.phs_lim = ggplot(graphdf2[graphdf2$phase %in% c("2010-2021", "2082-2093"),], aes(x=resp, y=tc, colour=trt)) +
  geom_point(size=2, alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Soil CO2 emissions (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase*RCP, ncol=2) +
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
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_size(guide=F)
  
p.resp_defac.phs_lim = ggplot(graphdf2[graphdf2$phase %in% c("2010-2021", "2082-2093"),], aes(x=resp, y=defac, colour=trt)) +
  geom_point(size=2, alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Soil CO2 emissions (gC ", m^-2,")"))) +
  ylab(expression(paste("Average Decomposition factor (0-1)"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase*RCP, ncol=2) +
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
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_size(guide=F)

p.defac_tc.phs_lim = ggplot(graphdf2[graphdf2$phase %in% c("2010-2021", "2082-2093"),], aes(x=defac, y=tc, colour=trt)) +
  geom_point(size=2, alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  xlab(expression(paste("Average Decomposition factor (0-1)"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase*RCP, ncol=2) +
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
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_size(guide=F)

# Comparing SOC to model factor influencing decomposition
p.defac_tc.phs = ggplot(graphdf2, aes(x=defac, y=tc, colour=trt)) +
  geom_point(size=2, aes(pch=RCP), alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Decomposition factor (0-1)"))) +
  ylab(expression(paste("Average Total SOC Change (gC ", m^-2,")"))) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_wrap(~phase, ncol=3) +
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
  scale_shape_manual("RCP Scenario",
                     values = c(15,17),
                     labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) +
  scale_size(guide=F)

# If you wish to remove the phsaes before 2009 -
#graphdf2 = graphdf[graphdf$phase!="1998-2009"&graphdf$phase!="1986-1997",] # For graphing climate change we only need phases after 2010

# Comparing C inputs to precipitation
p.cin_prc.phs = ggplot(graphdf2, aes(x=cin, y=prc*10, colour=trt)) +
  geom_point(size=2, aes(pch=RCP), alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Cumulative precipitation (mm)"))) +
  facet_wrap(~phase, ncol=3) +
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
  scale_shape_manual("RCP Scenario",
                     values = c(15,17),
                     labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) +
  scale_size(guide=F)

# Comparing C inputs to potential evapotranspiration
p.cin_pet.phs = ggplot(graphdf2, aes(x=cin, y=pet*10, colour=trt)) +
  geom_point(size=2, aes(pch=RCP), alpha=0.3) +
  geom_smooth(method='lm', se=F) +
  xlab(expression(paste("Average Total Inputs (gC ", m^-2,")"))) +
  ylab(expression(paste("Cumulative PET (mm)"))) +
  facet_wrap(~phase, ncol=3) +
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
  scale_shape_manual("RCP Scenario",
                     values = c(15,17),
                     labels = c("RCP 4.5", "RCP 8.5")) +
  scale_colour_manual("Treatment",
                      values = c("darkgreen","firebrick2","black","cornflowerblue","darkorange2"),
                      labels = c("WF","WCF","WCMF","CC","Grass")) +
  scale_linetype_manual("RCP Scenario",
                        values = c(1,2),
                        labels = c("RCP 4.5", "RCP 8.5")) +
  scale_size(guide=F)

ggsave(p.cin_tc.phs, file=file.path(figdir, "Inputs vs SOC future phases.pdf"), width=300, height=225, units="mm")
ggsave(p.cin_tc.phs_all, file=file.path(figdir, "Inputs vs SOC future phases_ALL.pdf"), width=300, height=225, units="mm")
ggsave(p.cin_prc.phs, file=file.path(figdir, "Inputs vs Precip future phases.pdf"), width=300, height=225, units="mm")
ggsave(p.defac_tc.phs, file=file.path(figdir, "Defac vs SOC future phases.pdf"), width=300, height=225, units="mm")
ggsave(p.cin_pet.phs, file=file.path(figdir, "Inputs vs PET future phases.pdf"), width=300, height=225, units="mm")

ggsave(p.cin_tc.phs_lim, file=file.path(figdir, "Inputs vs SOC future phases_Limited.pdf"), width=250, height=250, units="mm")
ggsave(p.cin_resp.phs_lim, file=file.path(figdir, "Inputs vs Resp future phases_Limited.pdf"), width=250, height=250, units="mm")
ggsave(p.resp_tc.phs_lim, file=file.path(figdir, "Resp vs SOC future phases_Limited.pdf"), width=250, height=250, units="mm")
ggsave(p.resp_defac.phs_lim, file=file.path(figdir, "Resp vs Defac future phases_Limited.pdf"), width=250, height=250, units="mm")
ggsave(p.defac_tc.phs_lim, file=file.path(figdir, "Defac vs SOC future phases_Limited.pdf"), width=250, height=250, units="mm")
