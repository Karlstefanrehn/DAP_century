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

# Create identical format object to model to aid comparison
meas.slc.yrs = ddply(meas.raw.slc, c("year", "site", "trt", "source"), summarise,
                     N = length(profilesoc),
                     mean = mean(profilesoc),
                     se = sd(profilesoc)/sqrt(length(profilesoc)),
                     ymin=mean(profilesoc)-(sd(profilesoc)/sqrt(length(profilesoc))),
                     ymax=mean(profilesoc)+(sd(profilesoc)/sqrt(length(profilesoc))),
                     type = "Total C")

mod.slc.yrs = ddply(mod.raw.slc, c("year", "site", "trt", "source"), summarise,
                    N = length(somtc),
                    mean = mean(somtc),
                    se = sd(somtc)/sqrt(length(somtc)),
                    ymin=mean(somtc)-(sd(somtc)/sqrt(length(somtc))),
                    ymax=mean(somtc)+(sd(somtc)/sqrt(length(somtc))),
                    type = "Total C")

temp = merge(mod.slc.yrs, meas.slc.yrs, all=T)
temp = temp[temp$trt != "Additional_trt",]
meas.mod.slc = temp

# Use object to examine how total C changes in different treatments
p.mm.slc.1900 = ggplot(temp, aes(x=year,y=mean,colour=trt)) +
  geom_line(data=temp[temp$source=="Modelled",]) +
  geom_point(data=temp[temp$source=="Measured",]) +
  scale_x_continuous(expand=c(0,0),
                     limits=c(1900,2017)) +
  scale_y_continuous(expand=c(0,0),
                     limits=c(0,5000)) +
  facet_wrap(~site, nrow=1) +
  ggtitle("Absolute total soil C (gC/m2)") +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), width = 0.25, alpha = 1) +
  ylab(expression(paste("Total soil C (gC ", m^-2,")"))) +
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

p.mm.slc.1985 = ggplot(temp, aes(x=year,y=mean,colour=trt)) +
  geom_line(data=temp[temp$source=="Modelled",]) +
  geom_point(data=temp[temp$source=="Measured",]) +
  scale_x_continuous(expand=c(0,0),
                     limits=c(1985,2017)) +
  scale_y_continuous(expand=c(0,0),
                     limits=c(0,4000)) +
  facet_wrap(~site, ncol=3) +
  ggtitle("Absolute total soil C (gC/m2)") +
  geom_errorbar(aes(ymax=ymax, ymin=ymin, fill=source), width = 0.25, alpha = 1) +
  ylab(expression(paste("Total soil C (gC ", m^-2,")"))) +
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

ggsave(p.mm.slc.1900, file=file.path(figdir, "comp_slc_tc_1900.pdf"), width=550, height=300, units="mm")
ggsave(p.mm.slc.1985, file=file.path(figdir, "comp_slc_tc_1985.pdf"), width=300, height=250, units="mm")

# Save objects of future interest
save(meas.raw.slc, file=file.path(Robjsdir, "meas.raw.slc"))
save(meas.mod.slc, file=file.path(Robjsdir, "meas.mod.slc"))

### Remove all unwanted objects in the environment

rm(temp)
