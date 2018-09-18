#####################################################################################
### PLOTTING SENSITIVITY OUTPUTS OF ALL SITES/SLOPES/TREATMENTS FOR SET VARIABLES ###
#####################################################################################

### DEFINE SENSITIVITY FILENAMES (variables) AND FULL FILE/DIRECTORY LIST

# Use any folder to define the initial filenames

testdir = file.path(resdir, "LAI_Sensitivity/Sterling/WF/Summit/")

# Get filenames for sensitivity analysis output
sensnames = get.sensout(testdir)

# Set core path of all sensitivity simulations

path = file.path(resdir, "LAI_Sensitivity")

# List directories within the core path
dirs = list.dirs(path)

# Select only directories containing results (when "sensitivity-global.txt" is present)
result.dirs = dirs[unlist(lapply(dirs, contains_results))]

# Get list of all files containing results
sens.result.list = lapply(result.dirs, get.sensout.full)

### NAME THE RESULTING LIST

# Set names of results list using directory structure
names = strsplit(sub(path, "", result.dirs),"/")
sites_func = function(x) strsplit(x, "/")[[2]]
sites = sapply(names, sites_func)
treats_func = function(x) strsplit(x, "/")[[3]]
treats = sapply(names, treats_func)
slopes_func = function(x) strsplit(x, "/")[[4]]
slopes = sapply(names, slopes_func)

names = paste(sites,treats,slopes,sep="_")

# Set list names using parent directories
names(sens.result.list) = names

####################################################################################################
### OPTIONAL IF YOU NEED TO VIEW DATAFRAMES SEPARATELY
# Import all results one-at-a-time and assign to individual dataframes in global environment

## dflist = list() # ONLY RUN DOUBLE HASH (##) LINES IF YOU WANT OUTPUT IN A LIST (as well) - don't run "assign()" if you don't want individual dataframes

#for(sim in result.dirs){
#  for (i in sensnames) {
#    result = read.table(paste(sim, i, sep = "/"),
#                        header = TRUE)
#    resname = unlist(strsplit(sub(".txt", "", i), "-"))[2]
#    resname2 = unlist(strsplit(sub(path, "", sim), "/"))[2]
#    resname3 = unlist(strsplit(sub(path, "", sim), "/"))[3]
#    resname4 = unlist(strsplit(sub(path, "", sim), "/"))[4]
#    assign(paste(resname2,resname3,resname4,"result",resname, sep = "."),result) 
##    df_name = paste(resname2,resname3,resname4,"result",resname, sep = ".")
##    dflist[[df_name]] <- result
#  }
#}

#####################################################################################################

### CREATE NAMED LIST OF ALL SENSITIVITY RESULTS AND CALCULATE CONTRIBUTION INDEX FOR EACH VARIABLE

# Extract the results from all outputs into a single list
out = lapply(sens.result.list, extract_result)

# Calculate the contribution index for each output variable (a named column, e.g. SOC) against the 'global sensitivity' 
out.ci1 = lapply(out, function (x) calculate_ci(results = x, output = "SOC"))
out.ci2 = lapply(out, function (x) calculate_ci(results = x, output = "Active"))
out.ci3 = lapply(out, function (x) calculate_ci(results = x, output = "Slow"))
out.ci4 = lapply(out, function (x) calculate_ci(results = x, output = "Passive"))

### COMBINE ALL OUTPUT VARIABLES INTO THE SAME DATAFRAME - SO THEY CAN BE GRAPHED TOGETHER

# Assign the Total SOC to a new dataframe and add descriptor columns for site, treatment, slope and variable
soils.out.ci = do.call(rbind, out.ci1)
soils.out.ci$site = do.call(rbind, strsplit(rownames(soils.out.ci), "[_]"))[, 1]
soils.out.ci$treat = do.call(rbind, strsplit(rownames(soils.out.ci), "[_]"))[, 2]
soils.out.ci$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(soils.out.ci), "[_]"))[, 3])
soils.out.ci$variable = do.call(rbind, strsplit(rownames(soils.out.ci), "[.]"))[, 2]
soils.out.ci$output = "Total SOC"

# Assign the Active SOC to a new dataframe and add descriptor columns for site, treatment, slope and variable
soils.out.ci2 = do.call(rbind, out.ci2)
soils.out.ci2$site = do.call(rbind, strsplit(rownames(soils.out.ci2), "[_]"))[, 1]
soils.out.ci2$treat = do.call(rbind, strsplit(rownames(soils.out.ci2), "[_]"))[, 2]
soils.out.ci2$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(soils.out.ci2), "[_]"))[, 3])
soils.out.ci2$variable = do.call(rbind, strsplit(rownames(soils.out.ci2), "[.]"))[, 2]
soils.out.ci2$output = "Active SOC"

# Assign the Slow SOC to a new dataframe and add descriptor columns for site, treatment, slope and variable
soils.out.ci3 = do.call(rbind, out.ci3)
soils.out.ci3$site = do.call(rbind, strsplit(rownames(soils.out.ci3), "[_]"))[, 1]
soils.out.ci3$treat = do.call(rbind, strsplit(rownames(soils.out.ci3), "[_]"))[, 2]
soils.out.ci3$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(soils.out.ci3), "[_]"))[, 3])
soils.out.ci3$variable = do.call(rbind, strsplit(rownames(soils.out.ci3), "[.]"))[, 2]
soils.out.ci3$output = "Slow SOC"

# Assign the Passive SOC to a new dataframe and add descriptor columns for site, treatment, slope and variable
soils.out.ci4 = do.call(rbind, out.ci4)
soils.out.ci4$site = do.call(rbind, strsplit(rownames(soils.out.ci4), "[_]"))[, 1]
soils.out.ci4$treat = do.call(rbind, strsplit(rownames(soils.out.ci4), "[_]"))[, 2]
soils.out.ci4$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(soils.out.ci4), "[_]"))[, 3])
soils.out.ci4$variable = do.call(rbind, strsplit(rownames(soils.out.ci4), "[.]"))[, 2]
soils.out.ci4$output = "Passive SOC"

# Combine all dataframes together
soils.out.ci = rbind(soils.out.ci, soils.out.ci2, soils.out.ci3, soils.out.ci4)

# Remove extraneous objects
rm(soils.out.ci2, soils.out.ci3, soils.out.ci4)

### PLOT THE SOILS VARIABLES TOGETHER ON A SINGLE TILE PLOT

# Plot contribution indices as barplots, facetted by 'site'
# Visually check to see that the plot a) works and b) has no missing values
ggplot(soils.out.ci[soils.out.ci$variable != "global", ], aes(reorder(variable, ci), ci)) +
geom_bar(stat = "identity") +
facet_wrap(~ site*treat, ncol = 5)

# Make new object before reformatting
soils.CI = soils.out.ci

# Convert site column to all capitals and reorder output levels
soils.CI$site = toupper(soils.CI$site)
soils.CI$output = factor(soils.CI$output, levels=c("Total SOC","Active SOC","Slow SOC","Passive SOC"))

# Average the contribution index over all slopes at each site/treatment/variable/output combination
soils.CI.slope = ddply(soils.CI, c("site", "treat", "variable", "output"), summarise,
                       sdev = mean(sdev),
                       ci2 = mean(ci),
                       cin = length(ci), # As a check (should be same a number of slopes)
                       cise = sd(ci)/sqrt(length(ci))) # As a check of variance between slopes
                       
# Add a 'unique' column to describe the treatment and slope together - this will be the y-axis of the tile plot
soils.CI$uniq = paste(soils.CI$treat,"_",soils.CI$slope,sep="")

# Reorder the x- and y-axis variables to make more sense!
soils.CI$uniq = factor(soils.CI$uniq, levels=c("WF_Summit","WF_Side","WF_Toe",
                                               "WCF_Summit","WCF_Side","WCF_Toe",
                                               "WCMF_Summit","WCMF_Side","WCMF_Toe",
                                               "OPP_Summit","OPP_Side","OPP_Toe",
                                               "Grass_Summit","Grass_Side","Grass_Toe"))
soils.CI.slope$treat = factor(soils.CI.slope$treat, levels=c("WF","WCF","WCMF","OPP","Grass"))

# OVER TREATMENT AND SLOPE
# Graph as a tile plot and save the object for output later
p.sens.soils = ggplot(soils.CI[!soils.CI$variable == "global", ],aes(x=variable,y=uniq, fill = ci)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 4) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd (Orange-Red scale - change if desired)
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment_Slope",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

# OVER TREATMENTS ONLY
# Graph as a tile plot and save the object for output later
p.sens.soils2 = ggplot(soils.CI.slope[!soils.CI.slope$variable == "global", ],aes(x=variable,y=treat, fill = ci2)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 4) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd (Orange-Red scale - change if desired)
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci2,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

### OUTPUT THE SAVED FIGURE AS A PDF TO DESIRED FOLDER. SAVE THE FINAL DATAFRAME OBJECT TO THE SAME FOLDER 

sensdir = file.path(figdir, "Sensitivity Results")

save(soils.CI, file=file.path(sensdir, "sens_soils_output"))
ggsave(p.sens.soils, file=file.path(sensdir, "sens_soils.pdf"), width=400, height=250, units="mm")
ggsave(p.sens.soils2, file=file.path(sensdir, "sens_soils_slope.pdf"), width=280, height=190, units="mm")

####################################################################################
### REPEAT THE FINAL STEPS AS ABOVE FOR OTHER SENSITIVITY VARIABLES AS NECESSARY ###
####################################################################################

#### FOR BIOMASS PRODUCTION VARIABLES

out.ci1 = lapply(out, function (x) calculate_ci(results = x, output = "NPP"))
out.ci2 = lapply(out, function (x) calculate_ci(results = x, output = "NEE"))
out.ci3 = lapply(out, function (x) calculate_ci(results = x, output = "Biomass"))

ylds.out.ci = do.call(rbind, out.ci1)
ylds.out.ci$site = do.call(rbind, strsplit(rownames(ylds.out.ci), "[_]"))[, 1]
ylds.out.ci$treat = do.call(rbind, strsplit(rownames(ylds.out.ci), "[_]"))[, 2]
ylds.out.ci$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ylds.out.ci), "[_]"))[, 3])
ylds.out.ci$variable = do.call(rbind, strsplit(rownames(ylds.out.ci), "[.]"))[, 2]
ylds.out.ci$output = "NPP"

ylds.out.ci2 = do.call(rbind, out.ci2)
ylds.out.ci2$site = do.call(rbind, strsplit(rownames(ylds.out.ci2), "[_]"))[, 1]
ylds.out.ci2$treat = do.call(rbind, strsplit(rownames(ylds.out.ci2), "[_]"))[, 2]
ylds.out.ci2$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ylds.out.ci2), "[_]"))[, 3])
ylds.out.ci2$variable = do.call(rbind, strsplit(rownames(ylds.out.ci2), "[.]"))[, 2]
ylds.out.ci2$output = "NEE"

ylds.out.ci3 = do.call(rbind, out.ci3)
ylds.out.ci3$site = do.call(rbind, strsplit(rownames(ylds.out.ci3), "[_]"))[, 1]
ylds.out.ci3$treat = do.call(rbind, strsplit(rownames(ylds.out.ci3), "[_]"))[, 2]
ylds.out.ci3$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ylds.out.ci3), "[_]"))[, 3])
ylds.out.ci3$variable = do.call(rbind, strsplit(rownames(ylds.out.ci3), "[.]"))[, 2]
ylds.out.ci3$output = "Biomass"

ylds.out.ci = rbind(ylds.out.ci, ylds.out.ci2, ylds.out.ci3)

rm(ylds.out.ci2, ylds.out.ci3)

ylds.CI = ylds.out.ci

ylds.CI$site = toupper(ylds.CI$site)
ylds.CI$output = factor(ylds.CI$output, levels=c("Biomass","NPP","NEE"))

ylds.CI.slope = ddply(ylds.CI, c("site", "treat", "variable", "output"), summarise,
                       sdev = mean(sdev),
                       ci2 = mean(ci),
                       cin = length(ci),
                       cise = sd(ci)/sqrt(length(ci)))

ylds.CI$uniq = paste(ylds.CI$treat,"_",ylds.CI$slope,sep="")

ylds.CI$uniq = factor(ylds.CI$uniq, levels=c("WF_Summit","WF_Side","WF_Toe",
                                               "WCF_Summit","WCF_Side","WCF_Toe",
                                               "WCMF_Summit","WCMF_Side","WCMF_Toe",
                                               "OPP_Summit","OPP_Side","OPP_Toe",
                                               "Grass_Summit","Grass_Side","Grass_Toe"))
ylds.CI.slope$treat = factor(ylds.CI.slope$treat, levels=c("WF","WCF","WCMF","OPP","Grass"))

p.sens.ylds = ggplot(ylds.CI[!ylds.CI$variable == "global", ],aes(x=variable,y=uniq, fill = ci)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 3) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment_Slope",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

p.sens.ylds2 = ggplot(ylds.CI.slope[!ylds.CI.slope$variable == "global", ],aes(x=variable,y=treat, fill = ci2)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 3) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci2,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

if(Sys.info()["sysname"]=="Windows"){
  library(jsonlite)
  file_name<-list.files(paste(Sys.getenv(x = "APPDATA"),"Dropbox", sep="/"), pattern = "*.json", full.names = T)
  if (length(file_name)==0){
    file_name<-list.files(paste(Sys.getenv(x = "LOCALAPPDATA"),"Dropbox", sep="/"), pattern = "*.json", full.names = T)}
  DB<-fromJSON(txt=file_name)$personal
  DB<-DB$path
  setwd(paste(DB, "/CSU/USDA Data/Sensitivity Results/", sep = ""))
} else{
  setwd("~/Dropbox/CSU/USDA Data/Sensitivity Results/")
}

save(ylds.CI, file=file.path(sensdir, "sens_ylds_output"))
ggsave(p.sens.ylds, file=file.path(sensdir, "sens_ylds.pdf"), width=400, height=250, units="mm")
ggsave(p.sens.ylds2, file=file.path(sensdir, "sens_ylds_slope.pdf"), width=280, height=190, units="mm")

#################################################################################################
#################################################################################################

#### FOR BIOMASS PRODUCTION VARIABLES

out.ci1 = lapply(out, function (x) calculate_ci(results = x, output = "N2O"))
out.ci2 = lapply(out, function (x) calculate_ci(results = x, output = "CH4"))
out.ci3 = lapply(out, function (x) calculate_ci(results = x, output = "RESP"))

ghgs.out.ci = do.call(rbind, out.ci1)
ghgs.out.ci$site = do.call(rbind, strsplit(rownames(ghgs.out.ci), "[_]"))[, 1]
ghgs.out.ci$treat = do.call(rbind, strsplit(rownames(ghgs.out.ci), "[_]"))[, 2]
ghgs.out.ci$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ghgs.out.ci), "[_]"))[, 3])
ghgs.out.ci$variable = do.call(rbind, strsplit(rownames(ghgs.out.ci), "[.]"))[, 2]
ghgs.out.ci$output = "N2O"

ghgs.out.ci2 = do.call(rbind, out.ci2)
ghgs.out.ci2$site = do.call(rbind, strsplit(rownames(ghgs.out.ci2), "[_]"))[, 1]
ghgs.out.ci2$treat = do.call(rbind, strsplit(rownames(ghgs.out.ci2), "[_]"))[, 2]
ghgs.out.ci2$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ghgs.out.ci2), "[_]"))[, 3])
ghgs.out.ci2$variable = do.call(rbind, strsplit(rownames(ghgs.out.ci2), "[.]"))[, 2]
ghgs.out.ci2$output = "CH4"

ghgs.out.ci3 = do.call(rbind, out.ci3)
ghgs.out.ci3$site = do.call(rbind, strsplit(rownames(ghgs.out.ci3), "[_]"))[, 1]
ghgs.out.ci3$treat = do.call(rbind, strsplit(rownames(ghgs.out.ci3), "[_]"))[, 2]
ghgs.out.ci3$slope = gsub("\\..*","",do.call(rbind, strsplit(rownames(ghgs.out.ci3), "[_]"))[, 3])
ghgs.out.ci3$variable = do.call(rbind, strsplit(rownames(ghgs.out.ci3), "[.]"))[, 2]
ghgs.out.ci3$output = "CO2"

ghgs.out.ci = rbind(ghgs.out.ci, ghgs.out.ci2, ghgs.out.ci3)

rm(ghgs.out.ci2, ghgs.out.ci3)

ghgs.CI = ghgs.out.ci

ghgs.CI$site = toupper(ghgs.CI$site)
ghgs.CI$output = factor(ghgs.CI$output, levels=c("CO2","CH4","N2O"))

ghgs.CI.slope = ddply(ghgs.CI, c("site", "treat", "variable", "output"), summarise,
                      sdev = mean(sdev),
                      ci2 = mean(ci),
                      cin = length(ci),
                      cise = sd(ci)/sqrt(length(ci)))

ghgs.CI$uniq = paste(ghgs.CI$treat,"_",ghgs.CI$slope,sep="")

ghgs.CI$uniq = factor(ghgs.CI$uniq, levels=c("WF_Summit","WF_Side","WF_Toe",
                                             "WCF_Summit","WCF_Side","WCF_Toe",
                                             "WCMF_Summit","WCMF_Side","WCMF_Toe",
                                             "OPP_Summit","OPP_Side","OPP_Toe",
                                             "Grass_Summit","Grass_Side","Grass_Toe"))
ghgs.CI.slope$treat = factor(ghgs.CI.slope$treat, levels=c("WF","WCF","WCMF","OPP","Grass"))

p.sens.ghgs = ggplot(ghgs.CI[!ghgs.CI$variable == "global", ],aes(x=variable,y=uniq, fill = ci)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 3) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment_Slope",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

p.sens.ghgs2 = ggplot(ghgs.CI.slope[!ghgs.CI.slope$variable == "global", ],aes(x=variable,y=treat, fill = ci2)) +
  geom_tile(colour = "white",
            width = 0.9, height = 0.9) +
  facet_wrap(~ site*output, ncol = 3) +
  scale_fill_continuous(low = "#fef0d9", high = "#d7301f", # colorbrewer2 4-class OrRd
                        limits = c(0, 100),
                        guide = guide_colourbar(title.position = "bottom")) +
  scale_x_discrete(labels = c("B.D.", "Clay", "pH", "Prec", "Temp")) +	
  geom_text(aes(label=format(round(ci2,1),nsmall=1)), size = 3) +
  labs(x = "Variable",
       y = "Treatment",
       fill = expression(Contribution~index~(italic(ci)))) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size = 9),
        axis.text.x = element_text(size = 9),
        axis.title.x = element_text(vjust = 0, size = 11),
        plot.title = element_text(hjust = 1.8),
        panel.spacing = unit(2, "lines"),
        legend.position = "bottom")

save(ghgs.CI, file=file.path(sensdir, "sens_ghgs_output"))
ggsave(p.sens.ghgs, file=file.path(sensdir, "sens_ghgs.pdf"), width=400, height=250, units="mm")
ggsave(p.sens.ghgs2, file=file.path(sensdir, "sens_ghgs_slope.pdf"), width=280, height=190, units="mm")
