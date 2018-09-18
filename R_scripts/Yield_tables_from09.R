# --------------------------------------------------------------------------------------------------------#
### PRODUCES FIGURES AND A TABLE SHOWING GRAIN AND STOVER SIMULATED YIELDS AND CINPUT TO SOIL 2009-2100 ###
# --------------------------------------------------------------------------------------------------------#

# Used in conjunction with MasterScript - see that file for more detail

### NOTE - This will throw errors if you haven't already run the Cin_figures and Yield_figures scripts
# These scripts should save the all.all object to your environment. If not, you can load from Robjsdir

### USING THE SAME FORMAT AS PRE-2009 TABLE (USEFUL FOR PUBLICATION)

new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="1986 - 1997",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz)
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="1998 - 2009",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2010 - 2021",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2022 - 2033",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2034 - 2045",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2046 - 2057",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2058 - 2069",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2070 - 2081",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))
new = all.all[all.all$RCP=="RCP45"&all.all$source!="Measured",]
new = new[new$rot_phs=="2082 - 2093",]
cum = paste(formatC(round(new$cum.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$cum.se,0),format="f",digits=0), sep="")
anlz = paste(formatC(round(new$anlz.mean,0),format="f",digits=0), " \u00b1 ", formatC(round(new$anlz.se,0),format="f",digits=0), sep="")
table.all = rbind(table.all, data.frame(Phase=new[,'rot_phs'],Rotation=new[,'trt'],Variable=new[,'type'],Cumulative=cum,Annualized=anlz))

write.csv(table.all, file=file.path(figdir, "Modelled_C_table.csv"))
