#######################################################
### CLIMATE SUMMARY INFO FROM GCMS AND RCP SCENARIOS
#######################################################

# Created to be used in conjunction with MasterScript

# Create summary dataframe and save

tmp = future_clim[future_clim$year>=1986,]

clim_sums = tmp[,list(crain2 = sum(rain),
                      tair2 = mean(tave),
                      N = length(rain)),
                by=list(year,site,GCM,RCP)]

clim_sums = clim_sums[,list(crain = mean(crain2),
                            crainmn = min(crain2),
                            crainmx = max(crain2),
                            tair = mean(tair2),
                            tmn = min(tair2),
                            tmx = max(tair2),
                            N = length(GCM)),
                      by=list(year,RCP)]

write.csv(clim_sums, file=file.path(figdir, "model_climate_summary.csv"))

# AVERAGE BETWEEN 1985 and 2009

tmp2 = clim_sums[clim_sums$year>=1986&clim_sums$year<=2009,]

print(paste("Average Air Temp across all sites between 1986 and 2009, inclusive = ", round(mean(tmp2$tair),2), " between ", round(min(tmp2$tair),2), " and ", round(max(tmp2$tair),2), sep=""))
print(paste("Average Annual Precip across all sites between 1986 and 2009, inclusive = ", round(mean(tmp2$crain)*10,0), " between ", round(min(tmp2$crain)*10,0), " and ", round(max(tmp2$crain)*10,0), sep=""))

tmp = clim_sums[clim_sums$year==2010,]

print(paste("Average Air temp across all sites in 2010 under RCP4.5 = ", round(tmp$tair[tmp$RCP=="RCP45"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP45"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP45"],2), sep=""))
print(paste("Average Air temp across all sites in 2010 under RCP8.5 = ", round(tmp$tair[tmp$RCP=="RCP85"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP85"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP85"],2), sep=""))

print(paste("Average Annual Precip across all sites in 2010 under RCP4.5 = ", round(tmp$crain[tmp$RCP=="RCP45"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP45"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP45"]*10,0), sep=""))
print(paste("Average Annual Precip across all sites in 2010 under RCP8.5 = ", round(tmp$crain[tmp$RCP=="RCP85"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP85"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP85"]*10,0), sep=""))

tmp = clim_sums[clim_sums$year==2050,]

print(paste("Average Air temp across all sites in 2050 under RCP4.5 = ", round(tmp$tair[tmp$RCP=="RCP45"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP45"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP45"],2), sep=""))
print(paste("Average Air temp across all sites in 2050 under RCP8.5 = ", round(tmp$tair[tmp$RCP=="RCP85"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP85"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP85"],2), sep=""))

print(paste("Average Annual Precip across all sites in 2050 under RCP4.5 = ", round(tmp$crain[tmp$RCP=="RCP45"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP45"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP45"]*10,0), sep=""))
print(paste("Average Annual Precip across all sites in 2050 under RCP8.5 = ", round(tmp$crain[tmp$RCP=="RCP85"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP85"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP85"]*10,0), sep=""))

tmp = clim_sums[clim_sums$year==2100,]

print(paste("Average Air temp across all sites in 2100 under RCP4.5 = ", round(tmp$tair[tmp$RCP=="RCP45"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP45"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP45"],2), sep=""))
print(paste("Average Air temp across all sites in 2100 under RCP8.5 = ", round(tmp$tair[tmp$RCP=="RCP85"],2), " between ", round(tmp$tmn[tmp$RCP=="RCP85"],2), " and ", round(tmp$tmx[tmp$RCP=="RCP85"],2), sep=""))

print(paste("Average Annual Precip across all sites in 2100 under RCP4.5 = ", round(tmp$crain[tmp$RCP=="RCP45"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP45"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP45"]*10,0), sep=""))
print(paste("Average Annual Precip across all sites in 2100 under RCP8.5 = ", round(tmp$crain[tmp$RCP=="RCP85"]*10,0), " between ", round(tmp$crainmn[tmp$RCP=="RCP85"]*10,0), " and ", round(tmp$crainmx[tmp$RCP=="RCP85"]*10,0), sep=""))

tmp2 = clim_sums[clim_sums$year>=2096&clim_sums$year<=2100&clim_sums$RCP=="RCP45",]

print(paste("Average Air Temp across all sites between 2096 and 2100, inclusive under RCP4.5 = ", round(mean(tmp2$tair),2), " between ", round(min(tmp2$tair),2), " and ", round(max(tmp2$tair),2), sep=""))
print(paste("Average Annual Precip across all sites between 2096 and 2100, inclusive under RCP4.5 = ", round(mean(tmp2$crain)*10,0), " between ", round(min(tmp2$crain)*10,0), " and ", round(max(tmp2$crain)*10,0), sep=""))

tmp2 = clim_sums[clim_sums$year>=2096&clim_sums$year<=2100&clim_sums$RCP=="RCP85",]

print(paste("Average Air Temp across all sites between 2096 and 2100, inclusive under RCP8.5 = ", round(mean(tmp2$tair),2), " between ", round(min(tmp2$tair),2), " and ", round(max(tmp2$tair),2), sep=""))
print(paste("Average Annual Precip across all sites between 2096 and 2100, inclusive under RCP8.5 = ", round(mean(tmp2$crain)*10,0), " between ", round(min(tmp2$crain)*10,0), " and ", round(max(tmp2$crain)*10,0), sep=""))

rm(tmp, tmp2)
