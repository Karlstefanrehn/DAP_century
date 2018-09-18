# -------------------------------------------------------------------------------------#
### CREATES ANIMATED GIF FIGURES COMPARING CHANGE IN SOC TO TOTAL C INPUTS 2010-2094 ###
# -------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

all_data2 = list()
for(i in 2009:2087) {
  tempdf = all_data[all_data$year>i&all_data$year<(i+13),]
  tempdf$phase = paste((i+1),(i+12),sep="-")
  all_data2[[i]] <- tempdf
}

gif_data = rbindlist(all_data2)

# DDPLY CAN BE SLOW WORKING WITH LARGE DATA FRAMES SO USE DATA TABLE INSTEAD - should be the same output
#gif_summary = ddply(gif_data, c("year","site","trt","RCP","phase","source"), summarise,
#              cinx = mean(cinput),
#              tcx = mean(somtc),
#              N = length(time))

gif_summary = gif_data[,list(cinx = mean(cinput),
                             tcx = mean(somtc),
                             N = length(time)),
                      by=list(year,site,trt,RCP,phase,source)]

gif_summary = as.data.frame(gif_summary)

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

graphdf = ddply(gif_summary, c("site","trt","RCP","phase","source"), summarise,
              cin = sum(cinx),
              tc = last(tcx)-first(tcx),
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

### PLOT THE RESULTING FIGURES

# Create generic plotting function to simplify all future code
pltfunc = function(pltdf, xvar, yvar, pchvar=NULL, colvar=NULL, linevar=NULL, pchnme=NULL, colnme=NULL, linenme=NULL) {
  baseplot = ggplot(pltdf, aes_string(x=xvar, y=yvar)) +
    scale_y_continuous(expand=c(0,0), limits=c(ylimdwn*0.95,ylimup*1.05)) +
    scale_x_continuous(expand=c(0,0), limits=c(xlimdwn*0.95,xlimup*1.05)) +
    xlab(xlabel) +
    ylab(ylabel) +
    facet_wrap(as.formula(paste("~", facets))) +
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
    scale_size(guide=F)
  if(is.null(colvar)) {
    if(is.null(pchvar)) {
      if(is.null(linevar)) {
        plotobj = baseplot +
          geom_point(size=pointsize, alpha=alphalev) +
          geom_smooth(method='lm', se=F)
      }
      plotobj = baseplot + 
        geom_point(size=pointsize, alpha=alphalev, aes_string(colour=colvar)) +
        geom_smooth(method='lm', se=F, aes_string(colour=colvar)) +
        scale_colour_manual(colnme, values = colours)
    }
    plotobj = baseplot + 
      geom_point(size=pointsize, alpha=alphalev, aes_string(colour=colvar, pch=pchvar)) +
      geom_smooth(method='lm', se=F, aes_string(colour=colvar, pch=pchvar)) +
      scale_shape_manual(pchnme, values = pchs) +
      scale_colour_manual(colnme, values = colours)
  }
  plotobj = baseplot + 
    geom_point(size=pointsize, alpha=alphalev, aes_string(colour=colvar, pch=pchvar, linetype=linevar)) +
    geom_smooth(method='lm', se=F, aes_string(colour=colvar, pch=pchvar, linetype=linevar)) +
    scale_shape_manual(pchnme, values = pchs) +
    scale_colour_manual(colnme, values = colours) +
    scale_linetype_manual(linenme, values = linetypes)
  if(ylimdwn < 0) {
    plotobj = plotobj +
      geom_hline(yintercept = 0, linetype = 'dotted')
  }
  return(plotobj)
}

# Example of above function in use
# pltfunc(dataframe, xvar="cin", yvar="tc", colvar="trt", pchvar="site", linevar="RCP", pchnme="Site", colnme="Treatment", linenme="RCP Scenario")
# Also requires discrete values for pch/colour/linetypes, limits of axes, axis labels and facet variable(s)

xvar = "cin"
yvar = "tc"
xlabel = expression(paste("Average Total Inputs (gC ", m^-2,")")) # X-axis label based on variable of desire
ylabel = expression(paste("Average Total SOC Change (gC ", m^-2,")")) # Y-axis label based on variable of desire

colours = c("WF"="darkgreen","WCF"="firebrick2", # Colours specified for these figures
               "WCMF"="black","OPP"="cornflowerblue",
               "Grass"="darkorange2")
pchs = c("RCP 4.5"=15, "RCP 8.5"=17) # Shapes specified for these figures
linetypes = c("RCP 4.5"=1, "RCP 8.5"=2) # Linetypes specified for these figures
xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum
facets = "phase" # Facets chosen for this plot
alphalev = 0.8
pointsize = 3

phaseLIST = levels(as.factor(graphdf$phase))

plt_list = list()
for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = pltfunc(df,xvar=xvar, yvar=yvar, pchvar="RCP",colvar="trt",linevar="RCP",pchnme="RCP Scenario",colnme="Treatment",linenme="RCP Scenario")
  plt_list[[phs]] <- plt
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=200, dpi=100, units="mm")
}

pdf(file.path(figdir,"gif_pics","tc_cin.pdf"), width=7, height=4)
for (i in 1:length(plt_list)) {
  print(plt_list[[i]])
}
dev.off()

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired 
} 

# SAME AS ABOVE BUT USING ALL POINTS! - CHOOSE THE VARIABLES BY CHANGING LIST OBJECTS
# DDPLY CAN BE SLOW WORKING WITH LARGE DATA FRAMES SO USE DATA TABLE INSTEAD - should be the same output
#gif_summary = ddply(gif_data, c("site","slope","trt","treat","GCM","RCP","phase","source"), summarise,
#                    cin = sum(cinput),
#                    tc = last(somtc)-first(somtc),
#                    defac = mean(abgdefac),
#                    prc = sum(prcann),
#                    resp = sum(resp.1.),
#                    N = length(time))

gif_summary = gif_data[,list(cin = sum(cinput),
                              tc = last(somtc)-first(somtc),
                              defac = mean(abgdefac),
                              prc = sum(prcann),
                              resp = sum(resp.1.),
                              N = length(time)),
                        by=list(site,slope,treat,trt,GCM,RCP,phase,source)]

gif_summary = as.data.frame(gif_summary)

nrow(gif_summary[gif_summary$N!=12,]) # Check how many points aren't made up of 12 years (they should be!)
graphdf = gif_summary[gif_summary$N==12,] # Limit the dataframe to only those with 12 years of points

graphdf$RCP[graphdf$RCP=="RCP45"] = "RCP 4.5" # Just to be more correct in publishing
graphdf$RCP[graphdf$RCP=="RCP85"] = "RCP 8.5" # Just to be more correct in publishing

colours = c("WF"="darkgreen","WCF"="firebrick2", # Colours specified for these figures
            "WCMF"="black","OPP"="cornflowerblue",
            "Grass"="darkorange2")
pchs = c("Sterling"=15, "Stratton"=16, "Walsh"=17) # Shapes specified for these figures
xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum
facets = "phase*RCP" # Facets chosen for this plot
alphalev = 0.2
pointsize = 1

phaseLIST = levels(as.factor(graphdf$phase))

for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

# VISUALISE WITHOUT WCMF TREATMENT AND THEN WITHOUT WCF OR OPP

graphdf2 = graphdf[graphdf$trt!="WCMF",]

for(phs in phaseLIST) {
  df = graphdf2[graphdf2$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all_no_wcmf.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all_no_wcmf.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

graphdf3 = graphdf2[graphdf2$trt!="WCF",]

for(phs in phaseLIST) {
  df = graphdf3[graphdf3$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all_no_wcmf_or_wcf.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all_no_wcmf_or_wcf.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

graphdf3 = graphdf2[graphdf2$trt!="OPP",]

for(phs in phaseLIST) {
  df = graphdf3[graphdf3$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all_no_wcmf_or_opp.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all_no_wcmf_or_opp.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

# NO GRASS AND/OR NO WCMF
graphdf2 = graphdf[graphdf$trt!="Grass",]

for(phs in phaseLIST) {
  df = graphdf2[graphdf2$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all_no_grass.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all_no_grass.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

graphdf3 = graphdf2[graphdf2$trt!="WCMF",]

for(phs in phaseLIST) {
  df = graphdf3[graphdf3$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_tc_all_no_grass_or_wcmf.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_tc_all_no_grass_or_wcmf.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

### GRAPHING THE DECOMPOSITION FACTOR

xvar = "defac"
yvar = "tc"
xlabel = expression(paste("Average Decomposition Factor (0-1)")) # X-axis label based on variable of desire
ylabel = expression(paste("Average Total SOC Change (gC ", m^-2,")")) # Y-axis label based on variable of desire

colours = c("WF"="darkgreen","WCF"="firebrick2", # Colours specified for these figures
            "WCMF"="black","OPP"="cornflowerblue",
            "Grass"="darkorange2")
pchs = c("RCP 4.5"=15, "RCP 8.5"=17) # Shapes specified for these figures
linetypes = c("RCP 4.5"=1, "RCP 8.5"=2) # Linetypes specified for these figures
xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum
facets = "phase*RCP" # Facets chosen for this plot
alphalev = 0.2
pointsize = 1

for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png defac_vs_tc.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png defac_vs_tc.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

### GRAPHING CO2 EMISSIONS VS SOC

xvar = "resp"
yvar = "tc"
xlabel = expression(paste("Cumulative CO2 Emissions (gC ", m^-2,")")) # X-axis label based on variable of desire
ylabel = expression(paste("Average Total SOC Change (gC ", m^-2,")")) # Y-axis label based on variable of desire

xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum

for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png resp_vs_tc.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png resp_vs_tc.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 

### GRAPHING CO2 EMISSIONS VS C INPUTS

xvar = "cin"
yvar = "resp"

xlabel = expression(paste("Average Total Inputs (gC ", m^-2,")")) # X-axis label based on variable of desire
ylabel = expression(paste("Cumulative CO2 Emissions (gC ", m^-2,")")) # Y-axis label based on variable of desire

xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum

for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_resp.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_resp.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 


### GRAPHING PRECIPITATION VS C INPUTS

xvar = "cin"
yvar = "prc"
xlabel = expression(paste("Average Total Inputs (gC ", m^-2,")")) # X-axis label based on variable of desire
ylabel = expression(paste("Cumulative precipitation (cm)")) # Y-axis label based on variable of desire

xlimup = max(graphdf[[xvar]]) # Dataframe-specific x-axis maximum
xlimdwn = min(graphdf[[xvar]]) # Dataframe-specific x-axis minimum
ylimup = max(graphdf[[yvar]]) # Dataframe-specific y-axis maximum
ylimdwn = min(graphdf[[yvar]]) # Dataframe-specific y-axis minimum

for(phs in phaseLIST) {
  df = graphdf[graphdf$phase==phs,]
  plt = suppressWarnings(pltfunc(df,xvar=xvar,yvar=yvar,colvar="trt",colnme="Treatment"))
  ggsave(plt, file=file.path(figdir,"gif_pics",paste(phs,".png",sep="")), height=125, width=250, dpi=100, units="mm")
}

setwd(file.path(figdir,"gif_pics"))

if(Sys.info()["sysname"]=="Windows"){
  system('"C:/Program Files/ImageMagick-7.0.5-Q16/convert.exe" -delay 15 *.png cin_vs_prec.gif')
  #  system('del /p /s *.png') # Remove png files if desired
} else{
  system('convert -delay 15 *.png cin_vs_prec.gif')
  #  system("find . -type f -iname '*.png' -delete") # Remove png files if desired
} 
