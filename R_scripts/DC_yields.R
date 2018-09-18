# --------------------------------------------------------------------------------------#
### CREATES OBJECTS THAT CAN BE USED WITH MEASURED VALUES TO COMPARE 1986-2009 YIELDS ###
# --------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

# ONLY TREATMENT HARVESTS USED - remove other objects
rm(list = grep("*_harvest.csv", ls(), value = TRUE, invert = TRUE))
rm(list = grep("*grass", ls(), value = TRUE, invert = FALSE))

### LOAD FUNCTIONS AGAIN AS THEY'RE ALL DELETED BY THE LAST

if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations again (same as above)
source(file.path(fundir, "RFunctions.R")) # Functions need reloading

### ADD TREATMENT NAME TO MODEL OBJECTS
### CANT WORK OUT HOW TO EXTRACT TREATMENT FROM OBJECT NAMES:
# Therefore doing each treatment individually

wf_names = list(grep("*_wf_harvest.csv", ls(), value = TRUE)) # Get list of names of harvest dataframes
wf_names = unlist(wf_names) # Character string (used to apply names to Map() below)
wf_list = lapply(ls(pattern = "*_wf_harvest.csv"), get) # List of dataframes themselves
temp = Map(cbind, wf_list, treat="WF") # Add treatment column to end of list of dataframes
names(temp) = wf_names # Name the output of all newly created data tables
list2env(temp, envir = .GlobalEnv) # Write data tables over existing dataframes

fw_names = list(grep("*_fw_harvest.csv", ls(), value = TRUE))
fw_names = unlist(fw_names)
fw_list = lapply(ls(pattern = "*_fw_harvest.csv"), get)
temp = Map(cbind, fw_list, treat="FW")
names(temp) = fw_names
list2env(temp, envir = .GlobalEnv)

wcf_names = list(grep("*_wcf_harvest.csv", ls(), value = TRUE))
wcf_names = unlist(wcf_names)
wcf_list = lapply(ls(pattern = "*_wcf_harvest.csv"), get)
temp = Map(cbind, wcf_list, treat="WCF")
names(temp) = wcf_names
list2env(temp, envir = .GlobalEnv)

cfw_names = list(grep("*_cfw_harvest.csv", ls(), value = TRUE))
cfw_names = unlist(cfw_names)
cfw_list = lapply(ls(pattern = "*_cfw_harvest.csv"), get)
temp = Map(cbind, cfw_list, treat="CFW")
names(temp) = cfw_names
list2env(temp, envir = .GlobalEnv)

fwc_names = list(grep("*_fwc_harvest.csv", ls(), value = TRUE))
fwc_names = unlist(fwc_names)
fwc_list = lapply(ls(pattern = "*_fwc_harvest.csv"), get)
temp = Map(cbind, fwc_list, treat="FWC")
names(temp) = fwc_names
list2env(temp, envir = .GlobalEnv)

wcmf_names = list(grep("*_wcmf_harvest.csv", ls(), value = TRUE))
wcmf_names = unlist(wcmf_names)
wcmf_list = lapply(ls(pattern = "*_wcmf_harvest.csv"), get)
temp = Map(cbind, wcmf_list, treat="WCMF")
names(temp) = wcmf_names
list2env(temp, envir = .GlobalEnv)

cmfw_names = list(grep("*_cmfw_harvest.csv", ls(), value = TRUE))
cmfw_names = unlist(cmfw_names)
cmfw_list = lapply(ls(pattern = "*_cmfw_harvest.csv"), get)
temp = Map(cbind, cmfw_list, treat="CMFW")
names(temp) = cmfw_names
list2env(temp, envir = .GlobalEnv)

mfwc_names = list(grep("*_mfwc_harvest.csv", ls(), value = TRUE))
mfwc_names = unlist(mfwc_names)
mfwc_list = lapply(ls(pattern = "*_mfwc_harvest.csv"), get)
temp = Map(cbind, mfwc_list, treat="MFWC")
names(temp) = mfwc_names
list2env(temp, envir = .GlobalEnv)

fwcm_names = list(grep("*_fwcm_harvest.csv", ls(), value = TRUE))
fwcm_names = unlist(fwcm_names)
fwcm_list = lapply(ls(pattern = "*_fwcm_harvest.csv"), get)
temp = Map(cbind, fwcm_list, treat="FWCM")
names(temp) = fwcm_names
list2env(temp, envir = .GlobalEnv)

opp_names = list(grep("*_opp_harvest.csv", ls(), value = TRUE))
opp_names = unlist(opp_names)
opp_list = lapply(ls(pattern = "*_opp_harvest.csv"), get)
temp = Map(cbind, opp_list, treat="OPP")
names(temp) = opp_names
list2env(temp, envir = .GlobalEnv)

### ADD SLOPE NAMES TO MODEL OBJECTS (AS ABOVE WITH TREATMENTS)
### CANT WORK OUT HOW TO EXTRACT SLOPE FROM OBJECT NAMES:
# Therefore doing each slope individually

sum_names = list(grep("*summit", ls(), value = TRUE)) # Get list of names of harvest dataframes
sum_names = unlist(sum_names) # Character string (used to apply names to Map() below)
sum_list = lapply(ls(pattern = "*summit"), get) # List of dataframes themselves
temp = Map(cbind, sum_list, slope="Summit") # Add slope column to end of list of dataframes
names(temp) = sum_names # Name the output of all newly created data tables
list2env(temp, envir = .GlobalEnv) # Write data tables over existing dataframes

sid_names = list(grep("*side", ls(), value = TRUE))
sid_names = unlist(sid_names)
sid_list = lapply(ls(pattern = "*side"), get)
temp = Map(cbind, sid_list, slope="Sideslope")
names(temp) = sid_names
list2env(temp, envir = .GlobalEnv)

to_names = list(grep("*toe", ls(), value = TRUE))
to_names = unlist(to_names)
to_list = lapply(ls(pattern = "*toe"), get)
temp = Map(cbind, to_list, slope="Toeslope")
names(temp) = to_names
list2env(temp, envir = .GlobalEnv)

### PREP ALL OBJECTS NEEDED TO GRAPH MODELLED YIELDS

##############
## STERLING ##
##############
ste_sum = rbind(ste_summit_wf_harvest.csv,ste_summit_fw_harvest.csv,ste_summit_wcf_harvest.csv,ste_summit_cfw_harvest.csv,ste_summit_fwc_harvest.csv,
                ste_summit_wcmf_harvest.csv,ste_summit_cmfw_harvest.csv,ste_summit_mfwc_harvest.csv,ste_summit_fwcm_harvest.csv,ste_summit_opp_harvest.csv)
ste_sum$year = floor(ste_sum$time)
ste_sid = rbind(ste_side_wf_harvest.csv,ste_side_fw_harvest.csv,ste_side_wcf_harvest.csv,ste_side_cfw_harvest.csv,ste_side_fwc_harvest.csv,
                ste_side_wcmf_harvest.csv,ste_side_cmfw_harvest.csv,ste_side_mfwc_harvest.csv,ste_side_fwcm_harvest.csv,ste_side_opp_harvest.csv)
ste_sid$year = floor(ste_sid$time)
ste_toe = rbind(ste_toe_wf_harvest.csv,ste_toe_fw_harvest.csv,ste_toe_wcf_harvest.csv,ste_toe_cfw_harvest.csv,ste_toe_fwc_harvest.csv,
                ste_toe_wcmf_harvest.csv,ste_toe_cmfw_harvest.csv,ste_toe_mfwc_harvest.csv,ste_toe_fwcm_harvest.csv,ste_toe_opp_harvest.csv)
ste_toe$year = floor(ste_toe$time)

ste_yld = rbind(ste_sum, ste_sid, ste_toe)
ste_yld$stvr = ste_yld$agcacc-ste_yld$cgrain
ste_yld$site = "Sterling"

##############
## STRATTON ##
##############
str_sum = rbind(str_summit_wf_harvest.csv,str_summit_fw_harvest.csv,str_summit_wcf_harvest.csv,str_summit_cfw_harvest.csv,str_summit_fwc_harvest.csv,
                str_summit_wcmf_harvest.csv,str_summit_cmfw_harvest.csv,str_summit_mfwc_harvest.csv,str_summit_fwcm_harvest.csv,str_summit_opp_harvest.csv)
str_sum$year = floor(str_sum$time)
str_sid = rbind(str_side_wf_harvest.csv,str_side_fw_harvest.csv,str_side_wcf_harvest.csv,str_side_cfw_harvest.csv,str_side_fwc_harvest.csv,
                str_side_wcmf_harvest.csv,str_side_cmfw_harvest.csv,str_side_mfwc_harvest.csv,str_side_fwcm_harvest.csv,str_side_opp_harvest.csv)
str_sid$year = floor(str_sid$time)
str_toe = rbind(str_toe_wf_harvest.csv,str_toe_fw_harvest.csv,str_toe_wcf_harvest.csv,str_toe_cfw_harvest.csv,str_toe_fwc_harvest.csv,
                str_toe_wcmf_harvest.csv,str_toe_cmfw_harvest.csv,str_toe_mfwc_harvest.csv,str_toe_fwcm_harvest.csv,str_toe_opp_harvest.csv)
str_toe$year = floor(str_toe$time)

str_yld = rbind(str_sum, str_sid, str_toe)
str_yld$stvr = str_yld$agcacc-str_yld$cgrain
str_yld$site = "Stratton"

###########
## WALSH ##
###########
wal_sum = rbind(wal_summit_wf_harvest.csv,wal_summit_fw_harvest.csv,wal_summit_wcf_harvest.csv,wal_summit_cfw_harvest.csv,wal_summit_fwc_harvest.csv,
                wal_summit_wcmf_harvest.csv,wal_summit_cmfw_harvest.csv,wal_summit_mfwc_harvest.csv,wal_summit_fwcm_harvest.csv,wal_summit_opp_harvest.csv)
wal_sum$year = floor(wal_sum$time)
wal_sid = rbind(wal_side_wf_harvest.csv,wal_side_fw_harvest.csv,wal_side_wcf_harvest.csv,wal_side_cfw_harvest.csv,wal_side_fwc_harvest.csv,
                wal_side_wcmf_harvest.csv,wal_side_cmfw_harvest.csv,wal_side_mfwc_harvest.csv,wal_side_fwcm_harvest.csv,wal_side_opp_harvest.csv)
wal_sid$year = floor(wal_sid$time)
wal_toe = rbind(wal_toe_wf_harvest.csv,wal_toe_fw_harvest.csv,wal_toe_wcf_harvest.csv,wal_toe_cfw_harvest.csv,wal_toe_fwc_harvest.csv,
                wal_toe_wcmf_harvest.csv,wal_toe_cmfw_harvest.csv,wal_toe_mfwc_harvest.csv,wal_toe_fwcm_harvest.csv,wal_toe_opp_harvest.csv)
wal_toe$year = floor(wal_toe$time)

wal_yld = rbind(wal_sum, wal_sid, wal_toe)
wal_yld$stvr = wal_yld$agcacc-wal_yld$cgrain
wal_yld$site = "Walsh"

mod.raw.ylds = rbind(ste_yld, str_yld, wal_yld) # Create this object if you want to keep the raw model harvest results (i.e. not just those averaged across slopes and for 'major' crops)

mod.raw.ylds$crpval = as.character(mod.raw.ylds$crpval)
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'W3SG83'"] = "Wheat"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'W3SN90'"] = "Wheat"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'W3WS99'"] = "Wheat"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'C6SG66'"] = "Corn"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'C6SN73'"] = "Corn"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'C6WS82'"] = "Corn"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'MILO89'"] = "Millet"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'AWP70'"] = "Winter Pea"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'SYBN102'"] = "Soybean"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'SRGS120'"] = "Sorghum"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'SRGS127'"] = "Sorghum"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'SRGW136'"] = "Sorghum"
mod.raw.ylds$crpval[mod.raw.ylds$crpval=="'SUN84'"] = "Sunflower"
mod.raw.ylds$crpval = as.factor(mod.raw.ylds$crpval)

names(mod.raw.ylds)[names(mod.raw.ylds) == 'crpval'] = 'crop' # Change name of crop column

test = ifelse(mod.raw.ylds$year<1998, "1986-1997", "1998-2009") # Add in rotation phase
mod.raw.ylds = InsertDFCol("rot_phs", test, mod.raw.ylds, after="time") # Insert into the correct position for comparison with measurements
mod.raw.ylds$rot_phs = as.factor(mod.raw.ylds$rot_phs)

mod.raw.ylds$treatno[mod.raw.ylds$treat == "WF"] = 1
mod.raw.ylds$treatno[mod.raw.ylds$treat == "FW"] = 2
mod.raw.ylds$treatno[mod.raw.ylds$treat == "WCF"] = 3
mod.raw.ylds$treatno[mod.raw.ylds$treat == "CFW"] = 4
mod.raw.ylds$treatno[mod.raw.ylds$treat == "FWC"] = 5
mod.raw.ylds$treatno[mod.raw.ylds$treat == "WCMF"] = 6
mod.raw.ylds$treatno[mod.raw.ylds$treat == "CMFW"] = 7
mod.raw.ylds$treatno[mod.raw.ylds$treat == "MFWC"] = 8
mod.raw.ylds$treatno[mod.raw.ylds$treat == "FWCM"] = 9
mod.raw.ylds$treatno[mod.raw.ylds$treat == "OPP"] = 10
mod.raw.ylds$treatno[mod.raw.ylds$treat == "Grass"] = 11

mod.raw.ylds$trt = mod.raw.ylds$treat
mod.raw.ylds$trt = factor(mod.raw.ylds$trt, levels = c("WF","WCM","WCF","WCMF","WWCM","OPP","Grass"))
mod.raw.ylds$treat = factor(mod.raw.ylds$treat, levels = c("WF","FW","WCM","CMW","WCF","CFW","FWC",
                                                           "WCMW","CMWW","MWWC","WWCM","WCMF","CMFW",
                                                           "MFWC","FWCM","OPP","Grass"))

mod.raw.ylds$trt[mod.raw.ylds$treatno == 1 & mod.raw.ylds$rot_phs == "1986-1997"] = "WF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 2 & mod.raw.ylds$rot_phs == "1986-1997"] = "WF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 1 & mod.raw.ylds$rot_phs == "1998-2009"] = "WCM"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 2 & mod.raw.ylds$rot_phs == "1998-2009"] = "WCM"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 1 & mod.raw.ylds$rot_phs == "1986-1997"] = "WF"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 2 & mod.raw.ylds$rot_phs == "1986-1997"] = "FW"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 1 & mod.raw.ylds$rot_phs == "1998-2009"] = "WCM"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 2 & mod.raw.ylds$rot_phs == "1998-2009"] = "CMW"

mod.raw.ylds$trt[mod.raw.ylds$treatno == 6 & mod.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 7 & mod.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 8 & mod.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 9 & mod.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 6 & mod.raw.ylds$rot_phs == "1998-2009"] = "WWCM"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 7 & mod.raw.ylds$rot_phs == "1998-2009"] = "WWCM"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 8 & mod.raw.ylds$rot_phs == "1998-2009"] = "WWCM"
mod.raw.ylds$trt[mod.raw.ylds$treatno == 9 & mod.raw.ylds$rot_phs == "1998-2009"] = "WWCM"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 6 & mod.raw.ylds$rot_phs == "1986-1997"] = "WCMF"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 7 & mod.raw.ylds$rot_phs == "1986-1997"] = "CMFW"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 8 & mod.raw.ylds$rot_phs == "1986-1997"] = "MFWC"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 9 & mod.raw.ylds$rot_phs == "1986-1997"] = "FWCM"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 6 & mod.raw.ylds$rot_phs == "1998-2009"] = "WCMW"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 7 & mod.raw.ylds$rot_phs == "1998-2009"] = "CMWW"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 8 & mod.raw.ylds$rot_phs == "1998-2009"] = "MWWC"
mod.raw.ylds$treat[mod.raw.ylds$treatno == 9 & mod.raw.ylds$rot_phs == "1998-2009"] = "WWCM"

mod.raw.ylds$trt[mod.raw.ylds$treat == "WCF"] = "WCF"
mod.raw.ylds$trt[mod.raw.ylds$treat == "CFW"] = "WCF"
mod.raw.ylds$trt[mod.raw.ylds$treat == "FWC"] = "WCF"
mod.raw.ylds$trt[mod.raw.ylds$treat == "OPP"] = "OPP"
mod.raw.ylds$trt[mod.raw.ylds$treat == "Grass"] = "Grass"

mod.raw.ylds$trt = factor(mod.raw.ylds$trt, levels = c("WF","WCM","WCF","WCMF","WWCM","OPP","Grass"))
mod.raw.ylds$treat = factor(mod.raw.ylds$treat, levels = c("WF","FW","WCM","CMW","WCF","CFW","FWC",
                                                           "WCMW","CMWW","MWWC","WWCM","WCMF","CMFW",
                                                           "MFWC","FWCM","OPP","Grass"))

mod.raw.ylds$source = "Modelled" # This is used for comparison with measured yields when graphing/sub-setting

mod.ylds = rbind(ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.treat = rbind(ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "treat", "source"), summarise,
                       N = length(cgrain),
                       mean = mean(cgrain),
                       se = sd(cgrain)/sqrt(length(cgrain)),
                       ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                       ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                       type = "Grain"),
                 ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "treat", "source"), summarise,
                       N = length(stvr),
                       mean = mean(stvr),
                       se = sd(stvr)/sqrt(length(stvr)),
                       ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                       ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                       type = "Stover"))

mod.trt = rbind(ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "trt", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("year", "rot_phs", "site", "crop", "trt", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.phs = rbind(ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.slp.phs = rbind(ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "slope", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "slope", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.treat.phs = rbind(ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "treat", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "treat", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.trt.phs = rbind(ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "trt", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("rot_phs", "site", "crop", "trt", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.all = rbind(ddply(mod.raw.ylds, c("site", "crop", "source"), summarise,
                       N = length(cgrain),
                       mean = mean(cgrain),
                       se = sd(cgrain)/sqrt(length(cgrain)),
                       ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                       ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                       type = "Grain"),
                 ddply(mod.raw.ylds, c("site", "crop", "source"), summarise,
                       N = length(stvr),
                       mean = mean(stvr),
                       se = sd(stvr)/sqrt(length(stvr)),
                       ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                       ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                       type = "Stover"))

mod.treat.all = rbind(ddply(mod.raw.ylds, c("site", "crop", "treat", "source"), summarise,
                      N = length(cgrain),
                      mean = mean(cgrain),
                      se = sd(cgrain)/sqrt(length(cgrain)),
                      ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                      ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                      type = "Grain"),
                ddply(mod.raw.ylds, c("site", "crop", "treat", "source"), summarise,
                      N = length(stvr),
                      mean = mean(stvr),
                      se = sd(stvr)/sqrt(length(stvr)),
                      ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                      ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                      type = "Stover"))

mod.trt.all = rbind(ddply(mod.raw.ylds, c("site", "crop", "trt", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("site", "crop", "trt", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.slp.treat.all = rbind(ddply(mod.raw.ylds, c("site", "crop", "treat", "slope", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("site", "crop", "treat", "slope", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.slp.trt.all = rbind(ddply(mod.raw.ylds, c("site", "crop", "trt", "slope", "source"), summarise,
                              N = length(cgrain),
                              mean = mean(cgrain),
                              se = sd(cgrain)/sqrt(length(cgrain)),
                              ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                              ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                              type = "Grain"),
                        ddply(mod.raw.ylds, c("site", "crop", "trt", "slope", "source"), summarise,
                              N = length(stvr),
                              mean = mean(stvr),
                              se = sd(stvr)/sqrt(length(stvr)),
                              ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                              ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                              type = "Stover"))

mod.crp.all = rbind(ddply(mod.raw.ylds, c("site", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("site", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.crp.treat.all = rbind(ddply(mod.raw.ylds, c("site", "treat", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("site", "treat", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.crp.trt.all = rbind(ddply(mod.raw.ylds, c("site", "trt", "source"), summarise,
                              N = length(cgrain),
                              mean = mean(cgrain),
                              se = sd(cgrain)/sqrt(length(cgrain)),
                              ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                              ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                              type = "Grain"),
                        ddply(mod.raw.ylds, c("site", "trt", "source"), summarise,
                              N = length(stvr),
                              mean = mean(stvr),
                              se = sd(stvr)/sqrt(length(stvr)),
                              ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                              ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                              type = "Stover"))

mod.crp.treat.phs = rbind(ddply(mod.raw.ylds, c("site", "treat", "rot_phs", "source"), summarise,
                          N = length(cgrain),
                          mean = mean(cgrain),
                          se = sd(cgrain)/sqrt(length(cgrain)),
                          ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                          ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                          type = "Grain"),
                    ddply(mod.raw.ylds, c("site", "treat", "rot_phs", "source"), summarise,
                          N = length(stvr),
                          mean = mean(stvr),
                          se = sd(stvr)/sqrt(length(stvr)),
                          ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                          ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                          type = "Stover"))

mod.crp.trt.phs = rbind(ddply(mod.raw.ylds, c("site", "trt", "rot_phs", "source"), summarise,
                              N = length(cgrain),
                              mean = mean(cgrain),
                              se = sd(cgrain)/sqrt(length(cgrain)),
                              ymin=mean(cgrain)-(sd(cgrain)/sqrt(length(cgrain))),
                              ymax=mean(cgrain)+(sd(cgrain)/sqrt(length(cgrain))),
                              type = "Grain"),
                        ddply(mod.raw.ylds, c("site", "trt", "rot_phs", "source"), summarise,
                              N = length(stvr),
                              mean = mean(stvr),
                              se = sd(stvr)/sqrt(length(stvr)),
                              ymin=mean(stvr)-(sd(stvr)/sqrt(length(stvr))),
                              ymax=mean(stvr)+(sd(stvr)/sqrt(length(stvr))),
                              type = "Stover"))

### Remove all unwanted objects in the environment (all but mod...?)

rm(list = grep("^mod.", ls(), value = TRUE, invert = TRUE))
