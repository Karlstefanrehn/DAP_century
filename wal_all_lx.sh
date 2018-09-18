### THIS SHELL SCRIPT RUNS ROTATIONS 1,3,6,10 AND 11 ON ALL SLOPES AT THE STERLING DAP SITE
#
# All simulations are run in the "sims" folder that corresponds to each site. After running
# the simulation outputs are moved into a separate folder in "Outputs/..." before all files
# in the "sims" folder are deleted. Outputs of interest were limited so only include some
# (summary.out / year_summary.out / harvest.csv / dc_sip.csv / soiln.out / vswc.out)

#!/bin/bash

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sims/wal_sims
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sims/wal_sims
cp -a /media/andy/Modelling/DAP_files/sch_files/wal_*.* /media/andy/Modelling/DAP_files/sims/wal_sims
cp -a /media/andy/Modelling/DAP_files/spin_base_sch/wal_*.* /media/andy/Modelling/DAP_files/sims/wal_sims
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sims/wal_sims
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sims/wal_sims
    
if [ -d "/media/andy/Modelling/Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/"
fi
    
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/"
fi
    
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/"
fi
    
rm -r /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/*
   
rm *.bin
rm *.out
rm *.lis
rm *.csv

cd /media/andy/Modelling/DAP_files/sims/wal_sims

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

cp summit.in soils.in
cp summit_site.100 site.100

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

./DDcentEVI -s grass -n grass -e base
./DDClist100 grass grass outvars.txt

cp summary.out grass_summary.out
cp year_summary.out grass_year_summary.out
cp harvest.csv grass_harvest.csv
cp dc_sip.csv grass_dc_sip.csv
cp soiln.out grass_soiln.out
cp vswc.out grass_vswc.out

cp rot10_summit.sch opp.sch
./DDcentEVI -s opp -n opp -e base
./DDClist100 opp opp outvars.txt

cp summary.out opp_summary.out 
cp year_summary.out opp_year_summary.out
cp harvest.csv opp_harvest.csv
cp dc_sip.csv opp_dc_sip.csv
cp soiln.out opp_soiln.out
cp vswc.out opp_vswc.out

cp rot9_summit.sch fwcm.sch
./DDcentEVI -s fwcm -n fwcm -e base 
./DDClist100 fwcm fwcm outvars.txt

cp summary.out fwcm_summary.out 
cp year_summary.out fwcm_year_summary.out
cp harvest.csv fwcm_harvest.csv
cp dc_sip.csv fwcm_dc_sip.csv
cp soiln.out fwcm_soiln.out
cp vswc.out fwcm_vswc.out

cp rot8_summit.sch mfwc.sch
./DDcentEVI -s mfwc -n mfwc -e base 
./DDClist100 mfwc mfwc outvars.txt

cp summary.out mfwc_summary.out 
cp year_summary.out mfwc_year_summary.out
cp harvest.csv mfwc_harvest.csv
cp dc_sip.csv mfwc_dc_sip.csv
cp soiln.out mfwc_soiln.out
cp vswc.out mfwc_vswc.out

cp rot7_summit.sch cmfw.sch
./DDcentEVI -s cmfw -n cmfw -e base 
./DDClist100 cmfw cmfw outvars.txt

cp summary.out cmfw_summary.out 
cp year_summary.out cmfw_year_summary.out
cp harvest.csv cmfw_harvest.csv
cp dc_sip.csv cmfw_dc_sip.csv
cp soiln.out cmfw_soiln.out
cp vswc.out cmfw_vswc.out

cp rot6_summit.sch wcmf.sch
./DDcentEVI -s wcmf -n wcmf -e base 
./DDClist100 wcmf wcmf outvars.txt

cp summary.out wcmf_summary.out 
cp year_summary.out wcmf_year_summary.out
cp harvest.csv wcmf_harvest.csv
cp dc_sip.csv wcmf_dc_sip.csv
cp soiln.out wcmf_soiln.out
cp vswc.out wcmf_vswc.out

cp rot5_summit.sch fwc.sch
./DDcentEVI -s fwc -n fwc -e base 
./DDClist100 fwc fwc outvars.txt

cp summary.out fwc_summary.out 
cp year_summary.out fwc_year_summary.out
cp harvest.csv fwc_harvest.csv
cp dc_sip.csv fwc_dc_sip.csv
cp soiln.out fwc_soiln.out
cp vswc.out fwc_vswc.out

cp rot4_summit.sch cfw.sch
./DDcentEVI -s cfw -n cfw -e base 
./DDClist100 cfw cfw outvars.txt

cp summary.out cfw_summary.out 
cp year_summary.out cfw_year_summary.out
cp harvest.csv cfw_harvest.csv
cp dc_sip.csv cfw_dc_sip.csv
cp soiln.out cfw_soiln.out
cp vswc.out cfw_vswc.out

cp rot3_summit.sch wcf.sch
./DDcentEVI -s wcf -n wcf -e base 
./DDClist100 wcf wcf outvars.txt

cp summary.out wcf_summary.out 
cp year_summary.out wcf_year_summary.out
cp harvest.csv wcf_harvest.csv
cp dc_sip.csv wcf_dc_sip.csv
cp soiln.out wcf_soiln.out
cp vswc.out wcf_vswc.out

cp rot2_summit.sch fw.sch
./DDcentEVI -s fw -n fw -e base 
./DDClist100 fw fw outvars.txt

cp summary.out fw_summary.out 
cp year_summary.out fw_year_summary.out
cp harvest.csv fw_harvest.csv	
cp dc_sip.csv fw_dc_sip.csv	
cp soiln.out fw_soiln.out
cp vswc.out fw_vswc.out

cp rot1_summit.sch wf.sch
./DDcentEVI -s wf -n wf -e base 
./DDClist100 wf wf outvars.txt

cp summary.out wf_summary.out 
cp year_summary.out wf_year_summary.out
cp harvest.csv wf_harvest.csv	
cp dc_sip.csv wf_dc_sip.csv	
cp soiln.out wf_soiln.out
cp vswc.out wf_vswc.out

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

for f in *.bin; do mv "$f" "wal_summit_$f"; done
for f in *.lis; do mv "$f" "wal_summit_$f"; done
for f in *.out; do mv "$f" "wal_summit_$f"; done
for f in *.csv; do mv "$f" "wal_summit_$f"; done

mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.bin /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.lis /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.out /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.csv /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_summit_output/




if [ -d "/media/andy/Modelling/Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/"
fi

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/"
fi

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/*

rm *.bin
rm *.out
rm *.lis
rm *.csv

cp side.in soils.in
cp side_site.100 site.100

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

./DDcentEVI -s grass -n grass -e base
./DDClist100 grass grass outvars.txt

cp summary.out grass_summary.out
cp year_summary.out grass_year_summary.out
cp harvest.csv grass_harvest.csv
cp dc_sip.csv grass_dc_sip.csv
cp soiln.out grass_soiln.out
cp vswc.out grass_vswc.out

cp rot10_side.sch opp.sch
./DDcentEVI -s opp -n opp -e base
./DDClist100 opp opp outvars.txt

cp summary.out opp_summary.out 
cp year_summary.out opp_year_summary.out
cp harvest.csv opp_harvest.csv
cp dc_sip.csv opp_dc_sip.csv
cp soiln.out opp_soiln.out
cp vswc.out opp_vswc.out

cp rot9_side.sch fwcm.sch
./DDcentEVI -s fwcm -n fwcm -e base 
./DDClist100 fwcm fwcm outvars.txt

cp summary.out fwcm_summary.out 
cp year_summary.out fwcm_year_summary.out
cp harvest.csv fwcm_harvest.csv
cp dc_sip.csv fwcm_dc_sip.csv
cp soiln.out fwcm_soiln.out
cp vswc.out fwcm_vswc.out

cp rot8_side.sch mfwc.sch
./DDcentEVI -s mfwc -n mfwc -e base 
./DDClist100 mfwc mfwc outvars.txt

cp summary.out mfwc_summary.out 
cp year_summary.out mfwc_year_summary.out
cp harvest.csv mfwc_harvest.csv
cp dc_sip.csv mfwc_dc_sip.csv
cp soiln.out mfwc_soiln.out
cp vswc.out mfwc_vswc.out

cp rot7_side.sch cmfw.sch
./DDcentEVI -s cmfw -n cmfw -e base 
./DDClist100 cmfw cmfw outvars.txt

cp summary.out cmfw_summary.out 
cp year_summary.out cmfw_year_summary.out
cp harvest.csv cmfw_harvest.csv
cp dc_sip.csv cmfw_dc_sip.csv
cp soiln.out cmfw_soiln.out
cp vswc.out cmfw_vswc.out

cp rot6_side.sch wcmf.sch
./DDcentEVI -s wcmf -n wcmf -e base 
./DDClist100 wcmf wcmf outvars.txt

cp summary.out wcmf_summary.out 
cp year_summary.out wcmf_year_summary.out
cp harvest.csv wcmf_harvest.csv
cp dc_sip.csv wcmf_dc_sip.csv
cp soiln.out wcmf_soiln.out
cp vswc.out wcmf_vswc.out

cp rot5_side.sch fwc.sch
./DDcentEVI -s fwc -n fwc -e base 
./DDClist100 fwc fwc outvars.txt

cp summary.out fwc_summary.out 
cp year_summary.out fwc_year_summary.out
cp harvest.csv fwc_harvest.csv
cp dc_sip.csv fwc_dc_sip.csv
cp soiln.out fwc_soiln.out
cp vswc.out fwc_vswc.out

cp rot4_side.sch cfw.sch
./DDcentEVI -s cfw -n cfw -e base 
./DDClist100 cfw cfw outvars.txt

cp summary.out cfw_summary.out 
cp year_summary.out cfw_year_summary.out
cp harvest.csv cfw_harvest.csv
cp dc_sip.csv cfw_dc_sip.csv
cp soiln.out cfw_soiln.out
cp vswc.out cfw_vswc.out

cp rot3_side.sch wcf.sch
./DDcentEVI -s wcf -n wcf -e base 
./DDClist100 wcf wcf outvars.txt

cp summary.out wcf_summary.out 
cp year_summary.out wcf_year_summary.out
cp harvest.csv wcf_harvest.csv
cp dc_sip.csv wcf_dc_sip.csv
cp soiln.out wcf_soiln.out
cp vswc.out wcf_vswc.out

cp rot2_side.sch fw.sch
./DDcentEVI -s fw -n fw -e base 
./DDClist100 fw fw outvars.txt

cp summary.out fw_summary.out 
cp year_summary.out fw_year_summary.out
cp harvest.csv fw_harvest.csv	
cp dc_sip.csv fw_dc_sip.csv	
cp soiln.out fw_soiln.out
cp vswc.out fw_vswc.out

cp rot1_side.sch wf.sch
./DDcentEVI -s wf -n wf -e base 
./DDClist100 wf wf outvars.txt

cp summary.out wf_summary.out 
cp year_summary.out wf_year_summary.out
cp harvest.csv wf_harvest.csv	
cp dc_sip.csv wf_dc_sip.csv	
cp soiln.out wf_soiln.out
cp vswc.out wf_vswc.out

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

for f in *.bin; do mv "$f" "wal_side_$f"; done
for f in *.lis; do mv "$f" "wal_side_$f"; done
for f in *.out; do mv "$f" "wal_side_$f"; done
for f in *.csv; do mv "$f" "wal_side_$f"; done

mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.bin /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.lis /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.out /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.csv /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_side_output/




if [ -d "/media/andy/Modelling/Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/"
fi

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/"
fi

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/*

rm *.bin
rm *.out
rm *.lis
rm *.csv

cp toe.in soils.in
cp toe_site.100 site.100

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

./DDcentEVI -s grass -n grass -e base
./DDClist100 grass grass outvars.txt

cp summary.out grass_summary.out
cp year_summary.out grass_year_summary.out
cp harvest.csv grass_harvest.csv
cp dc_sip.csv grass_dc_sip.csv
cp soiln.out grass_soiln.out
cp vswc.out grass_vswc.out

cp rot10_toe.sch opp.sch
./DDcentEVI -s opp -n opp -e base
./DDClist100 opp opp outvars.txt

cp summary.out opp_summary.out 
cp year_summary.out opp_year_summary.out
cp harvest.csv opp_harvest.csv
cp dc_sip.csv opp_dc_sip.csv
cp soiln.out opp_soiln.out
cp vswc.out opp_vswc.out

cp rot9_toe.sch fwcm.sch
./DDcentEVI -s fwcm -n fwcm -e base 
./DDClist100 fwcm fwcm outvars.txt

cp summary.out fwcm_summary.out 
cp year_summary.out fwcm_year_summary.out
cp harvest.csv fwcm_harvest.csv
cp dc_sip.csv fwcm_dc_sip.csv
cp soiln.out fwcm_soiln.out
cp vswc.out fwcm_vswc.out

cp rot8_toe.sch mfwc.sch
./DDcentEVI -s mfwc -n mfwc -e base 
./DDClist100 mfwc mfwc outvars.txt

cp summary.out mfwc_summary.out 
cp year_summary.out mfwc_year_summary.out
cp harvest.csv mfwc_harvest.csv
cp dc_sip.csv mfwc_dc_sip.csv
cp soiln.out mfwc_soiln.out
cp vswc.out mfwc_vswc.out

cp rot7_toe.sch cmfw.sch
./DDcentEVI -s cmfw -n cmfw -e base 
./DDClist100 cmfw cmfw outvars.txt

cp summary.out cmfw_summary.out 
cp year_summary.out cmfw_year_summary.out
cp harvest.csv cmfw_harvest.csv
cp dc_sip.csv cmfw_dc_sip.csv
cp soiln.out cmfw_soiln.out
cp vswc.out cmfw_vswc.out

cp rot6_toe.sch wcmf.sch
./DDcentEVI -s wcmf -n wcmf -e base 
./DDClist100 wcmf wcmf outvars.txt

cp summary.out wcmf_summary.out 
cp year_summary.out wcmf_year_summary.out
cp harvest.csv wcmf_harvest.csv
cp dc_sip.csv wcmf_dc_sip.csv
cp soiln.out wcmf_soiln.out
cp vswc.out wcmf_vswc.out

cp rot5_toe.sch fwc.sch
./DDcentEVI -s fwc -n fwc -e base 
./DDClist100 fwc fwc outvars.txt

cp summary.out fwc_summary.out 
cp year_summary.out fwc_year_summary.out
cp harvest.csv fwc_harvest.csv
cp dc_sip.csv fwc_dc_sip.csv
cp soiln.out fwc_soiln.out
cp vswc.out fwc_vswc.out

cp rot4_toe.sch cfw.sch
./DDcentEVI -s cfw -n cfw -e base 
./DDClist100 cfw cfw outvars.txt

cp summary.out cfw_summary.out 
cp year_summary.out cfw_year_summary.out
cp harvest.csv cfw_harvest.csv
cp dc_sip.csv cfw_dc_sip.csv
cp soiln.out cfw_soiln.out
cp vswc.out cfw_vswc.out

cp rot3_toe.sch wcf.sch
./DDcentEVI -s wcf -n wcf -e base 
./DDClist100 wcf wcf outvars.txt

cp summary.out wcf_summary.out 
cp year_summary.out wcf_year_summary.out
cp harvest.csv wcf_harvest.csv
cp dc_sip.csv wcf_dc_sip.csv
cp soiln.out wcf_soiln.out
cp vswc.out wcf_vswc.out

cp rot2_toe.sch fw.sch
./DDcentEVI -s fw -n fw -e base 
./DDClist100 fw fw outvars.txt

cp summary.out fw_summary.out 
cp year_summary.out fw_year_summary.out
cp harvest.csv fw_harvest.csv	
cp dc_sip.csv fw_dc_sip.csv	
cp soiln.out fw_soiln.out
cp vswc.out fw_vswc.out

cp rot1_toe.sch wf.sch
./DDcentEVI -s wf -n wf -e base 
./DDClist100 wf wf outvars.txt

cp summary.out wf_summary.out 
cp year_summary.out wf_year_summary.out
cp harvest.csv wf_harvest.csv	
cp dc_sip.csv wf_dc_sip.csv	
cp soiln.out wf_soiln.out
cp vswc.out wf_vswc.out

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

for f in *.bin; do mv "$f" "wal_toe_$f"; done
for f in *.lis; do mv "$f" "wal_toe_$f"; done
for f in *.out; do mv "$f" "wal_toe_$f"; done
for f in *.csv; do mv "$f" "wal_toe_$f"; done

mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.bin /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.lis /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.out /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/
mv /media/andy/Modelling/DAP_files/sims/wal_sims/*.csv /media/andy/Modelling/Outputs/LAI_LX_Outputs/wal_toe_output/


find -maxdepth 1 -type f -delete
