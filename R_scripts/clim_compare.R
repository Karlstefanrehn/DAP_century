# ----------------------------------------------------------------------------------------------#
### COMPARES TEMPERATURE AND PRECIPITATION DATA - WHAT WAS MEASURED VS WHAT WAS USED TO MODEL ###
# ----------------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

# COMPARING MONTHLY PRECIPITATION MEASURED VS USED FOR SIMULATION

# Load DAP_monthly_precip.csv
dap.precip = read.csv(file=file.path(datadir, "DAP_monthly_precip.csv"),  # Load in data
                      sep=",", header=T, stringsAsFactors = FALSE)

dap.precip = dap.precip[,-c(5:6)] # Drop 5th and 6th columns
dap.precip = dap.precip[dap.precip$year>=1986&dap.precip$year<2010,] # Examine 1986 to 2009 only

dap.precip$date = ISOdatetime(dap.precip$year, dap.precip$month, 14,1,1,1, tz="UTC") # Include a date column using year and month

d = dap.precip$date[is.na(dap.precip$prec)] # Determine the date of any rows that include blank values of precipitation
s = dap.precip$site[is.na(dap.precip$prec)] # Determine the site of any rows that include blank values of precipitation

s2p = (dap.precip$prec[dap.precip$date==d&dap.precip$site==s-1]+dap.precip$prec[dap.precip$date==d&dap.precip$site==s+1])/2

dap.precip$prec[is.na(dap.precip$prec)] = s2p # Fill the NA of averaged precip of other two sites

# Use .lis files and "rain" column but convert to mm (x10)

dc.precip = ste_side_wf.lis # All treatments and slopes at a single site should be the same so any will work
dc.precip$site = 1
temp = str_side_wf.lis
temp$site = 2
temp2 = wal_side_wf.lis
temp2$site = 3

dc.precip = rbind(dc.precip, temp, temp2) # Combine
rm (temp, temp2) # Remove unwanted objects

dc.precip$year = floor(dc.precip$time) # Create year column
dc.precip$month = round((dc.precip$time - dc.precip$year)*12,1) # Create month column
dc.precip$month[dc.precip$month == 0] = 12 # Month "0" is actually december of the previous year
dc.precip$year[dc.precip$month == 12] = dc.precip$year[dc.precip$month == 12]-1  # Month "0" is actually december of the previous year
dc.precip = dc.precip[dc.precip$year>=1986&dc.precip$year<2010,] # Only interested in after 1986 and before 2010

keep = c("site", "year", "month", "rain")
dc.precip = dc.precip[keep] # Limit the DC dataset

names(dc.precip)[names(dc.precip) == 'rain'] = 'prec' # Rename column
dc.precip$date = ISOdatetime(dc.precip$year, dc.precip$month, 14,1,1,1, tz="UTC") # Name consistent date column

dc.precip$prec = dc.precip$prec*10 # Convert precipitation to mm

# Compare each site/month/year individually

dap.precip$source = "Measured" # Clarify the source of the value
dc.precip$source = "Modelled" # Clarify the source of the value

precip = rbind(dap.precip, dc.precip) # Append modelled to measured
precip2 = merge(dap.precip, dc.precip, by=c("year","site","month","date"), all=T) # Same as cbind

# Create phases
precip$phase = "86-97"
precip2$phase = "86-97"
precip$phase[precip$year>1997] = "98-09"
precip2$phase[precip2$year>1997] = "98-09"

# Make sites factors and clear
precip$site[precip$site == 1] = "Sterling"
precip$site[precip$site == 2] = "Stratton"
precip$site[precip$site == 3] = "Walsh"

precip2$site[precip2$site == 1] = "Sterling"
precip2$site[precip2$site == 2] = "Stratton"
precip2$site[precip2$site == 3] = "Walsh"

# Sum over each year
ann.prec = ddply(precip, c("year","phase","site","source"), summarise,
      N = length(prec),
      precip = sum(prec))

p.ann.prec = ggplot(ann.prec, aes(x=year, y=precip, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Sum over each phase
phs.prec = ddply(precip, c("phase","site","source"), summarise,
      N = length(prec),
      precip = sum(prec))

p.phs.prec = ggplot(phs.prec, aes(x=phase, y=precip, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Sum over all measurement period
tot.prec = ddply(precip, c("site","source"), summarise,
      N = length(prec),
      precip = sum(prec))

p.prec = ggplot(tot.prec, aes(x=site, y=precip, fill=source)) +
  geom_text(fontface = "italic", aes(y=11750, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(fontface = "italic", aes(y=12250, fill=source,label = paste(round(precip, 0),"mm")), position=dodge, size=3.5) +
  geom_bar(stat='identity', position='dodge') +
  scale_y_continuous(expand=c(0,0), limits=c(0,12500)) +
  ylab(expression(paste("Cumulative precipitation (mm)"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

# Check measured vs model-used for all months
p.mm.prec = ggplot(precip2, aes(x=prec.x, y=prec.y, colour=site)) +
  geom_point() +
  geom_abline(slope=1, intercept=0) +
  geom_smooth(method="lm", se=F, formula = y~x+0) +
  scale_y_continuous(expand=c(0,0), limits=c(0,250)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,250)) +
  ylab(expression(paste("Model-used precipitation (mm)"))) +
  xlab(expression(paste("Measured precipitation (mm)"))) +
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
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

# Check linearity metrics (e.g. slope) for each site. Optionally force intercept through 0

obj1 = lm(precip2$prec.y~precip2$prec.x+0)
obj2 = lm(precip2$prec.y~(precip2$prec.x*precip2$site)+0)
summary(obj1)
summary(obj2)

temp1 = precip2[precip2$site=="Sterling",]
temp2 = precip2[precip2$site=="Stratton",]
temp3 = precip2[precip2$site=="Walsh",]

obj_ste = lm(temp1$prec.y~temp1$prec.x+0)
summary(obj_ste)
obj_str = lm(temp2$prec.y~temp2$prec.x+0)
summary(obj_str)
obj_wal = lm(temp3$prec.y~temp3$prec.x+0)
summary(obj_wal)

##################################
########## TEMPERATURE ###########
##################################

# COMPARING DAILY SOIL TEMPERATURE (5cm) MEASURED VS USED FOR SIMULATION (surface)
# Simulation expected to be noticably higher, especially for Walsh as it's surface vs buried

dap.clim <- read.csv(file=file.path(datadir, "DAP_89to97_clim.csv"),
                     sep=",", header=T, stringsAsFactors = FALSE)

dap.clim = subset(dap.clim, SITE!=0) # Drop rows where site = 0

dap.clim = subset(dap.clim, YEAR>90) # Unclear which row is which for this incorrectly entered data so drop row
dap.clim$YEAR[dap.clim$YEAR<100] = dap.clim$YEAR[dap.clim$YEAR<100]+1900 # Some years are input as two-digit format

dap.clim$date = ISOdatetime(dap.clim$YEAR, dap.clim$MONTH, dap.clim$DAY,1,1,1, tz="UTC") # Include a date column using year and month

dap.clim$SOIL_F[dap.clim$SOIL_F==999.9] = NA # 999.9 are clearly erroneous
dap.clim$SOIL_F[dap.clim$SOIL_F==0] = NA # 0 are clearly erroneous

# Site 1 errors manually identified
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1992&dap.clim$MONTH==7&dap.clim$DAY>=14] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1992&dap.clim$MONTH>=8] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH<=5] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==6&dap.clim$DAY<=29] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==7&dap.clim$DAY>=5&dap.clim$DAY<=11] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==8&dap.clim$DAY>=3&dap.clim$DAY<=9] = NA # From July 14th 1992 to end of 1993 there are muliple errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==11&dap.clim$DAY>=4&dap.clim$DAY<=5] = NA # From July 14th 1992 to end of 1993 there are muliple errors

# Site 2 errors manually identified
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==2&dap.clim$YEAR==1993&dap.clim$MONTH==6&dap.clim$DAY==30] = NA # From June 30th 1993 to October 16th 1993 there are consistent errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==2&dap.clim$YEAR==1993&dap.clim$MONTH>=7&dap.clim$MONTH<=9] = NA # From June 30th 1993 to October 16th 1993 there are consistent errors
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==2&dap.clim$YEAR==1993&dap.clim$MONTH==10&dap.clim$DAY<=16] = NA # From June 30th 1993 to October 16th 1993 there are consistent errors

# Site 3 errors manually identified
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1993] = NA # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1994&dap.clim$MONTH<=4] = NA # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1994&dap.clim$MONTH==6&dap.clim$DAY>=14] = NA # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1994&dap.clim$MONTH>=7&dap.clim$MONTH<=9] = NA # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1994&dap.clim$MONTH==10&dap.clim$DAY<=13] = NA # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high
dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1995&dap.clim$MONTH==12&dap.clim$DAY>=30&dap.clim$DAY<=31] = dap.clim$SOIL_F[!is.na(dap.clim$SOIL_F)&dap.clim$SITE==3&dap.clim$YEAR==1995&dap.clim$MONTH==12&dap.clim$DAY>=30&dap.clim$DAY<=31]/10 # From 1993 to October 13th of 1994 there are muliple errors and two dates in 1995 are order of magnitude too high

dap.stemp = dap.clim[complete.cases(dap.clim$SOIL_F),] # Delete rows with no soil temp data
dap.stemp$stemp = (dap.stemp$SOIL_F-32)*(5/9) # Convert to degrees celsius

names(dap.stemp)[names(dap.stemp) == 'SITE'] = 'site' # Rename columns
names(dap.stemp)[names(dap.stemp) == 'YEAR'] = 'year' # Rename columns
names(dap.stemp)[names(dap.stemp) == 'MONTH'] = 'month' # Rename columns
names(dap.stemp)[names(dap.stemp) == 'DAY'] = 'day' # Rename columns

ggplot(dap.stemp, aes(x=date, y=stemp)) +
  geom_point() +
  facet_wrap(~site)

# Use dc_sip and stemp column

dc.stemp = ste_side_wf_dc_sip.csv # Treatments and slopes at a single site will differ but probably no more than 0.1 degC which is well within measurement uncertainty
dc.stemp$site = 1
temp = str_side_wf_dc_sip.csv
temp$site = 2
temp2 = wal_side_wf_dc_sip.csv
temp2$site = 3

dc.stemp = rbind(dc.stemp, temp, temp2) # Combine
rm (temp, temp2) # Remove unwanted objects

dc.stemp$year = floor(dc.stemp$time) # Create year column
dc.stemp$month = round((dc.stemp$time - dc.stemp$year)*12,1)+1 # Create month column
dc.stemp = dc.stemp[dc.stemp$time>=1986,] # Only interested in after 1986

keep = c("site", "year", "month", "dayofyr", "stemp")
dc.stemp = dc.stemp[keep] # Limit the DC dataset

names(dc.stemp)[names(dc.stemp) == 'dayofyr'] = 'julian' # Rename column

non.lpyr = c(1:31,1:28,1:31,1:30,1:31,1:30,1:31,1:31,1:30,1:31,1:30,1:31) # List day numbers for a non-leap year
lpyr = c(1:31,1:29,1:31,1:30,1:31,1:30,1:31,1:31,1:30,1:31,1:30,1:31) # List day numbers for a leap year

y86on = c(non.lpyr,non.lpyr,non.lpyr,lpyr) # Combine to make a 4-year rotation
days = rep(y86on,100) # Make full list long enough to cover all bases for all siumulation durations (100 = 400 years!)

sitelist = c(1,2,3) # List of sites to loop over below
df2=data.frame() # Empty dataframe to put data into
for(site in sitelist) {
  df = dc.stemp[dc.stemp$site==site,]
  rows = length(df$stemp)
  df$day = days[1:rows]
  df2 = rbind(df2,df)
}

dc.stemp = df2 # Overwrite dataframe with new, correctly formatted 'days'
rm(df,df2) # Remove unwanted objects

dc.stemp$date = ISOdatetime(dc.stemp$year, dc.stemp$month, dc.stemp$day, 1,1,1, tz="UTC") # Name consistent date column

ggplot(dc.stemp, aes(x=date, y=stemp)) +
  geom_point() +
  facet_wrap(~site)

# Compare each measured and modelled

keep = c("site", "year", "month", "date", "day", "stemp")
dap.stemp = dap.stemp[keep] # Limit the DAP dataset
dc.stemp = subset(dc.stemp, select=-c(julian)) # Drop julian column

dap.stemp$source = "Measured" # Clarify the source of the value
dc.stemp$source = "Modelled" # Clarify the source of the value

stempdf = rbind(dap.stemp, dc.stemp) # Append modelled to measured
stempdf2 = merge(dap.stemp, dc.stemp, by=c("year","site","month","day","date"), all=T) # Same as cbind

# Create phases
stempdf$phase = "86-97"
stempdf2$phase = "86-97"
stempdf$phase[stempdf$year>1997] = "98-09"
stempdf2$phase[stempdf2$year>1997] = "98-09"

# Make sites factors and clear
stempdf$site[stempdf$site == 1] = "Sterling"
stempdf$site[stempdf$site == 2] = "Stratton"
stempdf$site[stempdf$site == 3] = "Walsh"

stempdf2$site[stempdf2$site == 1] = "Sterling"
stempdf2$site[stempdf2$site == 2] = "Stratton"
stempdf2$site[stempdf2$site == 3] = "Walsh"

# Average over each year
ann.stemp = ddply(stempdf, c("year","phase","site","source"), summarise,
                 N = length(stemp),
                 stemp = mean(stemp))
### NOTE - GAPS IN DATA SKEW AVERAGES SO THEY MEAN NOTHING
ggplot(ann.stemp, aes(x=year, y=stemp, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Average over each phase
phs.stemp = ddply(stempdf, c("phase","site","source"), summarise,
                 N = length(stemp),
                 stemp = mean(stemp))
### NOTE - GAPS IN DATA SKEW AVERAGES SO THEY MEAN NOTHING
ggplot(phs.stemp, aes(x=phase, y=stemp, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Average over all measurement period
tot.stemp = ddply(stempdf, c("site","source"), summarise,
                 N = length(stemp),
                 stmp = mean(stemp),
                 stemp.up = stmp + sd(stemp)/sqrt(length(stemp)),
                 stemp.dwn = stmp - sd(stemp)/sqrt(length(stemp)))

### NOTE - GAPS IN DATA SKEW AVERAGES SO THEY MEAN VERY LITTLE
p.stemp = ggplot(tot.stemp, aes(x=site, y=stmp, fill=source)) +
  geom_text(fontface = "italic", aes(y=16.75, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(fontface = "italic", aes(y=17.25, fill=source,label = paste(round(stmp, 1),"C")), position=dodge, size=3.5) +
  geom_bar(stat='identity', position='dodge') +
#  geom_errorbar(position=dodge, aes(ymax=stemp.up, ymin=stemp.dwn)) +
  ylab(expression(paste("Soil Temperature (", ~degree, "C)"))) +
  scale_y_continuous(expand=c(0,0), limits=c(0,18)) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

# Check measured vs model-used for all months
p.mm.stemp = ggplot(stempdf2, aes(x=stemp.x, y=stemp.y, colour=site)) +
  geom_point() +
  geom_abline(slope=1, intercept=0) +
  geom_smooth(method="lm", se=F, formula = y~x+0) +
  scale_y_continuous(expand=c(0,0), limits=c(0,45)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,45)) +
  ylab(expression(paste("Model-used Soil Temperature (", ~degree, "C)"))) +
  xlab(expression(paste("Measured Soil Temperature (", ~degree, "C)"))) +
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
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

# Check linearity metrics (e.g. slope) for each site. Optionally force intercept through 0

obj1 = lm(stempdf2$stemp.y~stempdf2$stemp.x+0)
obj2 = lm(stempdf2$stemp.y~(stempdf2$stemp.x*stempdf2$site)+0)
summary(obj1)
summary(obj2)

temp1 = stempdf2[stempdf2$site=="Sterling",]
temp2 = stempdf2[stempdf2$site=="Stratton",]
temp3 = stempdf2[stempdf2$site=="Walsh",]

obj_ste = lm(temp1$stemp.y~temp1$stemp.x+0)
summary(obj_ste)
obj_str = lm(temp2$stemp.y~temp2$stemp.x+0)
summary(obj_str)
obj_wal = lm(temp3$stemp.y~temp3$stemp.x+0)
summary(obj_wal)

#####################################################################
### CAN'T RELIABLY LOOK AT AIR TEMPERATURE (no easy daily output) ###
#####################################################################
# But examining trends is given below

dap.clim$T_AVG[dap.clim$T_AVG>150] = NA # Above 150 degF is clearly erroneous
dap.clim$T_AVG[dap.clim$T_AVG==0] = NA # 0 are clearly erroneous
dap.clim$T_LO[dap.clim$T_LO>150] = NA # Above 150 degF is clearly erroneous
dap.clim$T_LO[dap.clim$T_LO==0] = NA # 0 are clearly erroneous
dap.clim$T_HI[dap.clim$T_HI>150] = NA # Above 150 degF is clearly erroneous
dap.clim$T_HI[dap.clim$T_HI==0] = NA # 0 are clearly erroneous
dap.clim$T_AVG[dap.clim$T_LO>dap.clim$T_AVG] = NA # If low temp is higher than average, remove
dap.clim$T_AVG[dap.clim$T_HI<dap.clim$T_AVG] = NA # If high temp is lower than average, remove
dap.clim$T_AVG[dap.clim$T_HI==dap.clim$T_AVG] = NA # If average is the same as the high, remove
dap.clim$T_AVG[dap.clim$T_LO==dap.clim$T_AVG] = NA # If average is the same as the low, remove

# Site 1 errors manually identified

dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH<=6] = NA # From beginning of 1993 to end of 1993 there are muliple errors
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==7&dap.clim$DAY<=13] = NA # From beginning of 1993 to end of 1993 there are muliple errors
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR==1993&dap.clim$MONTH==8&dap.clim$DAY<=9] = NA # From beginning of 1993 to end of 1993 there are muliple errors
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR==1996&dap.clim$MONTH==5] = NA # All of May 1996 is 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR==1996&dap.clim$MONTH>8] = NA # Everything from 1st August 1996 is a 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==1&dap.clim$YEAR>=1997] = NA # Everything from 1st August 1996 is a 0

# Site 2 errors manually identified
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==2&dap.clim$YEAR==1993&dap.clim$MONTH<10] = NA # From January 1st 1993 to October 20th 1993 there are consistent errors
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==2&dap.clim$YEAR==1993&dap.clim$MONTH==10&dap.clim$DAY<=20] = NA # From January 1st 1993 to October 20th 1993 there are consistent errors
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==2&dap.clim$YEAR==1996&dap.clim$MONTH>=5&dap.clim$MONTH<=6] = NA # All of May and June 1996 is 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==2&dap.clim$YEAR==1996&dap.clim$MONTH>8] = NA # Everything from 1st August 1996 is a 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==2&dap.clim$YEAR>=1997] = NA # Everything from 1st August 1996 is a 0

# Site 3 errors manually identified
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==3&dap.clim$YEAR==1996&dap.clim$MONTH>=5&dap.clim$MONTH<=6] = NA # All of May and June 1996 is 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==3&dap.clim$YEAR==1996&dap.clim$MONTH>8] = NA # Everything from 1st August 1996 is a 0
dap.clim$T_AVG[!is.na(dap.clim$T_AVG)&dap.clim$SITE==3&dap.clim$YEAR>=1997] = NA # Everything from 1st August 1996 is a 0

daily.dap.tave = dap.clim[complete.cases(dap.clim$T_AVG),] # Delete rows with no soil temp data
daily.dap.tave$atemp = (daily.dap.tave$T_AVG-32)*(5/9) # Convert to degrees celsius

names(daily.dap.tave)[names(daily.dap.tave) == 'SITE'] = 'site' # Rename columns
names(daily.dap.tave)[names(daily.dap.tave) == 'YEAR'] = 'year' # Rename columns
names(daily.dap.tave)[names(daily.dap.tave) == 'MONTH'] = 'month' # Rename columns
names(daily.dap.tave)[names(daily.dap.tave) == 'DAY'] = 'day' # Rename columns

ggplot(daily.dap.tave, aes(x=date, y=atemp)) +
  geom_point() +
  facet_wrap(~site)

# To compare to monthly values we need to average the average - not ideal!

dap.tave = ddply(daily.dap.tave, c("site","year","month"), summarise,
                 tave = mean(atemp),
#                 tave.se = sd(atemp)/sqrt(length(atemp)),
#                 tave.mx = tave + tave.se,
#                 tave.mn = tave - tave.se,
                 tave.n = length(atemp))

dap.tave = dap.tave[dap.tave$tave.n>26,] # Only include months where there was at least 26 days of data
dap.tave = dap.tave[,!names(dap.tave) %in% "tave.n"]

dap.tave$date = ISOdatetime(dap.tave$year, dap.tave$month, 14,1,1,1, tz="UTC") # Include a date column using year and month

# Use .lis file and tave column - note that this is monthly!

dc.tave = ste_side_wf.lis # All treatments and slopes at a single site should be the same so any will work
dc.tave$site = 1
temp = str_side_wf.lis
temp$site = 2
temp2 = wal_side_wf.lis
temp2$site = 3

dc.tave = rbind(dc.tave, temp, temp2) # Combine
rm (temp, temp2) # Remove unwanted objects

dc.tave$year = floor(dc.tave$time) # Create year column
dc.tave$month = round((dc.tave$time - dc.tave$year)*12,1) # Create month column
dc.tave$month[dc.tave$month == 0] = 12 # Month "0" is actually december of the previous year
dc.tave$year[dc.tave$month == 12] = dc.tave$year[dc.tave$month == 12]-1  # Month "0" is actually december of the previous year
dc.tave = dc.tave[dc.tave$year>=1986&dc.tave$year<2010,] # Only interested in after 1986 and before 2010

keep = c("site", "year", "month", "tave")
dc.tave = dc.tave[keep] # Limit the DC dataset

dc.tave$date = ISOdatetime(dc.tave$year, dc.tave$month, 14,1,1,1, tz="UTC") # Name consistent date column

ggplot(dc.tave, aes(x=date, y=tave)) +
  geom_point() +
  facet_wrap(~site)

# Compare each site/month/year individually

dap.tave$source = "Measured" # Clarify the source of the value
dc.tave$source = "Modelled" # Clarify the source of the value

tave = rbind(dap.tave, dc.tave) # Append modelled to measured
tave.bnd = merge(dap.tave, dc.tave, by=c("year","site","month","date"), all=T) # Same as cbind

tave2 = tave.bnd[complete.cases(tave.bnd$tave.x),]

# Create phases
tave$phase = "86-97"
tave2$phase = "86-97"
tave$phase[tave$year>1997] = "98-09"
tave2$phase[tave2$year>1997] = "98-09"

# Make sites factors and clear
tave$site[tave$site == 1] = "Sterling"
tave$site[tave$site == 2] = "Stratton"
tave$site[tave$site == 3] = "Walsh"

tave2$site[tave2$site == 1] = "Sterling"
tave2$site[tave2$site == 2] = "Stratton"
tave2$site[tave2$site == 3] = "Walsh"

# Average over each year
ann.tave = ddply(tave, c("year","phase","site","source"), summarise,
                 N = length(tave),
                 atemp = mean(tave))

p.ann.tave = ggplot(ann.tave, aes(x=year, y=atemp, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Average over each phase
phs.tave = ddply(tave, c("phase","site","source"), summarise,
                 N = length(tave),
                 atemp = mean(tave))

p.phs.tave = ggplot(phs.tave, aes(x=phase, y=atemp, fill=source)) +
  geom_bar(stat='identity', position='dodge') +
  facet_wrap(~site)

# Average over all measurement period
tot.tave = ddply(tave, c("site","source"), summarise,
                 N = length(tave),
                 atemp = mean(tave))

p.tave = ggplot(tot.tave, aes(x=site, y=atemp, fill=source)) +
  geom_text(fontface = "italic", aes(y=14, fill=source,label = paste("n=", round(N, 0))), position=dodge, size=2.5) +
  geom_text(fontface = "italic", aes(y=15, fill=source,label = paste(round(atemp, 1),"C")), position=dodge, size=3.5) +
  geom_bar(stat='identity', position='dodge') +
  scale_y_continuous(expand=c(0,0), limits=c(0,17)) +
  ylab(expression(paste("Average Air Temperature (", ~degree, "C)"))) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=12),
        strip.text.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12, colour = 'black'),
        panel.background = element_blank(),
        axis.line = element_line(colour='black'),
        panel.grid = element_blank())

# Check measured vs model-used for all months
p.mm.tave = ggplot(tave2, aes(x=tave.x, y=tave.y, colour=site)) +
  geom_point() +
  geom_abline(slope=1, intercept=0) +
  geom_smooth(method="lm", se=F, formula = y~x+0) +
  scale_y_continuous(expand=c(0,0), limits=c(0,30)) +
  scale_x_continuous(expand=c(0,0), limits=c(0,30)) +
  ylab(expression(paste("Model-used Air Temperature (", ~degree, "C)"))) +
  xlab(expression(paste("Measured Air Temperature (", ~degree, "C)"))) +
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
  scale_colour_manual("Site",
                      values = c("coral2","cornflowerblue", "darkgreen"),
                      labels = c("Sterling", "Stratton", "Walsh")) +
  scale_linetype(guide=F) +
  scale_shape(guide=F) +
  scale_size(guide=F)

# Check linearity metrics (e.g. slope) for each site. Optionally force intercept through 0

obj1 = lm(tave2$tave.y~tave2$tave.x+0)
obj2 = lm(tave2$tave.y~(tave2$tave.x*tave2$site)+0)
summary(obj1)
summary(obj2)

temp1 = tave2[tave2$site=="Sterling",]
temp2 = tave2[tave2$site=="Stratton",]
temp3 = tave2[tave2$site=="Walsh",]

obj_ste = lm(temp1$tave.y~temp1$tave.x+0)
summary(obj_ste)
obj_str = lm(temp2$tave.y~temp2$tave.x+0)
summary(obj_str)
obj_wal = lm(temp3$tave.y~temp3$tave.x+0)
summary(obj_wal)

### SAVE FIGURES

ggsave(p.ann.prec, file=file.path(figdir,"Precip_annually.pdf"), width=250, height=175, units="mm")
ggsave(p.phs.prec, file=file.path(figdir,"Precip_by_phase.pdf"), width=250, height=175, units="mm")
#ggsave(p.ann.tave, file=file.path(figdir,"Air_temp_annually.pdf"), width=250, height=175, units="mm")
#ggsave(p.phs.tave, file=file.path(figdir,"Air_temp_by_phase.pdf"), width=250, height=175, units="mm")
ggsave(p.prec, file=file.path(figdir,"Precip_all.pdf"), width=250, height=175, units="mm")
ggsave(p.stemp, file=file.path(figdir,"Soil_temp_all.pdf"), width=250, height=175, units="mm")
ggsave(p.tave, file=file.path(figdir,"Air_temp_all.pdf"), width=250, height=175, units="mm")
ggsave(p.mm.prec, file=file.path(figdir,"Precip_1to1.pdf"), width=300, height=250, units="mm")
ggsave(p.mm.stemp, file=file.path(figdir,"Soil_temp_1to1.pdf"), width=300, height=250, units="mm")
ggsave(p.mm.tave, file=file.path(figdir,"Air_temp_1to1.pdf"), width=300, height=250, units="mm")

# NO LONGER NEED DAYCENT FILES - remove these objects
rm(list = grep("*_sip.csv", ls(), value = TRUE, invert = FALSE))
rm(list = grep("*_harvest.csv", ls(), value = TRUE, invert = FALSE))
rm(list = grep("*_soiln.out", ls(), value = TRUE, invert = FALSE))
rm(list = grep("*_summary.out", ls(), value = TRUE, invert = FALSE))
rm(list = grep("*_vswc.out", ls(), value = TRUE, invert = FALSE))
rm(list = grep("*.lis", ls(), value = TRUE, invert = FALSE))
