# ----------------------------------------------------------------------------#
### CREATES OBJECTS THAT CAN BE USED WITH MODELLED VALUES TO COMPARE SOIL C ###
# ----------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

meas.dap.slc <- read.csv(file=file.path(datadir, "basic_soilc.csv"),
                    sep=",", header=T)

# Create depth column

meas.dap.slc$depthD = meas.dap.slc$d_to-meas.dap.slc$d_from

# Remove all rows where the reported carbon concentration is 0 - this is obviously impossible and will skew
# sums to 20cm below their real value
#meas.slc.edit = meas.dap.slc
meas.slc.edit = meas.dap.slc[meas.dap.slc$c_conc!=0,]

# Sum the soil C data to 20cm as a check to ensure no missing layers etc.

soilc.profile = ddply(meas.slc.edit, c("year", "site", "slope", "treat", "strip", "rep"), summarise,
                      depD.profile = sum(depthD),
                      profilesoc = sum(soc),
                      N.profile = length(soc))

# Convert t/ha into g/m2

soilc.profile$profilesoc = soilc.profile$profilesoc*100

# Make consistent column names with mod data

meas.raw.slc = soilc.profile
meas.raw.slc$treatno = meas.raw.slc$treat

meas.raw.slc$treat[meas.raw.slc$treatno == 1] = "WF"
meas.raw.slc$treat[meas.raw.slc$treatno == 2] = "FW"
meas.raw.slc$treat[meas.raw.slc$treatno == 3] = "WCF"
meas.raw.slc$treat[meas.raw.slc$treatno == 4] = "CFW"
meas.raw.slc$treat[meas.raw.slc$treatno == 5] = "FWC"
meas.raw.slc$treat[meas.raw.slc$treatno == 6] = "WCMF"
meas.raw.slc$treat[meas.raw.slc$treatno == 7] = "CMFW"
meas.raw.slc$treat[meas.raw.slc$treatno == 8] = "MFWC"
meas.raw.slc$treat[meas.raw.slc$treatno == 9] = "FWCM"
meas.raw.slc$treat[meas.raw.slc$treatno == 10] = "OPP"
meas.raw.slc$treat[meas.raw.slc$treatno == 11] = "Grass"
meas.raw.slc$treat[meas.raw.slc$treatno == 12] = "Additional_trt"
meas.raw.slc$treat[meas.raw.slc$treatno == 13] = "Additional_trt"

meas.raw.slc$trt[meas.raw.slc$treatno == 1] = "WF"
meas.raw.slc$trt[meas.raw.slc$treatno == 2] = "WF"
meas.raw.slc$trt[meas.raw.slc$treatno == 3] = "WCF"
meas.raw.slc$trt[meas.raw.slc$treatno == 4] = "WCF"
meas.raw.slc$trt[meas.raw.slc$treatno == 5] = "WCF"
meas.raw.slc$trt[meas.raw.slc$treatno == 6] = "WCMF"
meas.raw.slc$trt[meas.raw.slc$treatno == 7] = "WCMF"
meas.raw.slc$trt[meas.raw.slc$treatno == 8] = "WCMF"
meas.raw.slc$trt[meas.raw.slc$treatno == 9] = "WCMF"
meas.raw.slc$trt[meas.raw.slc$treatno == 10] = "OPP"
meas.raw.slc$trt[meas.raw.slc$treatno == 11] = "Grass"
meas.raw.slc$trt[meas.raw.slc$treatno == 12] = "Additional_trt"
meas.raw.slc$trt[meas.raw.slc$treatno == 13] = "Additional_trt"

meas.raw.slc$slope[meas.raw.slc$slope == 1] = "Summit"
meas.raw.slc$slope[meas.raw.slc$slope == 2] = "Sideslope"
meas.raw.slc$slope[meas.raw.slc$slope == 3] = "Toeslope"
meas.raw.slc$slope = factor(meas.raw.slc$slope, levels = c("Summit", "Sideslope", "Toeslope"))

meas.raw.slc$site[meas.raw.slc$site == 1] = "Sterling"
meas.raw.slc$site[meas.raw.slc$site == 2] = "Stratton"
meas.raw.slc$site[meas.raw.slc$site == 3] = "Walsh"

meas.raw.slc$source = "Measured"

meas.raw.slc = meas.raw.slc[meas.raw.slc$depD.profile==20,] # Isolate only data where all layers are reported (therefore to consistent 20cm depth)
meas.raw.slc = meas.raw.slc[meas.raw.slc$trt != "Additional_trt",] # Drop the additional treatment plots as they're unused in further analysis

### Note - 1985 data is in fact 1986 according to the "DAP_SSW_86and97 Soil fractions carbon nitrgoen top20.xlsx" file using "1986whole" data from LECO analysis
# Because this is not to strip or treatment level it is justified by the assumption that all sites*slopes should have the same SOC stock regardless of strip or treatment
# Consequently, the 1985 data is duplicated for all treatments to ease further analysis in R:

trts = levels(as.factor(meas.raw.slc$trt)) # Get levels to loop over
temp2 = data.frame() # Create dataframe to put the data in

for(treat in trts) {
  temp = meas.raw.slc[meas.raw.slc$year==1985,]
  temp$trt = treat # Change treatment name
  temp2 = rbind(temp2,temp)
}

meas.raw.slc = unique(rbind(meas.raw.slc, temp2)) # Bind all original data (with all years) to the new dataframe and drop duplicated rows

# Create identical format object to model to aid comparison

meas.slc.raw = ddply(meas.raw.slc, c("year", "site", "slope", "treat", "trt", "rep", "treatno", "source"), summarise,
                     N = length(profilesoc),
                     mean = mean(profilesoc),
                     se = sd(profilesoc)/sqrt(length(profilesoc)),
                     ymin=mean(profilesoc)-(sd(profilesoc)/sqrt(length(profilesoc))),
                     ymax=mean(profilesoc)+(sd(profilesoc)/sqrt(length(profilesoc))),
                     type = "Total C")

temp = mod.raw.slc
temp = subset(temp, temp$monthfrac == 0.0)
temp = subset(temp, temp$cinput != 0) # This removes the first month of extended simulations by deleting any rows of cumulative columns where 0 is found
temp$year[temp$monthfrac==0] = temp$year[temp$monthfrac==0]-1 # Month 0.0 is in fact December of the previous year
temp$monthfrac[temp$monthfrac==0] = 1 # Month 0.0 is in fact December of the previous year
temp$month = round(temp$monthfrac*12,0)
temp$rep = 1 # To balance out columns to ease merging

mod.slc.raw = ddply(temp, c("year", "site", "slope", "treat", "trt", "rep", "treatno", "source"), summarise,
                    N = length(somtc),
                    mean = mean(somtc),
                    se = sd(somtc)/sqrt(length(somtc)),
                    ymin=mean(somtc)-(sd(somtc)/sqrt(length(somtc))),
                    ymax=mean(somtc)+(sd(somtc)/sqrt(length(somtc))),
                    type = "Total C")

temp = merge(mod.slc.raw, meas.slc.raw, all=T)
meas.mod.raw.slc = temp

# Just to summarise all measured and modelled soil C data

soilC.summary = ddply(meas.mod.raw.slc, c("year", "site", "trt", "source", "type"), summarise,
                      totN = sum(N),
                      N = length(mean),
                      soilc = mean(mean),
                      minslc = min(mean),
                      maxslc = max(mean),
                      sd = sd(mean),
                      se = sd(mean)/sqrt(length(mean)),
                      ymax = soilc + (sd/sqrt(length(mean))),
                      ymin = soilc - (sd/sqrt(length(mean))))

soilC.summary$trt = factor(soilC.summary$trt, levels = c("WF", "WCF", "WCMF", "OPP", "Grass")) # Relevel the treatments that are plotted from least intense to most intense

p.soilC = ggplot(soilC.summary, aes(x=year, y=soilc/100, colour=site, fill=site)) +
  geom_ribbon(data=soilC.summary[soilC.summary$source=="Modelled",], aes(ymax=ymax/100, ymin=ymin/100), colour=NA, alpha=0.5) +
  geom_line(data=soilC.summary[soilC.summary$source=="Modelled",]) +
  geom_point(data=soilC.summary[soilC.summary$source=="Measured"&soilC.summary$year!=1986,]) +
  geom_errorbar(data=soilC.summary[soilC.summary$source=="Measured"&soilC.summary$year!=1986,], aes(ymin=ymin/100, ymax=ymax/100), width=2) +
  facet_wrap(~trt, nrow=1) +
  scale_x_continuous(expand=c(0,0), limits=c(1950,2019), 
                     breaks=c(1955,1975,1995,2015), labels=c(1955,1975,1995,2015)) +
  scale_y_continuous(expand=c(0,0), limits=c(8,42)) +
  ylab(expression(paste("Total soil C (tC ", ha^-1,")"))) +
  xlab("Year") +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size = 14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(angle = 45, hjust = 0.8, vjust = 0.8),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank()) +
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_fill_manual("Site",
                    values = c("coral2","cornflowerblue", "darkgreen"),
                    labels = c("Sterling", "Stratton", "Walsh"))

ggsave(p.soilC, file=file.path(figdir, "SoilC_1950-2016.pdf"), width=400, height=150, units="mm")

# Save objects of future interest
save(meas.raw.slc, file=file.path(Robjsdir, "meas.raw.slc"))
meas.mod.slc = soilC.summary # Because original name is too generic
save(meas.mod.slc, file=file.path(Robjsdir, "meas.mod.slc"))
save(meas.mod.raw.slc, file=file.path(Robjsdir, "meas.mod.raw.slc"))

soilC.summary = ddply(meas.mod.raw.slc[meas.mod.raw.slc$year>1984,], c("year", "source", "trt", "type"), summarise,
                      totN = sum(N),
                      N = length(mean),
                      soilc = mean(mean),
                      minslc = min(mean),
                      maxslc = max(mean),
                      sd = sd(mean),
                      ymax = soilc + (sd/sqrt(length(mean))),
                      ymin = soilc - (sd/sqrt(length(mean))))

write.csv(soilC.summary, file=file.path(figdir, "soil_carbon_85-16.csv"))

### Remove all unwanted objects in the environment

rm(temp)
