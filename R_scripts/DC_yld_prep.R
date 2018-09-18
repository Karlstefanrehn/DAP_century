#######################################################################################
### Preapring to create tables of measured and modelled carbon inputs to the system ###
#######################################################################################

# Preparing DayCent outputs to allow for tables to be created for publication
# Ultimately this script simply creates a dataframe that assigns annual yield estimates

# Typically used in conjunction with MasterScript - see that file for more info

# ONLY .LIS FILES USED - remove other objects
rm(list = grep("*lis", ls(), value = TRUE, invert = TRUE))

### ADD TREATMENT NAME TO MODEL OBJECTS
### CANT WORK OUT HOW TO EXTRACT TREATMENT FROM OBJECT NAMES:
# Therefore doing each treatment individually

wf_names = list(grep("*_wf.lis", ls(), value = TRUE)) # Get list of names of harvest dataframes
wf_names = unlist(wf_names) # Character string (used to apply names to Map() below)
wf.list = lapply(ls(pattern = "*_wf.lis"), get) # List of dataframes themselves
temp = Map(cbind, treat="WF", wf.list) # Add treatment column to end of list of dataframes
names(temp) = wf_names # Name the output of all newly created data tables
list2env(temp, envir = .GlobalEnv) # Write data tables over existing dataframes

fw_names = list(grep("*_fw.lis", ls(), value = TRUE))
fw_names = unlist(fw_names)
fw.list = lapply(ls(pattern = "*_fw.lis"), get)
temp = Map(cbind, treat="FW", fw.list)
names(temp) = fw_names
list2env(temp, envir = .GlobalEnv)

wcf_names = list(grep("*_wcf.lis", ls(), value = TRUE))
wcf_names = unlist(wcf_names)
wcf.list = lapply(ls(pattern = "*_wcf.lis"), get)
temp = Map(cbind, treat="WCF", wcf.list)
names(temp) = wcf_names
list2env(temp, envir = .GlobalEnv)

cfw_names = list(grep("*_cfw.lis", ls(), value = TRUE))
cfw_names = unlist(cfw_names)
cfw.list = lapply(ls(pattern = "*_cfw.lis"), get)
temp = Map(cbind, treat="CFW", cfw.list)
names(temp) = cfw_names
list2env(temp, envir = .GlobalEnv)

fwc_names = list(grep("*_fwc.lis", ls(), value = TRUE))
fwc_names = unlist(fwc_names)
fwc.list = lapply(ls(pattern = "*_fwc.lis"), get)
temp = Map(cbind, treat="FWC", fwc.list)
names(temp) = fwc_names
list2env(temp, envir = .GlobalEnv)

wcmf_names = list(grep("*_wcmf.lis", ls(), value = TRUE))
wcmf_names = unlist(wcmf_names)
wcmf.list = lapply(ls(pattern = "*_wcmf.lis"), get)
temp = Map(cbind, treat="WCMF", wcmf.list)
names(temp) = wcmf_names
list2env(temp, envir = .GlobalEnv)

cmfw_names = list(grep("*_cmfw.lis", ls(), value = TRUE))
cmfw_names = unlist(cmfw_names)
cmfw.list = lapply(ls(pattern = "*_cmfw.lis"), get)
temp = Map(cbind, treat="CMFW", cmfw.list)
names(temp) = cmfw_names
list2env(temp, envir = .GlobalEnv)

mfwc_names = list(grep("*_mfwc.lis", ls(), value = TRUE))
mfwc_names = unlist(mfwc_names)
mfwc.list = lapply(ls(pattern = "*_mfwc.lis"), get)
temp = Map(cbind, treat="MFWC", mfwc.list)
names(temp) = mfwc_names
list2env(temp, envir = .GlobalEnv)

fwcm_names = list(grep("*_fwcm.lis", ls(), value = TRUE))
fwcm_names = unlist(fwcm_names)
fwcm.list = lapply(ls(pattern = "*_fwcm.lis"), get)
temp = Map(cbind, treat="FWCM", fwcm.list)
names(temp) = fwcm_names
list2env(temp, envir = .GlobalEnv)

opp_names = list(grep("*_opp.lis", ls(), value = TRUE))
opp_names = unlist(opp_names)
opp.list = lapply(ls(pattern = "*_opp.lis"), get)
temp = Map(cbind, treat="OPP", opp.list)
names(temp) = opp_names
list2env(temp, envir = .GlobalEnv)

grass_names = list(grep("*_grass.lis", ls(), value = TRUE))
grass_names = unlist(grass_names)
grass.list = lapply(ls(pattern = "*_grass.lis"), get)
temp = Map(cbind, treat="Grass", grass.list)
names(temp) = grass_names
list2env(temp, envir = .GlobalEnv)

base_names = list(grep("*_base.lis", ls(), value = TRUE))
base_names = unlist(base_names)
base.list = lapply(ls(pattern = "*_base.lis"), get)
temp = Map(cbind, treat="base", base.list)
names(temp) = base_names
list2env(temp, envir = .GlobalEnv)

### ADD SLOPE NAMES TO MODEL OBJECTS (AS ABOVE WITH TREATMENTS)
### CANT WORK OUT HOW TO EXTRACT SLOPE FROM OBJECT NAMES:
# Therefore doing each slope individually

sum_names = list(grep("*summit", ls(), value = TRUE)) # Get list of names of harvest dataframes
sum_names = unlist(sum_names) # Character string (used to apply names to Map() below)
sum_list = lapply(ls(pattern = "*summit"), get) # List of dataframes themselves
temp = Map(cbind, slope="Summit", sum_list) # Add slope column to end of list of dataframes
names(temp) = sum_names # Name the output of all newly created data tables
list2env(temp, envir = .GlobalEnv) # Write data tables over existing dataframes

sid_names = list(grep("*side", ls(), value = TRUE))
sid_names = unlist(sid_names)
sid_list = lapply(ls(pattern = "*side"), get)
temp = Map(cbind, slope="Sideslope", sid_list)
names(temp) = sid_names
list2env(temp, envir = .GlobalEnv)

to_names = list(grep("*toe", ls(), value = TRUE))
to_names = unlist(to_names)
to_list = lapply(ls(pattern = "*toe"), get)
temp = Map(cbind, slope="Toeslope", to_list)
names(temp) = to_names
list2env(temp, envir = .GlobalEnv)

# Select columns needed

lst <- mget(ls())
list2env(lapply(lst,`[`,c(1:9,37)), envir=.GlobalEnv)

### COMBINE OBJECTS ACROSS SITES AND SLOPES

##############
## STERLING ##
##############
ste_sum = rbind(ste_summit_wf.lis,ste_summit_fw.lis,ste_summit_wcf.lis,ste_summit_cfw.lis,ste_summit_fwc.lis,
                ste_summit_wcmf.lis,ste_summit_cmfw.lis,ste_summit_mfwc.lis,ste_summit_fwcm.lis,ste_summit_opp.lis,ste_summit_grass.lis)
ste_sum$year = floor(ste_sum$time)
ste_sid = rbind(ste_side_wf.lis,ste_side_fw.lis,ste_side_wcf.lis,ste_side_cfw.lis,ste_side_fwc.lis,
                ste_side_wcmf.lis,ste_side_cmfw.lis,ste_side_mfwc.lis,ste_side_fwcm.lis,ste_side_opp.lis,ste_side_grass.lis)
ste_sid$year = floor(ste_sid$time)
ste_toe = rbind(ste_toe_wf.lis,ste_toe_fw.lis,ste_toe_wcf.lis,ste_toe_cfw.lis,ste_toe_fwc.lis,
                ste_toe_wcmf.lis,ste_toe_cmfw.lis,ste_toe_mfwc.lis,ste_toe_fwcm.lis,ste_toe_opp.lis,ste_toe_grass.lis)
ste_toe$year = floor(ste_toe$time)

ste_slc = rbind(ste_sum, ste_sid, ste_toe)
ste_slc$agc = ste_slc$som1c.1.+ste_slc$som2c.1. # Aboveground total
ste_slc$bgc = ste_slc$som1c.2.+ste_slc$som2c.2.+ste_slc$som3c # Belowground total
ste_slc$pslow = ste_slc$som2c.2./ste_slc$bgc
ste_slc$site = "Sterling"

##############
## STRATTON ##
##############
str_sum = rbind(str_summit_wf.lis,str_summit_fw.lis,str_summit_wcf.lis,str_summit_cfw.lis,str_summit_fwc.lis,
                str_summit_wcmf.lis,str_summit_cmfw.lis,str_summit_mfwc.lis,str_summit_fwcm.lis,str_summit_opp.lis,str_summit_grass.lis)
str_sum$year = floor(str_sum$time)
str_sid = rbind(str_side_wf.lis,str_side_fw.lis,str_side_wcf.lis,str_side_cfw.lis,str_side_fwc.lis,
                str_side_wcmf.lis,str_side_cmfw.lis,str_side_mfwc.lis,str_side_fwcm.lis,str_side_opp.lis,str_side_grass.lis)
str_sid$year = floor(str_sid$time)
str_toe = rbind(str_toe_wf.lis,str_toe_fw.lis,str_toe_wcf.lis,str_toe_cfw.lis,str_toe_fwc.lis,
                str_toe_wcmf.lis,str_toe_cmfw.lis,str_toe_mfwc.lis,str_toe_fwcm.lis,str_toe_opp.lis,str_toe_grass.lis)
str_toe$year = floor(str_toe$time)

str_slc = rbind(str_sum, str_sid, str_toe)
str_slc$agc = str_slc$som1c.1.+str_slc$som2c.1. # Aboveground total
str_slc$bgc = str_slc$som1c.2.+str_slc$som2c.2.+str_slc$som3c # Belowground total
str_slc$pslow = str_slc$som2c.2./str_slc$bgc
str_slc$site = "Stratton"

###########
## WALSH ##
###########
wal_sum = rbind(wal_summit_wf.lis,wal_summit_fw.lis,wal_summit_wcf.lis,wal_summit_cfw.lis,wal_summit_fwc.lis,
                wal_summit_wcmf.lis,wal_summit_cmfw.lis,wal_summit_mfwc.lis,wal_summit_fwcm.lis,wal_summit_opp.lis,wal_summit_grass.lis)
wal_sum$year = floor(wal_sum$time)
wal_sid = rbind(wal_side_wf.lis,wal_side_fw.lis,wal_side_wcf.lis,wal_side_cfw.lis,wal_side_fwc.lis,
                wal_side_wcmf.lis,wal_side_cmfw.lis,wal_side_mfwc.lis,wal_side_fwcm.lis,wal_side_opp.lis,wal_side_grass.lis)
wal_sid$year = floor(wal_sid$time)
wal_toe = rbind(wal_toe_wf.lis,wal_toe_fw.lis,wal_toe_wcf.lis,wal_toe_cfw.lis,wal_toe_fwc.lis,
                wal_toe_wcmf.lis,wal_toe_cmfw.lis,wal_toe_mfwc.lis,wal_toe_fwcm.lis,wal_toe_opp.lis,wal_toe_grass.lis)
wal_toe$year = floor(wal_toe$time)

wal_slc = rbind(wal_sum, wal_sid, wal_toe)
wal_slc$agc = wal_slc$som1c.1.+wal_slc$som2c.1. # Aboveground total
wal_slc$bgc = wal_slc$som1c.2.+wal_slc$som2c.2.+wal_slc$som3c # Belowground total
wal_slc$pslow = wal_slc$som2c.2./wal_slc$bgc
wal_slc$site = "Walsh"

mod.raw.slc = rbind(ste_slc, str_slc, wal_slc) # Create this object if you want to keep the raw model results 

mod.raw.slc$treatno[mod.raw.slc$treat == "WF"] = 1
mod.raw.slc$treatno[mod.raw.slc$treat == "FW"] = 2
mod.raw.slc$treatno[mod.raw.slc$treat == "WCF"] = 3
mod.raw.slc$treatno[mod.raw.slc$treat == "CFW"] = 4
mod.raw.slc$treatno[mod.raw.slc$treat == "FWC"] = 5
mod.raw.slc$treatno[mod.raw.slc$treat == "WCMF"] = 6
mod.raw.slc$treatno[mod.raw.slc$treat == "CMFW"] = 7
mod.raw.slc$treatno[mod.raw.slc$treat == "MFWC"] = 8
mod.raw.slc$treatno[mod.raw.slc$treat == "FWCM"] = 9
mod.raw.slc$treatno[mod.raw.slc$treat == "OPP"] = 10
mod.raw.slc$treatno[mod.raw.slc$treat == "Grass"] = 11

mod.raw.slc$trt[mod.raw.slc$treat == "WF"] = "WF"
mod.raw.slc$trt[mod.raw.slc$treat == "FW"] = "WF"
mod.raw.slc$trt[mod.raw.slc$treat == "WCF"] = "WCF"
mod.raw.slc$trt[mod.raw.slc$treat == "CFW"] = "WCF"
mod.raw.slc$trt[mod.raw.slc$treat == "FWC"] = "WCF"
mod.raw.slc$trt[mod.raw.slc$treat == "WCMF"] = "WCMF"
mod.raw.slc$trt[mod.raw.slc$treat == "CMFW"] = "WCMF"
mod.raw.slc$trt[mod.raw.slc$treat == "MFWC"] = "WCMF"
mod.raw.slc$trt[mod.raw.slc$treat == "FWCM"] = "WCMF"
mod.raw.slc$trt[mod.raw.slc$treat == "OPP"] = "OPP"
mod.raw.slc$trt[mod.raw.slc$treat == "Grass"] = "Grass"

mod.raw.slc$source = "Modelled" # This is used for comparison with measured yields when graphing/sub-setting

mod.raw.slc$monthfrac = mod.raw.slc$time - mod.raw.slc$year
mod.raw.annuals = subset(mod.raw.slc, mod.raw.slc$monthfrac == 0.0)
mod.raw.annuals = subset(mod.raw.annuals, mod.raw.annuals$cinput != 0) # This removes the first month of extended simulations by deleting any rows of cumulative columns where 0 is found
mod.raw.annuals$year[mod.raw.annuals$monthfrac==0] = mod.raw.annuals$year[mod.raw.annuals$monthfrac==0]-1 # Month 0.0 is in fact December of the previous year
mod.raw.annuals$monthfrac[mod.raw.annuals$monthfrac==0] = 1 # Month 0.0 is in fact December of the previous year
mod.raw.annuals$month = round(mod.raw.annuals$monthfrac*12,0)

# ONLY FINAL OBJECT NEEDED SO SAVE AND RELOAD IN NEXT SCRIPT

if(Sys.info()["sysname"]=="Windows"){source("H:/dirlocations.R")} else{source("/media/andy/Modelling/dirlocations.R")} # Get directory locations
save(mod.raw.annuals, file=file.path(Robjsdir, "mod.raw.annuals"))
save(mod.raw.slc, file=file.path(Robjsdir, "mod.raw.slc"))

### Remove all unwanted objects in the environment (all but mod...?)

rm(list = grep("^mod.", ls(), value = TRUE, invert = TRUE))
