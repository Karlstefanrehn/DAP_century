# --------------------------------------------------------------------------------------#
### CREATES OBJECTS THAT CAN BE USED WITH MEASURED VALUES TO COMPARE 1986-2009 YIELDS ###
# --------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

source(file.path(fundir, "RFunctions.R")) # Functions need reloading
if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations again

#### IMPORT DATA

meas.dap.yld = read.csv(file=file.path(datadir, "DAP_yields.csv"),  # Load in data
                  sep=",", header=T)

# World record corn yield is 33,393 kg/ha so no yields at these sites can be above that!

meas.dap.yld$st_yld[meas.dap.yld$st_yld>33393] = NA
meas.dap.yld$gr_yld[meas.dap.yld$gr_yld>33393] = NA

plot(meas.dap.yld$st_yld ~ meas.dap.yld$gr_yld)
levels(meas.dap.yld$crop) # Some crops unidentified (therefore removed)

meas.dap.yld = meas.dap.yld[meas.dap.yld$crop != "#N/A",]

###
### IDENTIFIED ISSUES:
meas.dap.yld$st_yld[meas.dap.yld$st_yld<0] = NA
meas.dap.yld$gr_yld[meas.dap.yld$gr_yld<0] = NA
### - Remove all negative yields
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "C"] > 5649)
### - 9% of measured corn grain yields are higher than the highest reported NASS #county-level non-irrigated corn grain yields [average 2911 kg/ha (521-5649 kg/ha) between 1985 and 2015 across Colorado]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "W"] > 3497)
### - 6% of measured wheat grain yields are higher than the highest reported NASS #county-level non-irrigated winter-wheat grain yields [average 1826 kg/ha (437-3497 kg/ha) between 1985 and 2009 across Colorado]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "M"] > 1961)
### - 21% of measured millet grain yields are higher than the highest reported NASS state-level millet yields [average 1482 kg/ha (588-1961 kg/ha) between 1999 and 2015 across Colorado]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "Sg"] > 3923)
### - 12% of measured sorghum grain yields are higher than the highest reported NASS #county-level non-irrigated sorghum grain yields [average 1855 kg/ha (376-3923 kg/ha) between 1985 and 2009 across Colorado]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "Sy"] > 3531)
### - <1% of measured soybean grain yields are higher than the highest reported NASS annual national soybean grain yields [average 2624 kg/ha (1816-3531 kg/ha) between 1985 and 2016 across all states - NO COLORADO SPECIFIC DATA]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "Sn"] > 2374)
### - NO MEASURED YIELDS AT PRESENT! of measured sunflower grain yields are higher than the highest reported NASS #county-level oil-type sunflower yields [average 1192 kg/ha (140-2374 kg/ha) between 1991 and 2015 across Colorado]
##count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "P"] > 1994)
### - NO MEASURED YIELDS AT PRESENT!11.5% of measured pea grain yields are higher than the highest reported NASS annual national Austrian Winter Pea yields [average 1370 kg/ha (1236-1994 kg/ha) between 1986 and 2016 across all states - NO COLORADO SPECIFIC DATA]

##count(meas.dap.yld$gr_yld[meas.dap.yld$st_yld==0] > 0)
### - Of the 678 strips with stover yields reported to be 0, 376 reported grain yields above 0
### It is unclear whether/when 0 measurements are because there is no data or when they were in fact 0s. To be safe, remove all

meas.dap.yld$gr_yld[meas.dap.yld$gr_yld == 0] = NA
meas.dap.yld$st_yld[meas.dap.yld$st_yld == 0] = NA

# ADDITIONALLY - There are a number of points where grain yields were measured to be high and stover to be very low
# (mainly Sorghum and Soybean - see id# 4447 or #4337) - below are harvest indices (i.e. Grain:Stover ratio)
meas.dap.yld$gr_yld[meas.dap.yld$id == 4447]/meas.dap.yld$st_yld[meas.dap.yld$id == 4447]
meas.dap.yld$gr_yld[meas.dap.yld$id == 4337]/meas.dap.yld$st_yld[meas.dap.yld$id == 4337]

meas.dap.yld$hi = meas.dap.yld$gr_yld/meas.dap.yld$st_yld # Create harvest index column

himax = 2     # Maximum allowable harvest index
himin = 0.05  # Minimum allowable harvest index
#count(meas.dap.yld$hi[meas.dap.yld$hi>himax]) # 350+ absolute results above a harvest index of 2
#count(meas.dap.yld$hi[meas.dap.yld$hi<himin]) # 40+ absolute results below a harvest index of 0.05

# Remove those outside harvest index thresholds
meas.dap.yld$gr_yld[meas.dap.yld$hi > himax] = NA
meas.dap.yld$gr_yld[meas.dap.yld$hi < himin] = NA
meas.dap.yld$st_yld[meas.dap.yld$hi > himax] = NA
meas.dap.yld$st_yld[meas.dap.yld$hi < himin] = NA
meas.dap.yld$hi[meas.dap.yld$hi > himax] = NA
meas.dap.yld$hi[meas.dap.yld$hi < himin] = NA

### Remove all grain yields above 2x the highest values! Corn = 11298 . Wheat = 6994 . Millet = 3922 . Sorghum = 7846 . Soybean = 7062
# First section of lines just shows the values (many may be error 99999 indicators)
subset(meas.dap.yld, crop == "C" & gr_yld > 11298)$gr_yld
subset(meas.dap.yld, crop == "W" & gr_yld > 6994)$gr_yld
subset(meas.dap.yld, crop == "M" & gr_yld > 3922)$gr_yld
subset(meas.dap.yld, crop == "Sg" & gr_yld > 7846)$gr_yld
subset(meas.dap.yld, crop == "Sy" & gr_yld > 7062)$gr_yld

crn.yld = meas.dap.yld[meas.dap.yld$crop == "C",]
crn.yld$gr_yld[crn.yld$gr_yld > 11298] = NA
wht.yld = meas.dap.yld[meas.dap.yld$crop == "W",]
wht.yld$gr_yld[wht.yld$gr_yld > 6994] = NA
mil.yld = meas.dap.yld[meas.dap.yld$crop == "M",]
mil.yld$gr_yld[mil.yld$gr_yld > 3922] = NA
srg.yld = meas.dap.yld[meas.dap.yld$crop == "Sg",]
srg.yld$gr_yld[srg.yld$gr_yld > 7846] = NA
syb.yld = meas.dap.yld[meas.dap.yld$crop == "Sy",]
syb.yld$gr_yld[syb.yld$gr_yld > 7062] = NA

### FINAL CHECK FOR GRAIN YIELD OUTLIERS
############
### CORN ###
############
### Use 95% confidence (2x standard deviation) to check for outliers in corn grain yields
subset(crn.yld, gr_yld > (mean(crn.yld$gr_yld, na.rm=T))+(2*(sd(crn.yld$gr_yld, na.rm=T))))

crn.yld$gr_yld[crn.yld$gr_yld == 10000] = NA # Yield suspiciously high and round (10000 exactly) and N and NP are the same

### - All 2003 corn yields (18 strips of N and 18 strips of NP) at Stratton have grain yield of exactly 8781.696
#count(meas.dap.yld$gr_yld[meas.dap.yld$crop == "C"] == 8781.696)
which(meas.dap.yld$gr_yld[meas.dap.yld$crop == "C"] == 8781.696)

### - Unrealiable Corn grain data for Stratton 2003 therefore removed:
crn.yld$gr_yld[crn.yld$site==2&crn.yld$year==2003] = NA
crn.yld$st_yld[crn.yld$site==2&crn.yld$year==2003] = NA

# Use 95% confidence again to recheck for outliers
subset(crn.yld, gr_yld > (mean(crn.yld$gr_yld, na.rm=T))+(2*(sd(crn.yld$gr_yld, na.rm=T))))
# No clear reason to remove any others

#############
### WHEAT ###
#############

subset(wht.yld, gr_yld > (mean(wht.yld$gr_yld, na.rm=T))+(2*(sd(wht.yld$gr_yld, na.rm=T))))
### - 1999 Wheat yields all appear to have harvest indices nearing 2 - seems unlikely but no clear reason to remove

##############
### MILLET ###
##############

subset(mil.yld, gr_yld > (mean(mil.yld$gr_yld, na.rm=T))+(2*(sd(mil.yld$gr_yld, na.rm=T))))
### No clear reason to remove

###############
### SORGHUM ###
###############

subset(srg.yld, gr_yld > (mean(srg.yld$gr_yld, na.rm=T))+(2*(sd(srg.yld$gr_yld, na.rm=T))))
### Two measurements in 2004 appear to have very high harvest indeces but no clear reason to remove

###############
### SOYBEAN ###
###############

subset(syb.yld, gr_yld > (mean(syb.yld$gr_yld, na.rm=T))+(2*(sd(syb.yld$gr_yld, na.rm=T))))
### No clear reason to remove

# Check distrubution with graphs
plot(crn.yld$st_yld ~ crn.yld$gr_yld) 
plot(wht.yld$st_yld ~ wht.yld$gr_yld)
plot(mil.yld$st_yld ~ mil.yld$gr_yld)
plot(srg.yld$st_yld ~ srg.yld$gr_yld)
plot(syb.yld$st_yld ~ syb.yld$gr_yld)
# All seem reasonable

##########################################################################################################
### STOVER YIELDS ALSO AN ISSUE - useful check to examine how far from typical ratio 
##########################################################################################################
# (Corn and Sorghum yld:grn is usually 1:1)
# (Wheat yld:grn is usually between 5:3 and 3:2)
# (Millet yld:grn is usually 3:2 - change in genotype may explain dramatic increase in harvest index (1:1) after 1997)
# (Soybean yld:grn is usually between 5:3 and 3:2)
# (Sunflower yld:grn is usually 5:3)
# (Austrian Winter Pea yld:grn is usually around 7:3)

### As with grain yield measurements (assuming a stover:grain ratios as above) remove any measurements the equivalent to double the maximum grain yields recorded by NASS:

subset(crn.yld, st_yld > 11298)
subset(wht.yld, st_yld > (6994/3*5))
subset(mil.yld, st_yld > (3922/2*3))
subset(srg.yld, st_yld > 7846)
subset(syb.yld, st_yld > 7062)

crn.yld$st_yld[crn.yld$st_yld > 11298] = NA
wht.yld$st_yld[wht.yld$st_yld > (6994/3*5)] = NA
mil.yld$st_yld[mil.yld$st_yld > (3922/2*3)] = NA
srg.yld$st_yld[srg.yld$st_yld > 7846] = NA

# As with grains, identify rows where stover yield is in top 5% (i.e. mean + 2*sd)
subset(crn.yld, st_yld > (mean(crn.yld$st_yld, na.rm=T))+(2*(sd(crn.yld$st_yld, na.rm=T)))) # CORN
crn.yld$st_yld[crn.yld$st_yld==10083] = NA # N and NP treatments are the same and exactly 10083
### Many 'high' corn stover yields but no clear scientific reason to remove

subset(wht.yld, st_yld > (mean(wht.yld$st_yld, na.rm=T))+(2*(sd(wht.yld$st_yld, na.rm=T)))) # WHEAT
# ID# 6083 has a suspicious perfect 0.33333 for harvest index (to 7 decimal places!)
# Aslo note that N and NP yields are identical for 2 stratton toe strips (17 and 19) in 1986
### Many 'high' wheat stover yields but no clear scientific reason to remove

subset(mil.yld, st_yld > (mean(mil.yld$st_yld, na.rm=T))+(2*(sd(mil.yld$st_yld, na.rm=T)))) # MILLET
### A few 'high' millet stover yields but no clear scientific reason to remove
# NOTE - 1990 Walsh millet yields are identical for both strips (stover and grain) across all 3 slopes 
#      - these should have been removed already with the harvest index thresholds

subset(srg.yld, st_yld > (mean(srg.yld$st_yld, na.rm=T))+(2*(sd(srg.yld$st_yld, na.rm=T)))) # SORGHUM
### A few 'high' sorghum stover yields but no clear scientific reason to remove

subset(syb.yld, st_yld > (mean(syb.yld$st_yld, na.rm=T))+(2*(sd(syb.yld$st_yld, na.rm=T)))) # SOYBEAN
### A few 'high' soybean stover yields but no clear scientific reason to remove

####################################################
### FINAL CHECK OF ALL GRAIN AND STOVER OUTLIERS ###
####################################################

### PLOTS TO CHECK OUTLIERS VISUALLY
# Check stover:grain relationships using simple graphs
plot(crn.yld$gr_yld ~ crn.yld$st_yld)
abline(0,1) # CORN
#mean(crn.yld$st_yld, na.rm=T)/mean(crn.yld$gr_yld, na.rm=T) # Ratio should be 1 but this averages ALL values (not just those where BOTH stover and grain yields are reported)
mean(crn.yld$hi, na.rm=T) # Harvest index should be 1 - This only averages where BOTH stover and grain are reported

plot(wht.yld$gr_yld ~ wht.yld$st_yld)
abline(0,0.6) # WHEAT
#mean(wht.yld$st_yld, na.rm=T)/mean(wht.yld$gr_yld, na.rm=T) # Ratio should be 1.67
mean(wht.yld$hi, na.rm = T) # HI should be 0.6

plot(mil.yld$st_yld ~ mil.yld$gr_yld)
abline(0,1.5) # MILLET
#mean(mil.yld$st_yld, na.rm=T)/mean(mil.yld$gr_yld, na.rm=T) # Ratio should be 1.5
mean(mil.yld$hi, na.rm = T) # HI should be 0.75

plot(srg.yld$st_yld ~ srg.yld$gr_yld)
abline(0,1) # SORGHUM
#mean(srg.yld$st_yld, na.rm=T)/mean(srg.yld$gr_yld, na.rm=T) # Ratio should be 1
mean(srg.yld$hi, na.rm = T) # HI should be 1

plot(syb.yld$st_yld ~ syb.yld$gr_yld)
abline(0,1.67) # SOYBEAN
#mean(syb.yld$st_yld, na.rm=T)/mean(syb.yld$gr_yld, na.rm=T) # Ratio should be 1.67 for irrigated. Limited data for non-irrigated
mean(syb.yld$hi, na.rm = T) # HI should be 0.6

## crn.yld$st_yld[which(is.na(crn.yld$gr_yld))] = NA - if it is decided to delete all stover yields when grain yields are erroneous

### When no clear outliers remaining recombine 'key' crops into one dataframe if desired
meas.raw.ylds = rbind(crn.yld, wht.yld, mil.yld, srg.yld, syb.yld)

### NOTICED THAT SOME TREATMENT AND STRIPS DO NOT MATCH UP KNOWN VALUES
# Use lookup tables to check:
# Haven't worked out an R way of doing this so those identified (below) have been removed manually

#sit = c(1:3)
#strp = c(-4:26)
#dummy = expand.grid(strip=strp, site=sit)
#treatments = c(15,15,13,12,0,1,7,2,5,8,4,10,11,3,6,9,11,4,5,6,7,1,10,9,8,2,3,0,12,13,15,
#               15,15,13,12,0,10,9,1,2,4,5,8,3,6,11,7,4,11,2,3,7,10,8,1,9,6,5,0,12,13,15,
#               15,15,15,0,13,3,5,10,8,11,6,7,4,9,1,12,2,1,9,11,7,2,5,6,8,3,12,4,10,13,0)
#reps = c(3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
#         3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
#         3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
#dummy=cbind(dummy, treatments, reps)
#dummy$ssid = paste(dummy$site, dummy$strip)
#dummy$stid = paste(dummy$site, dummy$treatments, dummy$reps)

# Manually removed in Excel are:
## Walsh 2000 and 2001, stripss 9 and 14 state treatment 8, it has been changed to treatment 9
## Stratton 1999, strip 1 states treatment 9, it has been changed to treatment 10
## Sterling 2009, strip 20 states treatment 5, it has been changed to treatment 8
## Sterling 2001, strip -4 states treatment 99, it has been changed to treatment 12
## Stratton 1995, strip 23 states treatment 7, it has been changed to treatment 0

# Unsure how to change Walsh 2007, strips 3 and 17 but looks like they could just be the wrong way round
# Strip 3 changed to strip 17 (so to correspond with treatment value of 2)
# Strip 17 changed to strip 3 (which means treatment must also be changed to 10)
## Have changed these as above but not sure whether to trust treatment or strip entries (or neither?!)

# NOTE - This may not be a complete list of all errors - treatment 13 is often different to expectations

############
### PREP FOR GRAPHING
############

meas.raw.ylds = meas.raw.ylds[meas.raw.ylds$fert == "NP",]
#dap.wheat = dap.all[complete.cases(dap.all$w_yld),]

meas.raw.ylds$slope[meas.raw.ylds$slope == 1] = "Summit"
meas.raw.ylds$slope[meas.raw.ylds$slope == 2] = "Sideslope"
meas.raw.ylds$slope[meas.raw.ylds$slope == 3] = "Toeslope"
meas.raw.ylds$slope = factor(meas.raw.ylds$slope, levels = c("Summit", "Sideslope", "Toeslope"))

meas.raw.ylds$site[meas.raw.ylds$site == 1] = "Sterling"
meas.raw.ylds$site[meas.raw.ylds$site == 2] = "Stratton"
meas.raw.ylds$site[meas.raw.ylds$site == 3] = "Walsh"

meas.raw.ylds$crop = as.character(meas.raw.ylds$crop)
meas.raw.ylds$crop[meas.raw.ylds$crop == "W"] = "Wheat"
meas.raw.ylds$crop[meas.raw.ylds$crop == "C"] = "Corn"
meas.raw.ylds$crop[meas.raw.ylds$crop == "M"] = "Millet"
meas.raw.ylds$crop[meas.raw.ylds$crop == "Sg"] = "Sorghum"
meas.raw.ylds$crop[meas.raw.ylds$crop == "Sy"] = "Soybean"
#meas.raw.ylds$crop[meas.raw.ylds$crop == "Sn"] = "Sunflower"
#meas.raw.ylds$crop[meas.raw.ylds$crop == "P"] = "Pea"

meas.raw.ylds$rot_phs = as.character(meas.raw.ylds$rot_phs)
meas.raw.ylds$rot_phs[meas.raw.ylds$rot_phs == 1] = "1986-1997"
meas.raw.ylds$rot_phs[meas.raw.ylds$rot_phs == 2] = "1998-2009"

meas.raw.ylds$treatno = meas.raw.ylds$treat

meas.raw.ylds$treat[meas.raw.ylds$treat == 1 & meas.raw.ylds$rot_phs == "1986-1997"] = "WF"
meas.raw.ylds$treat[meas.raw.ylds$treat == 2 & meas.raw.ylds$rot_phs == "1986-1997"] = "FW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 1 & meas.raw.ylds$rot_phs == "1998-2009"] = "WCM"
meas.raw.ylds$treat[meas.raw.ylds$treat == 2 & meas.raw.ylds$rot_phs == "1998-2009"] = "CMW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 3] = "WCF"
meas.raw.ylds$treat[meas.raw.ylds$treat == 4] = "CFW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 5] = "FWC"
meas.raw.ylds$treat[meas.raw.ylds$treat == 6 & meas.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
meas.raw.ylds$treat[meas.raw.ylds$treat == 7 & meas.raw.ylds$rot_phs == "1986-1997"] = "CMFW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 8 & meas.raw.ylds$rot_phs == "1986-1997"] = "MFWC"
meas.raw.ylds$treat[meas.raw.ylds$treat == 9 & meas.raw.ylds$rot_phs == "1986-1997"] = "FWCM"
meas.raw.ylds$treat[meas.raw.ylds$treat == 6 & meas.raw.ylds$rot_phs == "1998-2009"] = "WCMW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 7 & meas.raw.ylds$rot_phs == "1998-2009"] = "CMWW"
meas.raw.ylds$treat[meas.raw.ylds$treat == 8 & meas.raw.ylds$rot_phs == "1998-2009"] = "MWWC"
meas.raw.ylds$treat[meas.raw.ylds$treat == 9 & meas.raw.ylds$rot_phs == "1998-2009"] = "WWCM"
meas.raw.ylds$treat[meas.raw.ylds$treat == 10] = "OPP"
meas.raw.ylds$treat[meas.raw.ylds$treat == 11] = "Grass"
meas.raw.ylds$treat = factor(meas.raw.ylds$treat, levels = c("WF","FW","WCM","CMW","WCF","CFW","FWC",
                                                             "WCMW","CMWW","MWWC","WWCM","WCMF","CMFW",
                                                             "MFWC","FWCM","OPP","Grass"))
meas.raw.ylds = meas.raw.ylds[complete.cases(meas.raw.ylds$treat),] # Remove treatments that aren't 1-11

meas.raw.ylds$trt[meas.raw.ylds$treat == "WF"] = "WF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "FW"] = "WF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "WCM"] = "WCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "CMW"] = "WCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "WCF"] = "WCF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "CFW"] = "WCF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "FWC"] = "WCF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "WCMF"] = "WCMF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "CMFW"] = "WCMF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "MFWC"] = "WCMF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "FWCM"] = "WCMF"
meas.raw.ylds$trt[meas.raw.ylds$treat == "WWCM"] = "WWCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "WCMW"] = "WWCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "CMWW"] = "WWCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "MWWC"] = "WWCM"
meas.raw.ylds$trt[meas.raw.ylds$treat == "OPP"] = "OPP"
meas.raw.ylds$trt[meas.raw.ylds$treat == "Grass"] = "Grass"
meas.raw.ylds$trt = factor(meas.raw.ylds$trt, levels = c("WF","WCM","WCF","WCMF","WWCM","OPP","Grass"))

###### CORRECT YIELD OBJECTS INTO COMPARIBLE AND CONSISTANT UNITS

# Constant to correct for 'exact' carbon and moisture contents
crn.c.st = 0.45   # Corn stover carbon fraction (i.e. 0-1)
crn.moist.st = 0  # Corn stover mositure % (i.e. 0-100)
crn.c.gr = 0.45   # Corn grain carbon fraction (i.e. 0-1)
crn.moist.gr = 0  # Corn grain moisture % (i.e. 0-100)
wht.c.st = 0.45   # Wheat stover...
wht.moist.st = 0
wht.c.gr = 0.45   # Wheat grain...
wht.moist.gr = 0
mil.c.st = 0.45   # Millet...
mil.moist.st = 0
mil.c.gr = 0.45
mil.moist.gr = 0
srg.c.st = 0.45  # Sorghum...
srg.moist.st = 0
srg.c.gr = 0.45
srg.moist.gr = 0
syb.c.st = 0.45  # Soybean...
syb.moist.st = 0
syb.c.gr = 0.45
syb.moist.gr = 0

kgha2gm2 = 1000/10000 # Conversion from kg/ha to g/m2

# Convert from kg biomass/ha to dry gC/m2

meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Corn"] = (meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Corn"]*crn.c.gr*(100-crn.moist.gr)/100)*kgha2gm2
meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Wheat"] = (meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Wheat"]*wht.c.gr*(100-wht.moist.gr)/100)*kgha2gm2
meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Millet"] = (meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Millet"]*mil.c.gr*(100-mil.moist.gr)/100)*kgha2gm2
meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Sorghum"] = (meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Sorghum"]*srg.c.gr*(100-srg.moist.gr)/100)*kgha2gm2
meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Soybean"] = (meas.raw.ylds$gr_yld[meas.raw.ylds$crop == "Soybean"]*syb.c.gr*(100-syb.moist.gr)/100)*kgha2gm2
meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Corn"] = (meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Corn"]*crn.c.st*(100-crn.moist.st)/100)*kgha2gm2
meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Wheat"] = (meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Wheat"]*wht.c.st*(100-wht.moist.st)/100)*kgha2gm2
meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Millet"] = (meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Millet"]*mil.c.st*(100-mil.moist.st)/100)*kgha2gm2
meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Sorghum"] = (meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Sorghum"]*srg.c.st*(100-srg.moist.st)/100)*kgha2gm2
meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Soybean"] = (meas.raw.ylds$st_yld[meas.raw.ylds$crop == "Soybean"]*syb.c.st*(100-syb.moist.st)/100)*kgha2gm2

meas.raw.ylds$source = "Measured" # This is used for comparison with modelled yields when graphing/sub-setting

### CREATING AVERAGE OBJECTS

meas.ylds = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("year", "rot_phs", "site", "crop", "source"), summarise,
                      N=length(st_yld),
                      mean=mean(st_yld),
                      se=sd(st_yld)/sqrt(length(st_yld)),
                      ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                      ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                      type="Stover"),  
                ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("year", "rot_phs", "site", "crop", "source"), summarise,
                      N=length(gr_yld),                                             
                      mean=mean(gr_yld),
                      se=sd(gr_yld)/sqrt(length(gr_yld)),
                      ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                      ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                      type="Grain"))

meas.treat = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("year", "rot_phs", "site", "crop", "treat", "source"), summarise,
                      N=length(st_yld),
                      mean=mean(st_yld),
                      se=sd(st_yld)/sqrt(length(st_yld)),
                      ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                      ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                      type="Stover"),  
                ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("year", "rot_phs", "site", "crop", "treat", "source"), summarise,
                      N=length(gr_yld),                                             
                      mean=mean(gr_yld),
                      se=sd(gr_yld)/sqrt(length(gr_yld)),
                      ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                      ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                      type="Grain"))

meas.trt = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("year", "rot_phs", "site", "crop", "trt", "source"), summarise,
                       N=length(st_yld),
                       mean=mean(st_yld),
                       se=sd(st_yld)/sqrt(length(st_yld)),
                       ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                       ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                       type="Stover"),  
                 ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("year", "rot_phs", "site", "crop", "trt", "source"), summarise,
                       N=length(gr_yld),                                             
                       mean=mean(gr_yld),
                       se=sd(gr_yld)/sqrt(length(gr_yld)),
                       ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                       ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                       type="Grain"))

meas.slp.treat.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "crop", "treat", "slope", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "crop", "treat", "slope", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.slp.trt.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "crop", "trt", "slope", "source"), summarise,
                               N=length(st_yld),
                               mean=mean(st_yld),
                               se=sd(st_yld)/sqrt(length(st_yld)),
                               ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                               ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                               type="Stover"),  
                         ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "crop", "trt", "slope", "source"), summarise,
                               N=length(gr_yld),                                             
                               mean=mean(gr_yld),
                               se=sd(gr_yld)/sqrt(length(gr_yld)),
                               ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                               ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                               type="Grain"))

meas.slp.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "crop", "slope", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "crop", "slope", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.treat.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "crop", "treat", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "crop", "treat", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.trt.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "crop", "trt", "source"), summarise,
                           N=length(st_yld),
                           mean=mean(st_yld),
                           se=sd(st_yld)/sqrt(length(st_yld)),
                           ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                           ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                           type="Stover"),  
                     ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "crop", "trt", "source"), summarise,
                           N=length(gr_yld),                                             
                           mean=mean(gr_yld),
                           se=sd(gr_yld)/sqrt(length(gr_yld)),
                           ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                           ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                           type="Grain"))

meas.treat.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "crop", "treat", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "crop", "treat", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.trt.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "crop", "trt", "source"), summarise,
                           N=length(st_yld),
                           mean=mean(st_yld),
                           se=sd(st_yld)/sqrt(length(st_yld)),
                           ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                           ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                           type="Stover"),  
                     ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "crop", "trt", "source"), summarise,
                           N=length(gr_yld),                                             
                           mean=mean(gr_yld),
                           se=sd(gr_yld)/sqrt(length(gr_yld)),
                           ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                           ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                           type="Grain"))

meas.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "site", "crop", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "site", "crop", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "crop", "source"), summarise,
                                  N=length(st_yld),
                                  mean=mean(st_yld),
                                  se=sd(st_yld)/sqrt(length(st_yld)),
                                  ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                                  ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                                  type="Stover"),  
                            ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "crop", "source"), summarise,
                                  N=length(gr_yld),                                             
                                  mean=mean(gr_yld),
                                  se=sd(gr_yld)/sqrt(length(gr_yld)),
                                  ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                                  ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                                  type="Grain"))

meas.crp.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "source"), summarise,
                                  N=length(st_yld),
                                  mean=mean(st_yld),
                                  se=sd(st_yld)/sqrt(length(st_yld)),
                                  ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                                  ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                                  type="Stover"),  
                            ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "source"), summarise,
                                  N=length(gr_yld),                                             
                                  mean=mean(gr_yld),
                                  se=sd(gr_yld)/sqrt(length(gr_yld)),
                                  ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                                  ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                                  type="Grain"))

meas.crp.treat.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "treat", "source"), summarise,
                                  N=length(st_yld),
                                  mean=mean(st_yld),
                                  se=sd(st_yld)/sqrt(length(st_yld)),
                                  ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                                  ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                                  type="Stover"),  
                            ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "treat", "source"), summarise,
                                  N=length(gr_yld),                                             
                                  mean=mean(gr_yld),
                                  se=sd(gr_yld)/sqrt(length(gr_yld)),
                                  ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                                  ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                                  type="Grain"))

meas.crp.trt.all = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "trt", "source"), summarise,
                               N=length(st_yld),
                               mean=mean(st_yld),
                               se=sd(st_yld)/sqrt(length(st_yld)),
                               ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                               ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                               type="Stover"),  
                         ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "trt", "source"), summarise,
                               N=length(gr_yld),                                             
                               mean=mean(gr_yld),
                               se=sd(gr_yld)/sqrt(length(gr_yld)),
                               ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                               ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                               type="Grain"))

meas.crp.treat.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "treat", "rot_phs", "source"), summarise,
                                  N=length(st_yld),
                                  mean=mean(st_yld),
                                  se=sd(st_yld)/sqrt(length(st_yld)),
                                  ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                                  ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                                  type="Stover"),  
                            ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "treat", "rot_phs", "source"), summarise,
                                  N=length(gr_yld),                                             
                                  mean=mean(gr_yld),
                                  se=sd(gr_yld)/sqrt(length(gr_yld)),
                                  ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                                  ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                                  type="Grain"))

meas.crp.trt.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("site", "trt", "rot_phs", "source"), summarise,
                               N=length(st_yld),
                               mean=mean(st_yld),
                               se=sd(st_yld)/sqrt(length(st_yld)),
                               ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                               ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                               type="Stover"),  
                         ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("site", "trt", "rot_phs", "source"), summarise,
                               N=length(gr_yld),                                             
                               mean=mean(gr_yld),
                               se=sd(gr_yld)/sqrt(length(gr_yld)),
                               ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                               ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                               type="Grain"))

meas.site.phs = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("rot_phs", "crop", "source"), summarise,
                            N=length(st_yld),
                            mean=mean(st_yld),
                            se=sd(st_yld)/sqrt(length(st_yld)),
                            ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                            ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                            type="Stover"),  
                      ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("rot_phs", "crop", "source"), summarise,
                            N=length(gr_yld),                                             
                            mean=mean(gr_yld),
                            se=sd(gr_yld)/sqrt(length(gr_yld)),
                            ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                            ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                            type="Grain"))

meas.crops = rbind(ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$st_yld),], c("crop", "source"), summarise,
                        N=length(st_yld),
                        mean=mean(st_yld),
                        se=sd(st_yld)/sqrt(length(st_yld)),
                        ymin=mean(st_yld)-(sd(st_yld)/sqrt(length(st_yld))),
                        ymax=mean(st_yld)+(sd(st_yld)/sqrt(length(st_yld))),
                        type="Stover"),  
                  ddply(meas.raw.ylds[complete.cases(meas.raw.ylds$gr_yld),], c("crop", "source"), summarise,
                        N=length(gr_yld),                                             
                        mean=mean(gr_yld),
                        se=sd(gr_yld)/sqrt(length(gr_yld)),
                        ymin=mean(gr_yld)-(sd(gr_yld)/sqrt(length(gr_yld))),
                        ymax=mean(gr_yld)+(sd(gr_yld)/sqrt(length(gr_yld))),
                        type="Grain"))

### Remove all unwanted objects in the environment (all but mod... and meas...?)

rm(crn.yld, wht.yld, mil.yld, srg.yld, syb.yld)