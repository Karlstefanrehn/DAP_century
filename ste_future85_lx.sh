### THIS SHELL SCRIPT RUNS ROTATIONS 1,3,6,10 AND 11 ON ALL SLOPES AT THE STERLING DAP SITE
### ALL FUTURE SIMULATIONS FOR ALL COMBINATIONS OF WF, WCF AND WCMF ARE THEN EXTENDED FROM THIS
#
# All simulations are run in the "sims" folder that corresponds to each site. After running
# the simulation outputs are moved into a separate folder in "Outputs/..." before all files
# in the "sims" folder are deleted. Outputs of interest were limited so only include some
# (summary.out / year_summary.out / harvest.csv / dc_sip.csv / soiln.out / vswc.out)

#!/bin/bash

if [ -d "/media/andy/Modelling/DAP_files/future_sims/ste_sims85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/future_sims/ste_sims85/"
fi

rm -r /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/sch_files/ste_*.* /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/future_sch/ste_*.* /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/spin_base_sch/ste_*.* /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/wth_files/Future/ste_*_rcp85.wth /media/andy/Modelling/DAP_files/future_sims/ste_sims85
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/future_sims/ste_sims85
    
if [ -d "/media/andy/Modelling/Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/"
fi
    
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/"
fi
    
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/"
fi
  
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/*
   
rm *.bin
rm *.out
rm *.lis
rm *.csv

cd /media/andy/Modelling/DAP_files/future_sims/ste_sims85

rm outfiles.in
rm outvars.txt
cp future_outfiles.in outfiles.in
cp future_outvars.txt outvars.txt

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

cp summit.in soils.in

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

cp rot1_summit.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11m_wf.lis 
cp summary.out bcc_csm11m_wf_summary.out 
cp year_summary.out bcc_csm11m_wf_year_summary.out
cp harvest.csv bcc_csm11m_wf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wf_dc_sip.csv	
cp soiln.out bcc_csm11m_wf_soiln.out
cp vswc.out bcc_csm11m_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11_wf.lis 
cp summary.out bcc_csm11_wf_summary.out 
cp year_summary.out bcc_csm11_wf_year_summary.out
cp harvest.csv bcc_csm11_wf_harvest.csv	
cp dc_sip.csv bcc_csm11_wf_dc_sip.csv	
cp soiln.out bcc_csm11_wf_soiln.out
cp vswc.out bcc_csm11_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis BNU_wf.lis 
cp summary.out BNU_wf_summary.out 
cp year_summary.out BNU_wf_year_summary.out
cp harvest.csv BNU_wf_harvest.csv	
cp dc_sip.csv BNU_wf_dc_sip.csv	
cp soiln.out BNU_wf_soiln.out
cp vswc.out BNU_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CanESM2_wf.lis 
cp summary.out CanESM2_wf_summary.out 
cp year_summary.out CanESM2_wf_year_summary.out
cp harvest.csv CanESM2_wf_harvest.csv	
cp dc_sip.csv CanESM2_wf_dc_sip.csv	
cp soiln.out CanESM2_wf_soiln.out
cp vswc.out CanESM2_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CNRM_wf.lis 
cp summary.out CNRM_wf_summary.out 
cp year_summary.out CNRM_wf_year_summary.out
cp harvest.csv CNRM_wf_harvest.csv	
cp dc_sip.csv CNRM_wf_dc_sip.csv	
cp soiln.out CNRM_wf_soiln.out
cp vswc.out CNRM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CSIRO_wf.lis 
cp summary.out CSIRO_wf_summary.out 
cp year_summary.out CSIRO_wf_year_summary.out
cp harvest.csv CSIRO_wf_harvest.csv	
cp dc_sip.csv CSIRO_wf_dc_sip.csv	
cp soiln.out CSIRO_wf_soiln.out
cp vswc.out CSIRO_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2G_wf.lis 
cp summary.out GFDL_ESM2G_wf_summary.out 
cp year_summary.out GFDL_ESM2G_wf_year_summary.out
cp harvest.csv GFDL_ESM2G_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wf_soiln.out
cp vswc.out GFDL_ESM2G_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2M_wf.lis 
cp summary.out GFDL_ESM2M_wf_summary.out 
cp year_summary.out GFDL_ESM2M_wf_year_summary.out
cp harvest.csv GFDL_ESM2M_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wf_soiln.out
cp vswc.out GFDL_ESM2M_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_CC_wf.lis 
cp summary.out HadGEM2_CC_wf_summary.out 
cp year_summary.out HadGEM2_CC_wf_year_summary.out
cp harvest.csv HadGEM2_CC_wf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wf_soiln.out
cp vswc.out HadGEM2_CC_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_ES_wf.lis 
cp summary.out HadGEM2_ES_wf_summary.out 
cp year_summary.out HadGEM2_ES_wf_year_summary.out
cp harvest.csv HadGEM2_ES_wf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wf_soiln.out
cp vswc.out HadGEM2_ES_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis inmcm4_wf.lis 
cp summary.out inmcm4_wf_summary.out 
cp year_summary.out inmcm4_wf_year_summary.out
cp harvest.csv inmcm4_wf_harvest.csv	
cp dc_sip.csv inmcm4_wf_dc_sip.csv	
cp soiln.out inmcm4_wf_soiln.out
cp vswc.out inmcm4_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5ALR_wf.lis 
cp summary.out IPSL_CM5ALR_wf_summary.out 
cp year_summary.out IPSL_CM5ALR_wf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wf_soiln.out
cp vswc.out IPSL_CM5ALR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5BLR_wf.lis 
cp summary.out IPSL_CM5BLR_wf_summary.out 
cp year_summary.out IPSL_CM5BLR_wf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wf_soiln.out
cp vswc.out IPSL_CM5BLR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC5_wf.lis 
cp summary.out MIROC5_wf_summary.out 
cp year_summary.out MIROC5_wf_year_summary.out
cp harvest.csv MIROC5_wf_harvest.csv	
cp dc_sip.csv MIROC5_wf_dc_sip.csv	
cp soiln.out MIROC5_wf_soiln.out
cp vswc.out MIROC5_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC_CHEM_wf.lis 
cp summary.out MIROC_CHEM_wf_summary.out 
cp year_summary.out MIROC_CHEM_wf_year_summary.out
cp harvest.csv MIROC_CHEM_wf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wf_soiln.out
cp vswc.out MIROC_CHEM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MRI_CGCM3_wf.lis 
cp summary.out MRI_CGCM3_wf_summary.out 
cp year_summary.out MRI_CGCM3_wf_year_summary.out
cp harvest.csv MRI_CGCM3_wf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wf_soiln.out
cp vswc.out MRI_CGCM3_wf_vswc.out

rm wf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11m_fw.lis 
cp summary.out bcc_csm11m_fw_summary.out 
cp year_summary.out bcc_csm11m_fw_year_summary.out
cp harvest.csv bcc_csm11m_fw_harvest.csv	
cp dc_sip.csv bcc_csm11m_fw_dc_sip.csv	
cp soiln.out bcc_csm11m_fw_soiln.out
cp vswc.out bcc_csm11m_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11_fw.lis 
cp summary.out bcc_csm11_fw_summary.out 
cp year_summary.out bcc_csm11_fw_year_summary.out
cp harvest.csv bcc_csm11_fw_harvest.csv	
cp dc_sip.csv bcc_csm11_fw_dc_sip.csv	
cp soiln.out bcc_csm11_fw_soiln.out
cp vswc.out bcc_csm11_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis BNU_fw.lis 
cp summary.out BNU_fw_summary.out 
cp year_summary.out BNU_fw_year_summary.out
cp harvest.csv BNU_fw_harvest.csv	
cp dc_sip.csv BNU_fw_dc_sip.csv	
cp soiln.out BNU_fw_soiln.out
cp vswc.out BNU_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CanESM2_fw.lis 
cp summary.out CanESM2_fw_summary.out 
cp year_summary.out CanESM2_fw_year_summary.out
cp harvest.csv CanESM2_fw_harvest.csv	
cp dc_sip.csv CanESM2_fw_dc_sip.csv	
cp soiln.out CanESM2_fw_soiln.out
cp vswc.out CanESM2_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CNRM_fw.lis 
cp summary.out CNRM_fw_summary.out 
cp year_summary.out CNRM_fw_year_summary.out
cp harvest.csv CNRM_fw_harvest.csv	
cp dc_sip.csv CNRM_fw_dc_sip.csv	
cp soiln.out CNRM_fw_soiln.out
cp vswc.out CNRM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CSIRO_fw.lis 
cp summary.out CSIRO_fw_summary.out 
cp year_summary.out CSIRO_fw_year_summary.out
cp harvest.csv CSIRO_fw_harvest.csv	
cp dc_sip.csv CSIRO_fw_dc_sip.csv	
cp soiln.out CSIRO_fw_soiln.out
cp vswc.out CSIRO_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2G_fw.lis 
cp summary.out GFDL_ESM2G_fw_summary.out 
cp year_summary.out GFDL_ESM2G_fw_year_summary.out
cp harvest.csv GFDL_ESM2G_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fw_soiln.out
cp vswc.out GFDL_ESM2G_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2M_fw.lis 
cp summary.out GFDL_ESM2M_fw_summary.out 
cp year_summary.out GFDL_ESM2M_fw_year_summary.out
cp harvest.csv GFDL_ESM2M_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fw_soiln.out
cp vswc.out GFDL_ESM2M_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_CC_fw.lis 
cp summary.out HadGEM2_CC_fw_summary.out 
cp year_summary.out HadGEM2_CC_fw_year_summary.out
cp harvest.csv HadGEM2_CC_fw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fw_dc_sip.csv	
cp soiln.out HadGEM2_CC_fw_soiln.out
cp vswc.out HadGEM2_CC_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_ES_fw.lis 
cp summary.out HadGEM2_ES_fw_summary.out 
cp year_summary.out HadGEM2_ES_fw_year_summary.out
cp harvest.csv HadGEM2_ES_fw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fw_dc_sip.csv	
cp soiln.out HadGEM2_ES_fw_soiln.out
cp vswc.out HadGEM2_ES_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis inmcm4_fw.lis 
cp summary.out inmcm4_fw_summary.out 
cp year_summary.out inmcm4_fw_year_summary.out
cp harvest.csv inmcm4_fw_harvest.csv	
cp dc_sip.csv inmcm4_fw_dc_sip.csv	
cp soiln.out inmcm4_fw_soiln.out
cp vswc.out inmcm4_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5ALR_fw.lis 
cp summary.out IPSL_CM5ALR_fw_summary.out 
cp year_summary.out IPSL_CM5ALR_fw_year_summary.out
cp harvest.csv IPSL_CM5ALR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fw_soiln.out
cp vswc.out IPSL_CM5ALR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5BLR_fw.lis 
cp summary.out IPSL_CM5BLR_fw_summary.out 
cp year_summary.out IPSL_CM5BLR_fw_year_summary.out
cp harvest.csv IPSL_CM5BLR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fw_soiln.out
cp vswc.out IPSL_CM5BLR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC5_fw.lis 
cp summary.out MIROC5_fw_summary.out 
cp year_summary.out MIROC5_fw_year_summary.out
cp harvest.csv MIROC5_fw_harvest.csv	
cp dc_sip.csv MIROC5_fw_dc_sip.csv	
cp soiln.out MIROC5_fw_soiln.out
cp vswc.out MIROC5_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC_CHEM_fw.lis 
cp summary.out MIROC_CHEM_fw_summary.out 
cp year_summary.out MIROC_CHEM_fw_year_summary.out
cp harvest.csv MIROC_CHEM_fw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fw_dc_sip.csv	
cp soiln.out MIROC_CHEM_fw_soiln.out
cp vswc.out MIROC_CHEM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MRI_CGCM3_fw.lis 
cp summary.out MRI_CGCM3_fw_summary.out 
cp year_summary.out MRI_CGCM3_fw_year_summary.out
cp harvest.csv MRI_CGCM3_fw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fw_dc_sip.csv	
cp soiln.out MRI_CGCM3_fw_soiln.out
cp vswc.out MRI_CGCM3_fw_vswc.out

rm fw.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_summit_$f"; done
for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-FALLOW ROTATION FOR SUMMITS

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/*
   
cd /media/andy/Modelling/DAP_files/future_sims/ste_sims85

cp base.1 base.bin
cp spin.1 spin.bin

cp rot3_summit.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11m_wcf.lis 
cp summary.out bcc_csm11m_wcf_summary.out 
cp year_summary.out bcc_csm11m_wcf_year_summary.out
cp harvest.csv bcc_csm11m_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcf_soiln.out
cp vswc.out bcc_csm11m_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11_wcf.lis 
cp summary.out bcc_csm11_wcf_summary.out 
cp year_summary.out bcc_csm11_wcf_year_summary.out
cp harvest.csv bcc_csm11_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcf_dc_sip.csv	
cp soiln.out bcc_csm11_wcf_soiln.out
cp vswc.out bcc_csm11_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis BNU_wcf.lis 
cp summary.out BNU_wcf_summary.out 
cp year_summary.out BNU_wcf_year_summary.out
cp harvest.csv BNU_wcf_harvest.csv	
cp dc_sip.csv BNU_wcf_dc_sip.csv	
cp soiln.out BNU_wcf_soiln.out
cp vswc.out BNU_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CanESM2_wcf.lis 
cp summary.out CanESM2_wcf_summary.out 
cp year_summary.out CanESM2_wcf_year_summary.out
cp harvest.csv CanESM2_wcf_harvest.csv	
cp dc_sip.csv CanESM2_wcf_dc_sip.csv	
cp soiln.out CanESM2_wcf_soiln.out
cp vswc.out CanESM2_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CNRM_wcf.lis 
cp summary.out CNRM_wcf_summary.out 
cp year_summary.out CNRM_wcf_year_summary.out
cp harvest.csv CNRM_wcf_harvest.csv	
cp dc_sip.csv CNRM_wcf_dc_sip.csv	
cp soiln.out CNRM_wcf_soiln.out
cp vswc.out CNRM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CSIRO_wcf.lis 
cp summary.out CSIRO_wcf_summary.out 
cp year_summary.out CSIRO_wcf_year_summary.out
cp harvest.csv CSIRO_wcf_harvest.csv	
cp dc_sip.csv CSIRO_wcf_dc_sip.csv	
cp soiln.out CSIRO_wcf_soiln.out
cp vswc.out CSIRO_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2G_wcf.lis 
cp summary.out GFDL_ESM2G_wcf_summary.out 
cp year_summary.out GFDL_ESM2G_wcf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcf_soiln.out
cp vswc.out GFDL_ESM2G_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2M_wcf.lis 
cp summary.out GFDL_ESM2M_wcf_summary.out 
cp year_summary.out GFDL_ESM2M_wcf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcf_soiln.out
cp vswc.out GFDL_ESM2M_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_CC_wcf.lis 
cp summary.out HadGEM2_CC_wcf_summary.out 
cp year_summary.out HadGEM2_CC_wcf_year_summary.out
cp harvest.csv HadGEM2_CC_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcf_soiln.out
cp vswc.out HadGEM2_CC_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_ES_wcf.lis 
cp summary.out HadGEM2_ES_wcf_summary.out 
cp year_summary.out HadGEM2_ES_wcf_year_summary.out
cp harvest.csv HadGEM2_ES_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcf_soiln.out
cp vswc.out HadGEM2_ES_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis inmcm4_wcf.lis 
cp summary.out inmcm4_wcf_summary.out 
cp year_summary.out inmcm4_wcf_year_summary.out
cp harvest.csv inmcm4_wcf_harvest.csv	
cp dc_sip.csv inmcm4_wcf_dc_sip.csv	
cp soiln.out inmcm4_wcf_soiln.out
cp vswc.out inmcm4_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5ALR_wcf.lis 
cp summary.out IPSL_CM5ALR_wcf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcf_soiln.out
cp vswc.out IPSL_CM5ALR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5BLR_wcf.lis 
cp summary.out IPSL_CM5BLR_wcf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcf_soiln.out
cp vswc.out IPSL_CM5BLR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC5_wcf.lis 
cp summary.out MIROC5_wcf_summary.out 
cp year_summary.out MIROC5_wcf_year_summary.out
cp harvest.csv MIROC5_wcf_harvest.csv	
cp dc_sip.csv MIROC5_wcf_dc_sip.csv	
cp soiln.out MIROC5_wcf_soiln.out
cp vswc.out MIROC5_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC_CHEM_wcf.lis 
cp summary.out MIROC_CHEM_wcf_summary.out 
cp year_summary.out MIROC_CHEM_wcf_year_summary.out
cp harvest.csv MIROC_CHEM_wcf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcf_soiln.out
cp vswc.out MIROC_CHEM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MRI_CGCM3_wcf.lis 
cp summary.out MRI_CGCM3_wcf_summary.out 
cp year_summary.out MRI_CGCM3_wcf_year_summary.out
cp harvest.csv MRI_CGCM3_wcf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcf_soiln.out
cp vswc.out MRI_CGCM3_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11m_cfw.lis 
cp summary.out bcc_csm11m_cfw_summary.out 
cp year_summary.out bcc_csm11m_cfw_year_summary.out
cp harvest.csv bcc_csm11m_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cfw_soiln.out
cp vswc.out bcc_csm11m_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11_cfw.lis 
cp summary.out bcc_csm11_cfw_summary.out 
cp year_summary.out bcc_csm11_cfw_year_summary.out
cp harvest.csv bcc_csm11_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cfw_dc_sip.csv	
cp soiln.out bcc_csm11_cfw_soiln.out
cp vswc.out bcc_csm11_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis BNU_cfw.lis 
cp summary.out BNU_cfw_summary.out 
cp year_summary.out BNU_cfw_year_summary.out
cp harvest.csv BNU_cfw_harvest.csv	
cp dc_sip.csv BNU_cfw_dc_sip.csv	
cp soiln.out BNU_cfw_soiln.out
cp vswc.out BNU_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CanESM2_cfw.lis 
cp summary.out CanESM2_cfw_summary.out 
cp year_summary.out CanESM2_cfw_year_summary.out
cp harvest.csv CanESM2_cfw_harvest.csv	
cp dc_sip.csv CanESM2_cfw_dc_sip.csv	
cp soiln.out CanESM2_cfw_soiln.out
cp vswc.out CanESM2_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CNRM_cfw.lis 
cp summary.out CNRM_cfw_summary.out 
cp year_summary.out CNRM_cfw_year_summary.out
cp harvest.csv CNRM_cfw_harvest.csv	
cp dc_sip.csv CNRM_cfw_dc_sip.csv	
cp soiln.out CNRM_cfw_soiln.out
cp vswc.out CNRM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CSIRO_cfw.lis 
cp summary.out CSIRO_cfw_summary.out 
cp year_summary.out CSIRO_cfw_year_summary.out
cp harvest.csv CSIRO_cfw_harvest.csv	
cp dc_sip.csv CSIRO_cfw_dc_sip.csv	
cp soiln.out CSIRO_cfw_soiln.out
cp vswc.out CSIRO_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2G_cfw.lis 
cp summary.out GFDL_ESM2G_cfw_summary.out 
cp year_summary.out GFDL_ESM2G_cfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cfw_soiln.out
cp vswc.out GFDL_ESM2G_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2M_cfw.lis 
cp summary.out GFDL_ESM2M_cfw_summary.out 
cp year_summary.out GFDL_ESM2M_cfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cfw_soiln.out
cp vswc.out GFDL_ESM2M_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_CC_cfw.lis 
cp summary.out HadGEM2_CC_cfw_summary.out 
cp year_summary.out HadGEM2_CC_cfw_year_summary.out
cp harvest.csv HadGEM2_CC_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cfw_soiln.out
cp vswc.out HadGEM2_CC_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_ES_cfw.lis 
cp summary.out HadGEM2_ES_cfw_summary.out 
cp year_summary.out HadGEM2_ES_cfw_year_summary.out
cp harvest.csv HadGEM2_ES_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cfw_soiln.out
cp vswc.out HadGEM2_ES_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis inmcm4_cfw.lis 
cp summary.out inmcm4_cfw_summary.out 
cp year_summary.out inmcm4_cfw_year_summary.out
cp harvest.csv inmcm4_cfw_harvest.csv	
cp dc_sip.csv inmcm4_cfw_dc_sip.csv	
cp soiln.out inmcm4_cfw_soiln.out
cp vswc.out inmcm4_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5ALR_cfw.lis 
cp summary.out IPSL_CM5ALR_cfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cfw_soiln.out
cp vswc.out IPSL_CM5ALR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5BLR_cfw.lis 
cp summary.out IPSL_CM5BLR_cfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cfw_soiln.out
cp vswc.out IPSL_CM5BLR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC5_cfw.lis 
cp summary.out MIROC5_cfw_summary.out 
cp year_summary.out MIROC5_cfw_year_summary.out
cp harvest.csv MIROC5_cfw_harvest.csv	
cp dc_sip.csv MIROC5_cfw_dc_sip.csv	
cp soiln.out MIROC5_cfw_soiln.out
cp vswc.out MIROC5_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC_CHEM_cfw.lis 
cp summary.out MIROC_CHEM_cfw_summary.out 
cp year_summary.out MIROC_CHEM_cfw_year_summary.out
cp harvest.csv MIROC_CHEM_cfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cfw_soiln.out
cp vswc.out MIROC_CHEM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MRI_CGCM3_cfw.lis 
cp summary.out MRI_CGCM3_cfw_summary.out 
cp year_summary.out MRI_CGCM3_cfw_year_summary.out
cp harvest.csv MRI_CGCM3_cfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cfw_soiln.out
cp vswc.out MRI_CGCM3_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/"
fi

rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11m_fwc.lis 
cp summary.out bcc_csm11m_fwc_summary.out 
cp year_summary.out bcc_csm11m_fwc_year_summary.out
cp harvest.csv bcc_csm11m_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwc_dc_sip.csv	
cp soiln.out bcc_csm11m_fwc_soiln.out
cp vswc.out bcc_csm11m_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11_fwc.lis 
cp summary.out bcc_csm11_fwc_summary.out 
cp year_summary.out bcc_csm11_fwc_year_summary.out
cp harvest.csv bcc_csm11_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11_fwc_dc_sip.csv	
cp soiln.out bcc_csm11_fwc_soiln.out
cp vswc.out bcc_csm11_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis BNU_fwc.lis 
cp summary.out BNU_fwc_summary.out 
cp year_summary.out BNU_fwc_year_summary.out
cp harvest.csv BNU_fwc_harvest.csv	
cp dc_sip.csv BNU_fwc_dc_sip.csv	
cp soiln.out BNU_fwc_soiln.out
cp vswc.out BNU_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CanESM2_fwc.lis 
cp summary.out CanESM2_fwc_summary.out 
cp year_summary.out CanESM2_fwc_year_summary.out
cp harvest.csv CanESM2_fwc_harvest.csv	
cp dc_sip.csv CanESM2_fwc_dc_sip.csv	
cp soiln.out CanESM2_fwc_soiln.out
cp vswc.out CanESM2_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CNRM_fwc.lis 
cp summary.out CNRM_fwc_summary.out 
cp year_summary.out CNRM_fwc_year_summary.out
cp harvest.csv CNRM_fwc_harvest.csv	
cp dc_sip.csv CNRM_fwc_dc_sip.csv	
cp soiln.out CNRM_fwc_soiln.out
cp vswc.out CNRM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CSIRO_fwc.lis 
cp summary.out CSIRO_fwc_summary.out 
cp year_summary.out CSIRO_fwc_year_summary.out
cp harvest.csv CSIRO_fwc_harvest.csv	
cp dc_sip.csv CSIRO_fwc_dc_sip.csv	
cp soiln.out CSIRO_fwc_soiln.out
cp vswc.out CSIRO_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2G_fwc.lis 
cp summary.out GFDL_ESM2G_fwc_summary.out 
cp year_summary.out GFDL_ESM2G_fwc_year_summary.out
cp harvest.csv GFDL_ESM2G_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwc_soiln.out
cp vswc.out GFDL_ESM2G_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2M_fwc.lis 
cp summary.out GFDL_ESM2M_fwc_summary.out 
cp year_summary.out GFDL_ESM2M_fwc_year_summary.out
cp harvest.csv GFDL_ESM2M_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwc_soiln.out
cp vswc.out GFDL_ESM2M_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_CC_fwc.lis 
cp summary.out HadGEM2_CC_fwc_summary.out 
cp year_summary.out HadGEM2_CC_fwc_year_summary.out
cp harvest.csv HadGEM2_CC_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwc_soiln.out
cp vswc.out HadGEM2_CC_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_ES_fwc.lis 
cp summary.out HadGEM2_ES_fwc_summary.out 
cp year_summary.out HadGEM2_ES_fwc_year_summary.out
cp harvest.csv HadGEM2_ES_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwc_soiln.out
cp vswc.out HadGEM2_ES_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis inmcm4_fwc.lis 
cp summary.out inmcm4_fwc_summary.out 
cp year_summary.out inmcm4_fwc_year_summary.out
cp harvest.csv inmcm4_fwc_harvest.csv	
cp dc_sip.csv inmcm4_fwc_dc_sip.csv	
cp soiln.out inmcm4_fwc_soiln.out
cp vswc.out inmcm4_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5ALR_fwc.lis 
cp summary.out IPSL_CM5ALR_fwc_summary.out 
cp year_summary.out IPSL_CM5ALR_fwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwc_soiln.out
cp vswc.out IPSL_CM5ALR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5BLR_fwc.lis 
cp summary.out IPSL_CM5BLR_fwc_summary.out 
cp year_summary.out IPSL_CM5BLR_fwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwc_soiln.out
cp vswc.out IPSL_CM5BLR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC5_fwc.lis 
cp summary.out MIROC5_fwc_summary.out 
cp year_summary.out MIROC5_fwc_year_summary.out
cp harvest.csv MIROC5_fwc_harvest.csv	
cp dc_sip.csv MIROC5_fwc_dc_sip.csv	
cp soiln.out MIROC5_fwc_soiln.out
cp vswc.out MIROC5_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC_CHEM_fwc.lis 
cp summary.out MIROC_CHEM_fwc_summary.out 
cp year_summary.out MIROC_CHEM_fwc_year_summary.out
cp harvest.csv MIROC_CHEM_fwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwc_soiln.out
cp vswc.out MIROC_CHEM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MRI_CGCM3_fwc.lis 
cp summary.out MRI_CGCM3_fwc_summary.out 
cp year_summary.out MRI_CGCM3_fwc_year_summary.out
cp harvest.csv MRI_CGCM3_fwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwc_soiln.out
cp vswc.out MRI_CGCM3_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_summit_$f"; done
for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-MILLET-FALLOW ROTATION FOR SUMMITS

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/*
   
cd /media/andy/Modelling/DAP_files/future_sims/ste_sims85

cp spin.1 spin.bin
cp base.1 base.bin

cp rot6_summit.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11m_wcmf.lis 
cp summary.out bcc_csm11m_wcmf_summary.out 
cp year_summary.out bcc_csm11m_wcmf_year_summary.out
cp harvest.csv bcc_csm11m_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcmf_soiln.out
cp vswc.out bcc_csm11m_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11_wcmf.lis 
cp summary.out bcc_csm11_wcmf_summary.out 
cp year_summary.out bcc_csm11_wcmf_year_summary.out
cp harvest.csv bcc_csm11_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11_wcmf_soiln.out
cp vswc.out bcc_csm11_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis BNU_wcmf.lis 
cp summary.out BNU_wcmf_summary.out 
cp year_summary.out BNU_wcmf_year_summary.out
cp harvest.csv BNU_wcmf_harvest.csv	
cp dc_sip.csv BNU_wcmf_dc_sip.csv	
cp soiln.out BNU_wcmf_soiln.out
cp vswc.out BNU_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CanESM2_wcmf.lis 
cp summary.out CanESM2_wcmf_summary.out 
cp year_summary.out CanESM2_wcmf_year_summary.out
cp harvest.csv CanESM2_wcmf_harvest.csv	
cp dc_sip.csv CanESM2_wcmf_dc_sip.csv	
cp soiln.out CanESM2_wcmf_soiln.out
cp vswc.out CanESM2_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CNRM_wcmf.lis 
cp summary.out CNRM_wcmf_summary.out 
cp year_summary.out CNRM_wcmf_year_summary.out
cp harvest.csv CNRM_wcmf_harvest.csv	
cp dc_sip.csv CNRM_wcmf_dc_sip.csv	
cp soiln.out CNRM_wcmf_soiln.out
cp vswc.out CNRM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CSIRO_wcmf.lis 
cp summary.out CSIRO_wcmf_summary.out 
cp year_summary.out CSIRO_wcmf_year_summary.out
cp harvest.csv CSIRO_wcmf_harvest.csv	
cp dc_sip.csv CSIRO_wcmf_dc_sip.csv	
cp soiln.out CSIRO_wcmf_soiln.out
cp vswc.out CSIRO_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2G_wcmf.lis 
cp summary.out GFDL_ESM2G_wcmf_summary.out 
cp year_summary.out GFDL_ESM2G_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcmf_soiln.out
cp vswc.out GFDL_ESM2G_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2M_wcmf.lis 
cp summary.out GFDL_ESM2M_wcmf_summary.out 
cp year_summary.out GFDL_ESM2M_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcmf_soiln.out
cp vswc.out GFDL_ESM2M_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_CC_wcmf.lis 
cp summary.out HadGEM2_CC_wcmf_summary.out 
cp year_summary.out HadGEM2_CC_wcmf_year_summary.out
cp harvest.csv HadGEM2_CC_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcmf_soiln.out
cp vswc.out HadGEM2_CC_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_ES_wcmf.lis 
cp summary.out HadGEM2_ES_wcmf_summary.out 
cp year_summary.out HadGEM2_ES_wcmf_year_summary.out
cp harvest.csv HadGEM2_ES_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcmf_soiln.out
cp vswc.out HadGEM2_ES_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis inmcm4_wcmf.lis 
cp summary.out inmcm4_wcmf_summary.out 
cp year_summary.out inmcm4_wcmf_year_summary.out
cp harvest.csv inmcm4_wcmf_harvest.csv	
cp dc_sip.csv inmcm4_wcmf_dc_sip.csv	
cp soiln.out inmcm4_wcmf_soiln.out
cp vswc.out inmcm4_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5ALR_wcmf.lis 
cp summary.out IPSL_CM5ALR_wcmf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcmf_soiln.out
cp vswc.out IPSL_CM5ALR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5BLR_wcmf.lis 
cp summary.out IPSL_CM5BLR_wcmf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcmf_soiln.out
cp vswc.out IPSL_CM5BLR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC5_wcmf.lis 
cp summary.out MIROC5_wcmf_summary.out 
cp year_summary.out MIROC5_wcmf_year_summary.out
cp harvest.csv MIROC5_wcmf_harvest.csv	
cp dc_sip.csv MIROC5_wcmf_dc_sip.csv	
cp soiln.out MIROC5_wcmf_soiln.out
cp vswc.out MIROC5_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC_CHEM_wcmf.lis 
cp summary.out MIROC_CHEM_wcmf_summary.out 
cp year_summary.out MIROC_CHEM_wcmf_year_summary.out
cp harvest.csv MIROC_CHEM_wcmf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcmf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcmf_soiln.out
cp vswc.out MIROC_CHEM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MRI_CGCM3_wcmf.lis 
cp summary.out MRI_CGCM3_wcmf_summary.out 
cp year_summary.out MRI_CGCM3_wcmf_year_summary.out
cp harvest.csv MRI_CGCM3_wcmf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcmf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcmf_soiln.out
cp vswc.out MRI_CGCM3_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11m_cmfw.lis 
cp summary.out bcc_csm11m_cmfw_summary.out 
cp year_summary.out bcc_csm11m_cmfw_year_summary.out
cp harvest.csv bcc_csm11m_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cmfw_soiln.out
cp vswc.out bcc_csm11m_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11_cmfw.lis 
cp summary.out bcc_csm11_cmfw_summary.out 
cp year_summary.out bcc_csm11_cmfw_year_summary.out
cp harvest.csv bcc_csm11_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11_cmfw_soiln.out
cp vswc.out bcc_csm11_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis BNU_cmfw.lis 
cp summary.out BNU_cmfw_summary.out 
cp year_summary.out BNU_cmfw_year_summary.out
cp harvest.csv BNU_cmfw_harvest.csv	
cp dc_sip.csv BNU_cmfw_dc_sip.csv	
cp soiln.out BNU_cmfw_soiln.out
cp vswc.out BNU_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CanESM2_cmfw.lis 
cp summary.out CanESM2_cmfw_summary.out 
cp year_summary.out CanESM2_cmfw_year_summary.out
cp harvest.csv CanESM2_cmfw_harvest.csv	
cp dc_sip.csv CanESM2_cmfw_dc_sip.csv	
cp soiln.out CanESM2_cmfw_soiln.out
cp vswc.out CanESM2_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CNRM_cmfw.lis 
cp summary.out CNRM_cmfw_summary.out 
cp year_summary.out CNRM_cmfw_year_summary.out
cp harvest.csv CNRM_cmfw_harvest.csv	
cp dc_sip.csv CNRM_cmfw_dc_sip.csv	
cp soiln.out CNRM_cmfw_soiln.out
cp vswc.out CNRM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CSIRO_cmfw.lis 
cp summary.out CSIRO_cmfw_summary.out 
cp year_summary.out CSIRO_cmfw_year_summary.out
cp harvest.csv CSIRO_cmfw_harvest.csv	
cp dc_sip.csv CSIRO_cmfw_dc_sip.csv	
cp soiln.out CSIRO_cmfw_soiln.out
cp vswc.out CSIRO_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2G_cmfw.lis 
cp summary.out GFDL_ESM2G_cmfw_summary.out 
cp year_summary.out GFDL_ESM2G_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cmfw_soiln.out
cp vswc.out GFDL_ESM2G_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2M_cmfw.lis 
cp summary.out GFDL_ESM2M_cmfw_summary.out 
cp year_summary.out GFDL_ESM2M_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cmfw_soiln.out
cp vswc.out GFDL_ESM2M_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_CC_cmfw.lis 
cp summary.out HadGEM2_CC_cmfw_summary.out 
cp year_summary.out HadGEM2_CC_cmfw_year_summary.out
cp harvest.csv HadGEM2_CC_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cmfw_soiln.out
cp vswc.out HadGEM2_CC_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_ES_cmfw.lis 
cp summary.out HadGEM2_ES_cmfw_summary.out 
cp year_summary.out HadGEM2_ES_cmfw_year_summary.out
cp harvest.csv HadGEM2_ES_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cmfw_soiln.out
cp vswc.out HadGEM2_ES_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis inmcm4_cmfw.lis 
cp summary.out inmcm4_cmfw_summary.out 
cp year_summary.out inmcm4_cmfw_year_summary.out
cp harvest.csv inmcm4_cmfw_harvest.csv	
cp dc_sip.csv inmcm4_cmfw_dc_sip.csv	
cp soiln.out inmcm4_cmfw_soiln.out
cp vswc.out inmcm4_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5ALR_cmfw.lis 
cp summary.out IPSL_CM5ALR_cmfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cmfw_soiln.out
cp vswc.out IPSL_CM5ALR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5BLR_cmfw.lis 
cp summary.out IPSL_CM5BLR_cmfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cmfw_soiln.out
cp vswc.out IPSL_CM5BLR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC5_cmfw.lis 
cp summary.out MIROC5_cmfw_summary.out 
cp year_summary.out MIROC5_cmfw_year_summary.out
cp harvest.csv MIROC5_cmfw_harvest.csv	
cp dc_sip.csv MIROC5_cmfw_dc_sip.csv	
cp soiln.out MIROC5_cmfw_soiln.out
cp vswc.out MIROC5_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC_CHEM_cmfw.lis 
cp summary.out MIROC_CHEM_cmfw_summary.out 
cp year_summary.out MIROC_CHEM_cmfw_year_summary.out
cp harvest.csv MIROC_CHEM_cmfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cmfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cmfw_soiln.out
cp vswc.out MIROC_CHEM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MRI_CGCM3_cmfw.lis 
cp summary.out MRI_CGCM3_cmfw_summary.out 
cp year_summary.out MRI_CGCM3_cmfw_year_summary.out
cp harvest.csv MRI_CGCM3_cmfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cmfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cmfw_soiln.out
cp vswc.out MRI_CGCM3_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11m_mfwc.lis 
cp summary.out bcc_csm11m_mfwc_summary.out 
cp year_summary.out bcc_csm11m_mfwc_year_summary.out
cp harvest.csv bcc_csm11m_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11m_mfwc_soiln.out
cp vswc.out bcc_csm11m_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11_mfwc.lis 
cp summary.out bcc_csm11_mfwc_summary.out 
cp year_summary.out bcc_csm11_mfwc_year_summary.out
cp harvest.csv bcc_csm11_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11_mfwc_soiln.out
cp vswc.out bcc_csm11_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis BNU_mfwc.lis 
cp summary.out BNU_mfwc_summary.out 
cp year_summary.out BNU_mfwc_year_summary.out
cp harvest.csv BNU_mfwc_harvest.csv	
cp dc_sip.csv BNU_mfwc_dc_sip.csv	
cp soiln.out BNU_mfwc_soiln.out
cp vswc.out BNU_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CanESM2_mfwc.lis 
cp summary.out CanESM2_mfwc_summary.out 
cp year_summary.out CanESM2_mfwc_year_summary.out
cp harvest.csv CanESM2_mfwc_harvest.csv	
cp dc_sip.csv CanESM2_mfwc_dc_sip.csv	
cp soiln.out CanESM2_mfwc_soiln.out
cp vswc.out CanESM2_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CNRM_mfwc.lis 
cp summary.out CNRM_mfwc_summary.out 
cp year_summary.out CNRM_mfwc_year_summary.out
cp harvest.csv CNRM_mfwc_harvest.csv	
cp dc_sip.csv CNRM_mfwc_dc_sip.csv	
cp soiln.out CNRM_mfwc_soiln.out
cp vswc.out CNRM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CSIRO_mfwc.lis 
cp summary.out CSIRO_mfwc_summary.out 
cp year_summary.out CSIRO_mfwc_year_summary.out
cp harvest.csv CSIRO_mfwc_harvest.csv	
cp dc_sip.csv CSIRO_mfwc_dc_sip.csv	
cp soiln.out CSIRO_mfwc_soiln.out
cp vswc.out CSIRO_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2G_mfwc.lis 
cp summary.out GFDL_ESM2G_mfwc_summary.out 
cp year_summary.out GFDL_ESM2G_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2G_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_mfwc_soiln.out
cp vswc.out GFDL_ESM2G_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2M_mfwc.lis 
cp summary.out GFDL_ESM2M_mfwc_summary.out 
cp year_summary.out GFDL_ESM2M_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2M_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_mfwc_soiln.out
cp vswc.out GFDL_ESM2M_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_CC_mfwc.lis 
cp summary.out HadGEM2_CC_mfwc_summary.out 
cp year_summary.out HadGEM2_CC_mfwc_year_summary.out
cp harvest.csv HadGEM2_CC_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_mfwc_soiln.out
cp vswc.out HadGEM2_CC_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_ES_mfwc.lis 
cp summary.out HadGEM2_ES_mfwc_summary.out 
cp year_summary.out HadGEM2_ES_mfwc_year_summary.out
cp harvest.csv HadGEM2_ES_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_mfwc_soiln.out
cp vswc.out HadGEM2_ES_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis inmcm4_mfwc.lis 
cp summary.out inmcm4_mfwc_summary.out 
cp year_summary.out inmcm4_mfwc_year_summary.out
cp harvest.csv inmcm4_mfwc_harvest.csv	
cp dc_sip.csv inmcm4_mfwc_dc_sip.csv	
cp soiln.out inmcm4_mfwc_soiln.out
cp vswc.out inmcm4_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5ALR_mfwc.lis 
cp summary.out IPSL_CM5ALR_mfwc_summary.out 
cp year_summary.out IPSL_CM5ALR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_mfwc_soiln.out
cp vswc.out IPSL_CM5ALR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5BLR_mfwc.lis 
cp summary.out IPSL_CM5BLR_mfwc_summary.out 
cp year_summary.out IPSL_CM5BLR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_mfwc_soiln.out
cp vswc.out IPSL_CM5BLR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC5_mfwc.lis 
cp summary.out MIROC5_mfwc_summary.out 
cp year_summary.out MIROC5_mfwc_year_summary.out
cp harvest.csv MIROC5_mfwc_harvest.csv	
cp dc_sip.csv MIROC5_mfwc_dc_sip.csv	
cp soiln.out MIROC5_mfwc_soiln.out
cp vswc.out MIROC5_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC_CHEM_mfwc.lis 
cp summary.out MIROC_CHEM_mfwc_summary.out 
cp year_summary.out MIROC_CHEM_mfwc_year_summary.out
cp harvest.csv MIROC_CHEM_mfwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_mfwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_mfwc_soiln.out
cp vswc.out MIROC_CHEM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MRI_CGCM3_mfwc.lis 
cp summary.out MRI_CGCM3_mfwc_summary.out 
cp year_summary.out MRI_CGCM3_mfwc_year_summary.out
cp harvest.csv MRI_CGCM3_mfwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_mfwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_mfwc_soiln.out
cp vswc.out MRI_CGCM3_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/*

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11m_fwcm.lis 
cp summary.out bcc_csm11m_fwcm_summary.out 
cp year_summary.out bcc_csm11m_fwcm_year_summary.out
cp harvest.csv bcc_csm11m_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11m_fwcm_soiln.out
cp vswc.out bcc_csm11m_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11_fwcm.lis 
cp summary.out bcc_csm11_fwcm_summary.out 
cp year_summary.out bcc_csm11_fwcm_year_summary.out
cp harvest.csv bcc_csm11_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11_fwcm_soiln.out
cp vswc.out bcc_csm11_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis BNU_fwcm.lis 
cp summary.out BNU_fwcm_summary.out 
cp year_summary.out BNU_fwcm_year_summary.out
cp harvest.csv BNU_fwcm_harvest.csv	
cp dc_sip.csv BNU_fwcm_dc_sip.csv	
cp soiln.out BNU_fwcm_soiln.out
cp vswc.out BNU_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CanESM2_fwcm.lis 
cp summary.out CanESM2_fwcm_summary.out 
cp year_summary.out CanESM2_fwcm_year_summary.out
cp harvest.csv CanESM2_fwcm_harvest.csv	
cp dc_sip.csv CanESM2_fwcm_dc_sip.csv	
cp soiln.out CanESM2_fwcm_soiln.out
cp vswc.out CanESM2_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CNRM_fwcm.lis 
cp summary.out CNRM_fwcm_summary.out 
cp year_summary.out CNRM_fwcm_year_summary.out
cp harvest.csv CNRM_fwcm_harvest.csv	
cp dc_sip.csv CNRM_fwcm_dc_sip.csv	
cp soiln.out CNRM_fwcm_soiln.out
cp vswc.out CNRM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CSIRO_fwcm.lis 
cp summary.out CSIRO_fwcm_summary.out 
cp year_summary.out CSIRO_fwcm_year_summary.out
cp harvest.csv CSIRO_fwcm_harvest.csv	
cp dc_sip.csv CSIRO_fwcm_dc_sip.csv	
cp soiln.out CSIRO_fwcm_soiln.out
cp vswc.out CSIRO_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2G_fwcm.lis 
cp summary.out GFDL_ESM2G_fwcm_summary.out 
cp year_summary.out GFDL_ESM2G_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2G_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwcm_soiln.out
cp vswc.out GFDL_ESM2G_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2M_fwcm.lis 
cp summary.out GFDL_ESM2M_fwcm_summary.out 
cp year_summary.out GFDL_ESM2M_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2M_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwcm_soiln.out
cp vswc.out GFDL_ESM2M_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_CC_fwcm.lis 
cp summary.out HadGEM2_CC_fwcm_summary.out 
cp year_summary.out HadGEM2_CC_fwcm_year_summary.out
cp harvest.csv HadGEM2_CC_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwcm_soiln.out
cp vswc.out HadGEM2_CC_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_ES_fwcm.lis 
cp summary.out HadGEM2_ES_fwcm_summary.out 
cp year_summary.out HadGEM2_ES_fwcm_year_summary.out
cp harvest.csv HadGEM2_ES_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwcm_soiln.out
cp vswc.out HadGEM2_ES_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis inmcm4_fwcm.lis 
cp summary.out inmcm4_fwcm_summary.out 
cp year_summary.out inmcm4_fwcm_year_summary.out
cp harvest.csv inmcm4_fwcm_harvest.csv	
cp dc_sip.csv inmcm4_fwcm_dc_sip.csv	
cp soiln.out inmcm4_fwcm_soiln.out
cp vswc.out inmcm4_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5ALR_fwcm.lis 
cp summary.out IPSL_CM5ALR_fwcm_summary.out 
cp year_summary.out IPSL_CM5ALR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwcm_soiln.out
cp vswc.out IPSL_CM5ALR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5BLR_fwcm.lis 
cp summary.out IPSL_CM5BLR_fwcm_summary.out 
cp year_summary.out IPSL_CM5BLR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwcm_soiln.out
cp vswc.out IPSL_CM5BLR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC5_fwcm.lis 
cp summary.out MIROC5_fwcm_summary.out 
cp year_summary.out MIROC5_fwcm_year_summary.out
cp harvest.csv MIROC5_fwcm_harvest.csv	
cp dc_sip.csv MIROC5_fwcm_dc_sip.csv	
cp soiln.out MIROC5_fwcm_soiln.out
cp vswc.out MIROC5_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC_CHEM_fwcm.lis 
cp summary.out MIROC_CHEM_fwcm_summary.out 
cp year_summary.out MIROC_CHEM_fwcm_year_summary.out
cp harvest.csv MIROC_CHEM_fwcm_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwcm_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwcm_soiln.out
cp vswc.out MIROC_CHEM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MRI_CGCM3_fwcm.lis 
cp summary.out MRI_CGCM3_fwcm_summary.out 
cp year_summary.out MRI_CGCM3_fwcm_year_summary.out
cp harvest.csv MRI_CGCM3_fwcm_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwcm_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwcm_soiln.out
cp vswc.out MRI_CGCM3_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_summit_$f"; done
for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### OPPORTUNITY CROP ROTATION (CONTINUOUS CROPPING) FOR SUMMITS

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/*

cd /media/andy/Modelling/DAP_files/future_sims/ste_sims85

cp spin.1 spin.bin
cp base.1 base.bin

cp rot10_summit.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11m_opp.lis 
cp summary.out bcc_csm11m_opp_summary.out 
cp year_summary.out bcc_csm11m_opp_year_summary.out
cp harvest.csv bcc_csm11m_opp_harvest.csv	
cp dc_sip.csv bcc_csm11m_opp_dc_sip.csv	
cp soiln.out bcc_csm11m_opp_soiln.out
cp vswc.out bcc_csm11m_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11_opp.lis 
cp summary.out bcc_csm11_opp_summary.out 
cp year_summary.out bcc_csm11_opp_year_summary.out
cp harvest.csv bcc_csm11_opp_harvest.csv	
cp dc_sip.csv bcc_csm11_opp_dc_sip.csv	
cp soiln.out bcc_csm11_opp_soiln.out
cp vswc.out bcc_csm11_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis BNU_opp.lis 
cp summary.out BNU_opp_summary.out 
cp year_summary.out BNU_opp_year_summary.out
cp harvest.csv BNU_opp_harvest.csv	
cp dc_sip.csv BNU_opp_dc_sip.csv	
cp soiln.out BNU_opp_soiln.out
cp vswc.out BNU_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CanESM2_opp.lis 
cp summary.out CanESM2_opp_summary.out 
cp year_summary.out CanESM2_opp_year_summary.out
cp harvest.csv CanESM2_opp_harvest.csv	
cp dc_sip.csv CanESM2_opp_dc_sip.csv	
cp soiln.out CanESM2_opp_soiln.out
cp vswc.out CanESM2_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CNRM_opp.lis 
cp summary.out CNRM_opp_summary.out 
cp year_summary.out CNRM_opp_year_summary.out
cp harvest.csv CNRM_opp_harvest.csv	
cp dc_sip.csv CNRM_opp_dc_sip.csv	
cp soiln.out CNRM_opp_soiln.out
cp vswc.out CNRM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CSIRO_opp.lis 
cp summary.out CSIRO_opp_summary.out 
cp year_summary.out CSIRO_opp_year_summary.out
cp harvest.csv CSIRO_opp_harvest.csv	
cp dc_sip.csv CSIRO_opp_dc_sip.csv	
cp soiln.out CSIRO_opp_soiln.out
cp vswc.out CSIRO_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2G_opp.lis 
cp summary.out GFDL_ESM2G_opp_summary.out 
cp year_summary.out GFDL_ESM2G_opp_year_summary.out
cp harvest.csv GFDL_ESM2G_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2G_opp_soiln.out
cp vswc.out GFDL_ESM2G_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2M_opp.lis 
cp summary.out GFDL_ESM2M_opp_summary.out 
cp year_summary.out GFDL_ESM2M_opp_year_summary.out
cp harvest.csv GFDL_ESM2M_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2M_opp_soiln.out
cp vswc.out GFDL_ESM2M_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_CC_opp.lis 
cp summary.out HadGEM2_CC_opp_summary.out 
cp year_summary.out HadGEM2_CC_opp_year_summary.out
cp harvest.csv HadGEM2_CC_opp_harvest.csv	
cp dc_sip.csv HadGEM2_CC_opp_dc_sip.csv	
cp soiln.out HadGEM2_CC_opp_soiln.out
cp vswc.out HadGEM2_CC_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_ES_opp.lis 
cp summary.out HadGEM2_ES_opp_summary.out 
cp year_summary.out HadGEM2_ES_opp_year_summary.out
cp harvest.csv HadGEM2_ES_opp_harvest.csv	
cp dc_sip.csv HadGEM2_ES_opp_dc_sip.csv	
cp soiln.out HadGEM2_ES_opp_soiln.out
cp vswc.out HadGEM2_ES_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis inmcm4_opp.lis 
cp summary.out inmcm4_opp_summary.out 
cp year_summary.out inmcm4_opp_year_summary.out
cp harvest.csv inmcm4_opp_harvest.csv	
cp dc_sip.csv inmcm4_opp_dc_sip.csv	
cp soiln.out inmcm4_opp_soiln.out
cp vswc.out inmcm4_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5ALR_opp.lis 
cp summary.out IPSL_CM5ALR_opp_summary.out 
cp year_summary.out IPSL_CM5ALR_opp_year_summary.out
cp harvest.csv IPSL_CM5ALR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_opp_soiln.out
cp vswc.out IPSL_CM5ALR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5BLR_opp.lis 
cp summary.out IPSL_CM5BLR_opp_summary.out 
cp year_summary.out IPSL_CM5BLR_opp_year_summary.out
cp harvest.csv IPSL_CM5BLR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_opp_soiln.out
cp vswc.out IPSL_CM5BLR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC5_opp.lis 
cp summary.out MIROC5_opp_summary.out 
cp year_summary.out MIROC5_opp_year_summary.out
cp harvest.csv MIROC5_opp_harvest.csv	
cp dc_sip.csv MIROC5_opp_dc_sip.csv	
cp soiln.out MIROC5_opp_soiln.out
cp vswc.out MIROC5_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC_CHEM_opp.lis 
cp summary.out MIROC_CHEM_opp_summary.out 
cp year_summary.out MIROC_CHEM_opp_year_summary.out
cp harvest.csv MIROC_CHEM_opp_harvest.csv	
cp dc_sip.csv MIROC_CHEM_opp_dc_sip.csv	
cp soiln.out MIROC_CHEM_opp_soiln.out
cp vswc.out MIROC_CHEM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MRI_CGCM3_opp.lis 
cp summary.out MRI_CGCM3_opp_summary.out 
cp year_summary.out MRI_CGCM3_opp_year_summary.out
cp harvest.csv MRI_CGCM3_opp_harvest.csv	
cp dc_sip.csv MRI_CGCM3_opp_dc_sip.csv	
cp soiln.out MRI_CGCM3_opp_soiln.out
cp vswc.out MRI_CGCM3_opp_vswc.out

rm opp.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_summit_$f"; done
for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### GRASSLAND FOR SUMMITS

if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/"
fi
 
if [ -d "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/"
fi
   
rm -r /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/*
   
cd /media/andy/Modelling/DAP_files/future_sims/ste_sims85

cp base.1 base.bin
cp spin.1 spin.bin

cp grass.sch grass_09.sch
cp grass_09.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth
cp f_grass.sch grass.sch

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11m_grass.lis 
cp summary.out bcc_csm11m_grass_summary.out 
cp year_summary.out bcc_csm11m_grass_year_summary.out
cp harvest.csv bcc_csm11m_grass_harvest.csv	
cp dc_sip.csv bcc_csm11m_grass_dc_sip.csv	
cp soiln.out bcc_csm11m_grass_soiln.out
cp vswc.out bcc_csm11m_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11_grass.lis 
cp summary.out bcc_csm11_grass_summary.out 
cp year_summary.out bcc_csm11_grass_year_summary.out
cp harvest.csv bcc_csm11_grass_harvest.csv	
cp dc_sip.csv bcc_csm11_grass_dc_sip.csv	
cp soiln.out bcc_csm11_grass_soiln.out
cp vswc.out bcc_csm11_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis BNU_grass.lis 
cp summary.out BNU_grass_summary.out 
cp year_summary.out BNU_grass_year_summary.out
cp harvest.csv BNU_grass_harvest.csv	
cp dc_sip.csv BNU_grass_dc_sip.csv	
cp soiln.out BNU_grass_soiln.out
cp vswc.out BNU_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CanESM2_grass.lis 
cp summary.out CanESM2_grass_summary.out 
cp year_summary.out CanESM2_grass_year_summary.out
cp harvest.csv CanESM2_grass_harvest.csv	
cp dc_sip.csv CanESM2_grass_dc_sip.csv	
cp soiln.out CanESM2_grass_soiln.out
cp vswc.out CanESM2_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CNRM_grass.lis 
cp summary.out CNRM_grass_summary.out 
cp year_summary.out CNRM_grass_year_summary.out
cp harvest.csv CNRM_grass_harvest.csv	
cp dc_sip.csv CNRM_grass_dc_sip.csv	
cp soiln.out CNRM_grass_soiln.out
cp vswc.out CNRM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CSIRO_grass.lis 
cp summary.out CSIRO_grass_summary.out 
cp year_summary.out CSIRO_grass_year_summary.out
cp harvest.csv CSIRO_grass_harvest.csv	
cp dc_sip.csv CSIRO_grass_dc_sip.csv	
cp soiln.out CSIRO_grass_soiln.out
cp vswc.out CSIRO_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2G_grass.lis 
cp summary.out GFDL_ESM2G_grass_summary.out 
cp year_summary.out GFDL_ESM2G_grass_year_summary.out
cp harvest.csv GFDL_ESM2G_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2G_grass_soiln.out
cp vswc.out GFDL_ESM2G_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2M_grass.lis 
cp summary.out GFDL_ESM2M_grass_summary.out 
cp year_summary.out GFDL_ESM2M_grass_year_summary.out
cp harvest.csv GFDL_ESM2M_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2M_grass_soiln.out
cp vswc.out GFDL_ESM2M_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_CC_grass.lis 
cp summary.out HadGEM2_CC_grass_summary.out 
cp year_summary.out HadGEM2_CC_grass_year_summary.out
cp harvest.csv HadGEM2_CC_grass_harvest.csv	
cp dc_sip.csv HadGEM2_CC_grass_dc_sip.csv	
cp soiln.out HadGEM2_CC_grass_soiln.out
cp vswc.out HadGEM2_CC_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_ES_grass.lis 
cp summary.out HadGEM2_ES_grass_summary.out 
cp year_summary.out HadGEM2_ES_grass_year_summary.out
cp harvest.csv HadGEM2_ES_grass_harvest.csv	
cp dc_sip.csv HadGEM2_ES_grass_dc_sip.csv	
cp soiln.out HadGEM2_ES_grass_soiln.out
cp vswc.out HadGEM2_ES_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis inmcm4_grass.lis 
cp summary.out inmcm4_grass_summary.out 
cp year_summary.out inmcm4_grass_year_summary.out
cp harvest.csv inmcm4_grass_harvest.csv	
cp dc_sip.csv inmcm4_grass_dc_sip.csv	
cp soiln.out inmcm4_grass_soiln.out
cp vswc.out inmcm4_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5ALR_grass.lis 
cp summary.out IPSL_CM5ALR_grass_summary.out 
cp year_summary.out IPSL_CM5ALR_grass_year_summary.out
cp harvest.csv IPSL_CM5ALR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_grass_soiln.out
cp vswc.out IPSL_CM5ALR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5BLR_grass.lis 
cp summary.out IPSL_CM5BLR_grass_summary.out 
cp year_summary.out IPSL_CM5BLR_grass_year_summary.out
cp harvest.csv IPSL_CM5BLR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_grass_soiln.out
cp vswc.out IPSL_CM5BLR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC5_grass.lis 
cp summary.out MIROC5_grass_summary.out 
cp year_summary.out MIROC5_grass_year_summary.out
cp harvest.csv MIROC5_grass_harvest.csv	
cp dc_sip.csv MIROC5_grass_dc_sip.csv	
cp soiln.out MIROC5_grass_soiln.out
cp vswc.out MIROC5_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC_CHEM_grass.lis 
cp summary.out MIROC_CHEM_grass_summary.out 
cp year_summary.out MIROC_CHEM_grass_year_summary.out
cp harvest.csv MIROC_CHEM_grass_harvest.csv	
cp dc_sip.csv MIROC_CHEM_grass_dc_sip.csv	
cp soiln.out MIROC_CHEM_grass_soiln.out
cp vswc.out MIROC_CHEM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MRI_CGCM3_grass.lis 
cp summary.out MRI_CGCM3_grass_summary.out 
cp year_summary.out MRI_CGCM3_grass_year_summary.out
cp harvest.csv MRI_CGCM3_grass_harvest.csv	
cp dc_sip.csv MRI_CGCM3_grass_dc_sip.csv	
cp soiln.out MRI_CGCM3_grass_soiln.out
cp vswc.out MRI_CGCM3_grass_vswc.out

rm grass.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_summit_$f"; done
for f in *.lis; do mv "$f" "ste_summit_$f"; done
for f in *.out; do mv "$f" "ste_summit_$f"; done
for f in *.csv; do mv "$f" "ste_summit_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm soils.in

####### FOR SIDESLOPE

cp side.in soils.in

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

cp rot1_side.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11m_wf.lis 
cp summary.out bcc_csm11m_wf_summary.out 
cp year_summary.out bcc_csm11m_wf_year_summary.out
cp harvest.csv bcc_csm11m_wf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wf_dc_sip.csv	
cp soiln.out bcc_csm11m_wf_soiln.out
cp vswc.out bcc_csm11m_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11_wf.lis 
cp summary.out bcc_csm11_wf_summary.out 
cp year_summary.out bcc_csm11_wf_year_summary.out
cp harvest.csv bcc_csm11_wf_harvest.csv	
cp dc_sip.csv bcc_csm11_wf_dc_sip.csv	
cp soiln.out bcc_csm11_wf_soiln.out
cp vswc.out bcc_csm11_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis BNU_wf.lis 
cp summary.out BNU_wf_summary.out 
cp year_summary.out BNU_wf_year_summary.out
cp harvest.csv BNU_wf_harvest.csv	
cp dc_sip.csv BNU_wf_dc_sip.csv	
cp soiln.out BNU_wf_soiln.out
cp vswc.out BNU_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CanESM2_wf.lis 
cp summary.out CanESM2_wf_summary.out 
cp year_summary.out CanESM2_wf_year_summary.out
cp harvest.csv CanESM2_wf_harvest.csv	
cp dc_sip.csv CanESM2_wf_dc_sip.csv	
cp soiln.out CanESM2_wf_soiln.out
cp vswc.out CanESM2_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CNRM_wf.lis 
cp summary.out CNRM_wf_summary.out 
cp year_summary.out CNRM_wf_year_summary.out
cp harvest.csv CNRM_wf_harvest.csv	
cp dc_sip.csv CNRM_wf_dc_sip.csv	
cp soiln.out CNRM_wf_soiln.out
cp vswc.out CNRM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CSIRO_wf.lis 
cp summary.out CSIRO_wf_summary.out 
cp year_summary.out CSIRO_wf_year_summary.out
cp harvest.csv CSIRO_wf_harvest.csv	
cp dc_sip.csv CSIRO_wf_dc_sip.csv	
cp soiln.out CSIRO_wf_soiln.out
cp vswc.out CSIRO_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2G_wf.lis 
cp summary.out GFDL_ESM2G_wf_summary.out 
cp year_summary.out GFDL_ESM2G_wf_year_summary.out
cp harvest.csv GFDL_ESM2G_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wf_soiln.out
cp vswc.out GFDL_ESM2G_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2M_wf.lis 
cp summary.out GFDL_ESM2M_wf_summary.out 
cp year_summary.out GFDL_ESM2M_wf_year_summary.out
cp harvest.csv GFDL_ESM2M_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wf_soiln.out
cp vswc.out GFDL_ESM2M_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_CC_wf.lis 
cp summary.out HadGEM2_CC_wf_summary.out 
cp year_summary.out HadGEM2_CC_wf_year_summary.out
cp harvest.csv HadGEM2_CC_wf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wf_soiln.out
cp vswc.out HadGEM2_CC_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_ES_wf.lis 
cp summary.out HadGEM2_ES_wf_summary.out 
cp year_summary.out HadGEM2_ES_wf_year_summary.out
cp harvest.csv HadGEM2_ES_wf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wf_soiln.out
cp vswc.out HadGEM2_ES_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis inmcm4_wf.lis 
cp summary.out inmcm4_wf_summary.out 
cp year_summary.out inmcm4_wf_year_summary.out
cp harvest.csv inmcm4_wf_harvest.csv	
cp dc_sip.csv inmcm4_wf_dc_sip.csv	
cp soiln.out inmcm4_wf_soiln.out
cp vswc.out inmcm4_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5ALR_wf.lis 
cp summary.out IPSL_CM5ALR_wf_summary.out 
cp year_summary.out IPSL_CM5ALR_wf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wf_soiln.out
cp vswc.out IPSL_CM5ALR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5BLR_wf.lis 
cp summary.out IPSL_CM5BLR_wf_summary.out 
cp year_summary.out IPSL_CM5BLR_wf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wf_soiln.out
cp vswc.out IPSL_CM5BLR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC5_wf.lis 
cp summary.out MIROC5_wf_summary.out 
cp year_summary.out MIROC5_wf_year_summary.out
cp harvest.csv MIROC5_wf_harvest.csv	
cp dc_sip.csv MIROC5_wf_dc_sip.csv	
cp soiln.out MIROC5_wf_soiln.out
cp vswc.out MIROC5_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC_CHEM_wf.lis 
cp summary.out MIROC_CHEM_wf_summary.out 
cp year_summary.out MIROC_CHEM_wf_year_summary.out
cp harvest.csv MIROC_CHEM_wf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wf_soiln.out
cp vswc.out MIROC_CHEM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MRI_CGCM3_wf.lis 
cp summary.out MRI_CGCM3_wf_summary.out 
cp year_summary.out MRI_CGCM3_wf_year_summary.out
cp harvest.csv MRI_CGCM3_wf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wf_soiln.out
cp vswc.out MRI_CGCM3_wf_vswc.out

rm wf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11m_fw.lis 
cp summary.out bcc_csm11m_fw_summary.out 
cp year_summary.out bcc_csm11m_fw_year_summary.out
cp harvest.csv bcc_csm11m_fw_harvest.csv	
cp dc_sip.csv bcc_csm11m_fw_dc_sip.csv	
cp soiln.out bcc_csm11m_fw_soiln.out
cp vswc.out bcc_csm11m_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11_fw.lis 
cp summary.out bcc_csm11_fw_summary.out 
cp year_summary.out bcc_csm11_fw_year_summary.out
cp harvest.csv bcc_csm11_fw_harvest.csv	
cp dc_sip.csv bcc_csm11_fw_dc_sip.csv	
cp soiln.out bcc_csm11_fw_soiln.out
cp vswc.out bcc_csm11_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis BNU_fw.lis 
cp summary.out BNU_fw_summary.out 
cp year_summary.out BNU_fw_year_summary.out
cp harvest.csv BNU_fw_harvest.csv	
cp dc_sip.csv BNU_fw_dc_sip.csv	
cp soiln.out BNU_fw_soiln.out
cp vswc.out BNU_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CanESM2_fw.lis 
cp summary.out CanESM2_fw_summary.out 
cp year_summary.out CanESM2_fw_year_summary.out
cp harvest.csv CanESM2_fw_harvest.csv	
cp dc_sip.csv CanESM2_fw_dc_sip.csv	
cp soiln.out CanESM2_fw_soiln.out
cp vswc.out CanESM2_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CNRM_fw.lis 
cp summary.out CNRM_fw_summary.out 
cp year_summary.out CNRM_fw_year_summary.out
cp harvest.csv CNRM_fw_harvest.csv	
cp dc_sip.csv CNRM_fw_dc_sip.csv	
cp soiln.out CNRM_fw_soiln.out
cp vswc.out CNRM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CSIRO_fw.lis 
cp summary.out CSIRO_fw_summary.out 
cp year_summary.out CSIRO_fw_year_summary.out
cp harvest.csv CSIRO_fw_harvest.csv	
cp dc_sip.csv CSIRO_fw_dc_sip.csv	
cp soiln.out CSIRO_fw_soiln.out
cp vswc.out CSIRO_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2G_fw.lis 
cp summary.out GFDL_ESM2G_fw_summary.out 
cp year_summary.out GFDL_ESM2G_fw_year_summary.out
cp harvest.csv GFDL_ESM2G_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fw_soiln.out
cp vswc.out GFDL_ESM2G_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2M_fw.lis 
cp summary.out GFDL_ESM2M_fw_summary.out 
cp year_summary.out GFDL_ESM2M_fw_year_summary.out
cp harvest.csv GFDL_ESM2M_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fw_soiln.out
cp vswc.out GFDL_ESM2M_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_CC_fw.lis 
cp summary.out HadGEM2_CC_fw_summary.out 
cp year_summary.out HadGEM2_CC_fw_year_summary.out
cp harvest.csv HadGEM2_CC_fw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fw_dc_sip.csv	
cp soiln.out HadGEM2_CC_fw_soiln.out
cp vswc.out HadGEM2_CC_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_ES_fw.lis 
cp summary.out HadGEM2_ES_fw_summary.out 
cp year_summary.out HadGEM2_ES_fw_year_summary.out
cp harvest.csv HadGEM2_ES_fw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fw_dc_sip.csv	
cp soiln.out HadGEM2_ES_fw_soiln.out
cp vswc.out HadGEM2_ES_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis inmcm4_fw.lis 
cp summary.out inmcm4_fw_summary.out 
cp year_summary.out inmcm4_fw_year_summary.out
cp harvest.csv inmcm4_fw_harvest.csv	
cp dc_sip.csv inmcm4_fw_dc_sip.csv	
cp soiln.out inmcm4_fw_soiln.out
cp vswc.out inmcm4_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5ALR_fw.lis 
cp summary.out IPSL_CM5ALR_fw_summary.out 
cp year_summary.out IPSL_CM5ALR_fw_year_summary.out
cp harvest.csv IPSL_CM5ALR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fw_soiln.out
cp vswc.out IPSL_CM5ALR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5BLR_fw.lis 
cp summary.out IPSL_CM5BLR_fw_summary.out 
cp year_summary.out IPSL_CM5BLR_fw_year_summary.out
cp harvest.csv IPSL_CM5BLR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fw_soiln.out
cp vswc.out IPSL_CM5BLR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC5_fw.lis 
cp summary.out MIROC5_fw_summary.out 
cp year_summary.out MIROC5_fw_year_summary.out
cp harvest.csv MIROC5_fw_harvest.csv	
cp dc_sip.csv MIROC5_fw_dc_sip.csv	
cp soiln.out MIROC5_fw_soiln.out
cp vswc.out MIROC5_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC_CHEM_fw.lis 
cp summary.out MIROC_CHEM_fw_summary.out 
cp year_summary.out MIROC_CHEM_fw_year_summary.out
cp harvest.csv MIROC_CHEM_fw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fw_dc_sip.csv	
cp soiln.out MIROC_CHEM_fw_soiln.out
cp vswc.out MIROC_CHEM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MRI_CGCM3_fw.lis 
cp summary.out MRI_CGCM3_fw_summary.out 
cp year_summary.out MRI_CGCM3_fw_year_summary.out
cp harvest.csv MRI_CGCM3_fw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fw_dc_sip.csv	
cp soiln.out MRI_CGCM3_fw_soiln.out
cp vswc.out MRI_CGCM3_fw_vswc.out

rm fw.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_side_$f"; done
for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-FALLOW ROTATION FOR SIDESLOPES

cp base.1 base.bin
cp spin.1 spin.bin

cp rot3_side.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11m_wcf.lis 
cp summary.out bcc_csm11m_wcf_summary.out 
cp year_summary.out bcc_csm11m_wcf_year_summary.out
cp harvest.csv bcc_csm11m_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcf_soiln.out
cp vswc.out bcc_csm11m_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11_wcf.lis 
cp summary.out bcc_csm11_wcf_summary.out 
cp year_summary.out bcc_csm11_wcf_year_summary.out
cp harvest.csv bcc_csm11_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcf_dc_sip.csv	
cp soiln.out bcc_csm11_wcf_soiln.out
cp vswc.out bcc_csm11_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis BNU_wcf.lis 
cp summary.out BNU_wcf_summary.out 
cp year_summary.out BNU_wcf_year_summary.out
cp harvest.csv BNU_wcf_harvest.csv	
cp dc_sip.csv BNU_wcf_dc_sip.csv	
cp soiln.out BNU_wcf_soiln.out
cp vswc.out BNU_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CanESM2_wcf.lis 
cp summary.out CanESM2_wcf_summary.out 
cp year_summary.out CanESM2_wcf_year_summary.out
cp harvest.csv CanESM2_wcf_harvest.csv	
cp dc_sip.csv CanESM2_wcf_dc_sip.csv	
cp soiln.out CanESM2_wcf_soiln.out
cp vswc.out CanESM2_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CNRM_wcf.lis 
cp summary.out CNRM_wcf_summary.out 
cp year_summary.out CNRM_wcf_year_summary.out
cp harvest.csv CNRM_wcf_harvest.csv	
cp dc_sip.csv CNRM_wcf_dc_sip.csv	
cp soiln.out CNRM_wcf_soiln.out
cp vswc.out CNRM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CSIRO_wcf.lis 
cp summary.out CSIRO_wcf_summary.out 
cp year_summary.out CSIRO_wcf_year_summary.out
cp harvest.csv CSIRO_wcf_harvest.csv	
cp dc_sip.csv CSIRO_wcf_dc_sip.csv	
cp soiln.out CSIRO_wcf_soiln.out
cp vswc.out CSIRO_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2G_wcf.lis 
cp summary.out GFDL_ESM2G_wcf_summary.out 
cp year_summary.out GFDL_ESM2G_wcf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcf_soiln.out
cp vswc.out GFDL_ESM2G_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2M_wcf.lis 
cp summary.out GFDL_ESM2M_wcf_summary.out 
cp year_summary.out GFDL_ESM2M_wcf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcf_soiln.out
cp vswc.out GFDL_ESM2M_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_CC_wcf.lis 
cp summary.out HadGEM2_CC_wcf_summary.out 
cp year_summary.out HadGEM2_CC_wcf_year_summary.out
cp harvest.csv HadGEM2_CC_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcf_soiln.out
cp vswc.out HadGEM2_CC_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_ES_wcf.lis 
cp summary.out HadGEM2_ES_wcf_summary.out 
cp year_summary.out HadGEM2_ES_wcf_year_summary.out
cp harvest.csv HadGEM2_ES_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcf_soiln.out
cp vswc.out HadGEM2_ES_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis inmcm4_wcf.lis 
cp summary.out inmcm4_wcf_summary.out 
cp year_summary.out inmcm4_wcf_year_summary.out
cp harvest.csv inmcm4_wcf_harvest.csv	
cp dc_sip.csv inmcm4_wcf_dc_sip.csv	
cp soiln.out inmcm4_wcf_soiln.out
cp vswc.out inmcm4_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5ALR_wcf.lis 
cp summary.out IPSL_CM5ALR_wcf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcf_soiln.out
cp vswc.out IPSL_CM5ALR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5BLR_wcf.lis 
cp summary.out IPSL_CM5BLR_wcf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcf_soiln.out
cp vswc.out IPSL_CM5BLR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC5_wcf.lis 
cp summary.out MIROC5_wcf_summary.out 
cp year_summary.out MIROC5_wcf_year_summary.out
cp harvest.csv MIROC5_wcf_harvest.csv	
cp dc_sip.csv MIROC5_wcf_dc_sip.csv	
cp soiln.out MIROC5_wcf_soiln.out
cp vswc.out MIROC5_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC_CHEM_wcf.lis 
cp summary.out MIROC_CHEM_wcf_summary.out 
cp year_summary.out MIROC_CHEM_wcf_year_summary.out
cp harvest.csv MIROC_CHEM_wcf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcf_soiln.out
cp vswc.out MIROC_CHEM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MRI_CGCM3_wcf.lis 
cp summary.out MRI_CGCM3_wcf_summary.out 
cp year_summary.out MRI_CGCM3_wcf_year_summary.out
cp harvest.csv MRI_CGCM3_wcf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcf_soiln.out
cp vswc.out MRI_CGCM3_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11m_cfw.lis 
cp summary.out bcc_csm11m_cfw_summary.out 
cp year_summary.out bcc_csm11m_cfw_year_summary.out
cp harvest.csv bcc_csm11m_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cfw_soiln.out
cp vswc.out bcc_csm11m_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11_cfw.lis 
cp summary.out bcc_csm11_cfw_summary.out 
cp year_summary.out bcc_csm11_cfw_year_summary.out
cp harvest.csv bcc_csm11_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cfw_dc_sip.csv	
cp soiln.out bcc_csm11_cfw_soiln.out
cp vswc.out bcc_csm11_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis BNU_cfw.lis 
cp summary.out BNU_cfw_summary.out 
cp year_summary.out BNU_cfw_year_summary.out
cp harvest.csv BNU_cfw_harvest.csv	
cp dc_sip.csv BNU_cfw_dc_sip.csv	
cp soiln.out BNU_cfw_soiln.out
cp vswc.out BNU_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CanESM2_cfw.lis 
cp summary.out CanESM2_cfw_summary.out 
cp year_summary.out CanESM2_cfw_year_summary.out
cp harvest.csv CanESM2_cfw_harvest.csv	
cp dc_sip.csv CanESM2_cfw_dc_sip.csv	
cp soiln.out CanESM2_cfw_soiln.out
cp vswc.out CanESM2_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CNRM_cfw.lis 
cp summary.out CNRM_cfw_summary.out 
cp year_summary.out CNRM_cfw_year_summary.out
cp harvest.csv CNRM_cfw_harvest.csv	
cp dc_sip.csv CNRM_cfw_dc_sip.csv	
cp soiln.out CNRM_cfw_soiln.out
cp vswc.out CNRM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CSIRO_cfw.lis 
cp summary.out CSIRO_cfw_summary.out 
cp year_summary.out CSIRO_cfw_year_summary.out
cp harvest.csv CSIRO_cfw_harvest.csv	
cp dc_sip.csv CSIRO_cfw_dc_sip.csv	
cp soiln.out CSIRO_cfw_soiln.out
cp vswc.out CSIRO_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2G_cfw.lis 
cp summary.out GFDL_ESM2G_cfw_summary.out 
cp year_summary.out GFDL_ESM2G_cfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cfw_soiln.out
cp vswc.out GFDL_ESM2G_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2M_cfw.lis 
cp summary.out GFDL_ESM2M_cfw_summary.out 
cp year_summary.out GFDL_ESM2M_cfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cfw_soiln.out
cp vswc.out GFDL_ESM2M_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_CC_cfw.lis 
cp summary.out HadGEM2_CC_cfw_summary.out 
cp year_summary.out HadGEM2_CC_cfw_year_summary.out
cp harvest.csv HadGEM2_CC_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cfw_soiln.out
cp vswc.out HadGEM2_CC_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_ES_cfw.lis 
cp summary.out HadGEM2_ES_cfw_summary.out 
cp year_summary.out HadGEM2_ES_cfw_year_summary.out
cp harvest.csv HadGEM2_ES_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cfw_soiln.out
cp vswc.out HadGEM2_ES_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis inmcm4_cfw.lis 
cp summary.out inmcm4_cfw_summary.out 
cp year_summary.out inmcm4_cfw_year_summary.out
cp harvest.csv inmcm4_cfw_harvest.csv	
cp dc_sip.csv inmcm4_cfw_dc_sip.csv	
cp soiln.out inmcm4_cfw_soiln.out
cp vswc.out inmcm4_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5ALR_cfw.lis 
cp summary.out IPSL_CM5ALR_cfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cfw_soiln.out
cp vswc.out IPSL_CM5ALR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5BLR_cfw.lis 
cp summary.out IPSL_CM5BLR_cfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cfw_soiln.out
cp vswc.out IPSL_CM5BLR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC5_cfw.lis 
cp summary.out MIROC5_cfw_summary.out 
cp year_summary.out MIROC5_cfw_year_summary.out
cp harvest.csv MIROC5_cfw_harvest.csv	
cp dc_sip.csv MIROC5_cfw_dc_sip.csv	
cp soiln.out MIROC5_cfw_soiln.out
cp vswc.out MIROC5_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC_CHEM_cfw.lis 
cp summary.out MIROC_CHEM_cfw_summary.out 
cp year_summary.out MIROC_CHEM_cfw_year_summary.out
cp harvest.csv MIROC_CHEM_cfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cfw_soiln.out
cp vswc.out MIROC_CHEM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MRI_CGCM3_cfw.lis 
cp summary.out MRI_CGCM3_cfw_summary.out 
cp year_summary.out MRI_CGCM3_cfw_year_summary.out
cp harvest.csv MRI_CGCM3_cfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cfw_soiln.out
cp vswc.out MRI_CGCM3_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11m_fwc.lis 
cp summary.out bcc_csm11m_fwc_summary.out 
cp year_summary.out bcc_csm11m_fwc_year_summary.out
cp harvest.csv bcc_csm11m_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwc_dc_sip.csv	
cp soiln.out bcc_csm11m_fwc_soiln.out
cp vswc.out bcc_csm11m_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11_fwc.lis 
cp summary.out bcc_csm11_fwc_summary.out 
cp year_summary.out bcc_csm11_fwc_year_summary.out
cp harvest.csv bcc_csm11_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11_fwc_dc_sip.csv	
cp soiln.out bcc_csm11_fwc_soiln.out
cp vswc.out bcc_csm11_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis BNU_fwc.lis 
cp summary.out BNU_fwc_summary.out 
cp year_summary.out BNU_fwc_year_summary.out
cp harvest.csv BNU_fwc_harvest.csv	
cp dc_sip.csv BNU_fwc_dc_sip.csv	
cp soiln.out BNU_fwc_soiln.out
cp vswc.out BNU_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CanESM2_fwc.lis 
cp summary.out CanESM2_fwc_summary.out 
cp year_summary.out CanESM2_fwc_year_summary.out
cp harvest.csv CanESM2_fwc_harvest.csv	
cp dc_sip.csv CanESM2_fwc_dc_sip.csv	
cp soiln.out CanESM2_fwc_soiln.out
cp vswc.out CanESM2_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CNRM_fwc.lis 
cp summary.out CNRM_fwc_summary.out 
cp year_summary.out CNRM_fwc_year_summary.out
cp harvest.csv CNRM_fwc_harvest.csv	
cp dc_sip.csv CNRM_fwc_dc_sip.csv	
cp soiln.out CNRM_fwc_soiln.out
cp vswc.out CNRM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CSIRO_fwc.lis 
cp summary.out CSIRO_fwc_summary.out 
cp year_summary.out CSIRO_fwc_year_summary.out
cp harvest.csv CSIRO_fwc_harvest.csv	
cp dc_sip.csv CSIRO_fwc_dc_sip.csv	
cp soiln.out CSIRO_fwc_soiln.out
cp vswc.out CSIRO_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2G_fwc.lis 
cp summary.out GFDL_ESM2G_fwc_summary.out 
cp year_summary.out GFDL_ESM2G_fwc_year_summary.out
cp harvest.csv GFDL_ESM2G_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwc_soiln.out
cp vswc.out GFDL_ESM2G_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2M_fwc.lis 
cp summary.out GFDL_ESM2M_fwc_summary.out 
cp year_summary.out GFDL_ESM2M_fwc_year_summary.out
cp harvest.csv GFDL_ESM2M_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwc_soiln.out
cp vswc.out GFDL_ESM2M_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_CC_fwc.lis 
cp summary.out HadGEM2_CC_fwc_summary.out 
cp year_summary.out HadGEM2_CC_fwc_year_summary.out
cp harvest.csv HadGEM2_CC_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwc_soiln.out
cp vswc.out HadGEM2_CC_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_ES_fwc.lis 
cp summary.out HadGEM2_ES_fwc_summary.out 
cp year_summary.out HadGEM2_ES_fwc_year_summary.out
cp harvest.csv HadGEM2_ES_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwc_soiln.out
cp vswc.out HadGEM2_ES_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis inmcm4_fwc.lis 
cp summary.out inmcm4_fwc_summary.out 
cp year_summary.out inmcm4_fwc_year_summary.out
cp harvest.csv inmcm4_fwc_harvest.csv	
cp dc_sip.csv inmcm4_fwc_dc_sip.csv	
cp soiln.out inmcm4_fwc_soiln.out
cp vswc.out inmcm4_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5ALR_fwc.lis 
cp summary.out IPSL_CM5ALR_fwc_summary.out 
cp year_summary.out IPSL_CM5ALR_fwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwc_soiln.out
cp vswc.out IPSL_CM5ALR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5BLR_fwc.lis 
cp summary.out IPSL_CM5BLR_fwc_summary.out 
cp year_summary.out IPSL_CM5BLR_fwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwc_soiln.out
cp vswc.out IPSL_CM5BLR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC5_fwc.lis 
cp summary.out MIROC5_fwc_summary.out 
cp year_summary.out MIROC5_fwc_year_summary.out
cp harvest.csv MIROC5_fwc_harvest.csv	
cp dc_sip.csv MIROC5_fwc_dc_sip.csv	
cp soiln.out MIROC5_fwc_soiln.out
cp vswc.out MIROC5_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC_CHEM_fwc.lis 
cp summary.out MIROC_CHEM_fwc_summary.out 
cp year_summary.out MIROC_CHEM_fwc_year_summary.out
cp harvest.csv MIROC_CHEM_fwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwc_soiln.out
cp vswc.out MIROC_CHEM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MRI_CGCM3_fwc.lis 
cp summary.out MRI_CGCM3_fwc_summary.out 
cp year_summary.out MRI_CGCM3_fwc_year_summary.out
cp harvest.csv MRI_CGCM3_fwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwc_soiln.out
cp vswc.out MRI_CGCM3_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_side_$f"; done
for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-MILLET-FALLOW ROTATION FOR SIDESLOPES

cp spin.1 spin.bin
cp base.1 base.bin

cp rot6_side.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11m_wcmf.lis 
cp summary.out bcc_csm11m_wcmf_summary.out 
cp year_summary.out bcc_csm11m_wcmf_year_summary.out
cp harvest.csv bcc_csm11m_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcmf_soiln.out
cp vswc.out bcc_csm11m_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11_wcmf.lis 
cp summary.out bcc_csm11_wcmf_summary.out 
cp year_summary.out bcc_csm11_wcmf_year_summary.out
cp harvest.csv bcc_csm11_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11_wcmf_soiln.out
cp vswc.out bcc_csm11_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis BNU_wcmf.lis 
cp summary.out BNU_wcmf_summary.out 
cp year_summary.out BNU_wcmf_year_summary.out
cp harvest.csv BNU_wcmf_harvest.csv	
cp dc_sip.csv BNU_wcmf_dc_sip.csv	
cp soiln.out BNU_wcmf_soiln.out
cp vswc.out BNU_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CanESM2_wcmf.lis 
cp summary.out CanESM2_wcmf_summary.out 
cp year_summary.out CanESM2_wcmf_year_summary.out
cp harvest.csv CanESM2_wcmf_harvest.csv	
cp dc_sip.csv CanESM2_wcmf_dc_sip.csv	
cp soiln.out CanESM2_wcmf_soiln.out
cp vswc.out CanESM2_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CNRM_wcmf.lis 
cp summary.out CNRM_wcmf_summary.out 
cp year_summary.out CNRM_wcmf_year_summary.out
cp harvest.csv CNRM_wcmf_harvest.csv	
cp dc_sip.csv CNRM_wcmf_dc_sip.csv	
cp soiln.out CNRM_wcmf_soiln.out
cp vswc.out CNRM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CSIRO_wcmf.lis 
cp summary.out CSIRO_wcmf_summary.out 
cp year_summary.out CSIRO_wcmf_year_summary.out
cp harvest.csv CSIRO_wcmf_harvest.csv	
cp dc_sip.csv CSIRO_wcmf_dc_sip.csv	
cp soiln.out CSIRO_wcmf_soiln.out
cp vswc.out CSIRO_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2G_wcmf.lis 
cp summary.out GFDL_ESM2G_wcmf_summary.out 
cp year_summary.out GFDL_ESM2G_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcmf_soiln.out
cp vswc.out GFDL_ESM2G_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2M_wcmf.lis 
cp summary.out GFDL_ESM2M_wcmf_summary.out 
cp year_summary.out GFDL_ESM2M_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcmf_soiln.out
cp vswc.out GFDL_ESM2M_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_CC_wcmf.lis 
cp summary.out HadGEM2_CC_wcmf_summary.out 
cp year_summary.out HadGEM2_CC_wcmf_year_summary.out
cp harvest.csv HadGEM2_CC_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcmf_soiln.out
cp vswc.out HadGEM2_CC_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_ES_wcmf.lis 
cp summary.out HadGEM2_ES_wcmf_summary.out 
cp year_summary.out HadGEM2_ES_wcmf_year_summary.out
cp harvest.csv HadGEM2_ES_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcmf_soiln.out
cp vswc.out HadGEM2_ES_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis inmcm4_wcmf.lis 
cp summary.out inmcm4_wcmf_summary.out 
cp year_summary.out inmcm4_wcmf_year_summary.out
cp harvest.csv inmcm4_wcmf_harvest.csv	
cp dc_sip.csv inmcm4_wcmf_dc_sip.csv	
cp soiln.out inmcm4_wcmf_soiln.out
cp vswc.out inmcm4_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5ALR_wcmf.lis 
cp summary.out IPSL_CM5ALR_wcmf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcmf_soiln.out
cp vswc.out IPSL_CM5ALR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5BLR_wcmf.lis 
cp summary.out IPSL_CM5BLR_wcmf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcmf_soiln.out
cp vswc.out IPSL_CM5BLR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC5_wcmf.lis 
cp summary.out MIROC5_wcmf_summary.out 
cp year_summary.out MIROC5_wcmf_year_summary.out
cp harvest.csv MIROC5_wcmf_harvest.csv	
cp dc_sip.csv MIROC5_wcmf_dc_sip.csv	
cp soiln.out MIROC5_wcmf_soiln.out
cp vswc.out MIROC5_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC_CHEM_wcmf.lis 
cp summary.out MIROC_CHEM_wcmf_summary.out 
cp year_summary.out MIROC_CHEM_wcmf_year_summary.out
cp harvest.csv MIROC_CHEM_wcmf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcmf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcmf_soiln.out
cp vswc.out MIROC_CHEM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MRI_CGCM3_wcmf.lis 
cp summary.out MRI_CGCM3_wcmf_summary.out 
cp year_summary.out MRI_CGCM3_wcmf_year_summary.out
cp harvest.csv MRI_CGCM3_wcmf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcmf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcmf_soiln.out
cp vswc.out MRI_CGCM3_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11m_cmfw.lis 
cp summary.out bcc_csm11m_cmfw_summary.out 
cp year_summary.out bcc_csm11m_cmfw_year_summary.out
cp harvest.csv bcc_csm11m_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cmfw_soiln.out
cp vswc.out bcc_csm11m_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11_cmfw.lis 
cp summary.out bcc_csm11_cmfw_summary.out 
cp year_summary.out bcc_csm11_cmfw_year_summary.out
cp harvest.csv bcc_csm11_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11_cmfw_soiln.out
cp vswc.out bcc_csm11_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis BNU_cmfw.lis 
cp summary.out BNU_cmfw_summary.out 
cp year_summary.out BNU_cmfw_year_summary.out
cp harvest.csv BNU_cmfw_harvest.csv	
cp dc_sip.csv BNU_cmfw_dc_sip.csv	
cp soiln.out BNU_cmfw_soiln.out
cp vswc.out BNU_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CanESM2_cmfw.lis 
cp summary.out CanESM2_cmfw_summary.out 
cp year_summary.out CanESM2_cmfw_year_summary.out
cp harvest.csv CanESM2_cmfw_harvest.csv	
cp dc_sip.csv CanESM2_cmfw_dc_sip.csv	
cp soiln.out CanESM2_cmfw_soiln.out
cp vswc.out CanESM2_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CNRM_cmfw.lis 
cp summary.out CNRM_cmfw_summary.out 
cp year_summary.out CNRM_cmfw_year_summary.out
cp harvest.csv CNRM_cmfw_harvest.csv	
cp dc_sip.csv CNRM_cmfw_dc_sip.csv	
cp soiln.out CNRM_cmfw_soiln.out
cp vswc.out CNRM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CSIRO_cmfw.lis 
cp summary.out CSIRO_cmfw_summary.out 
cp year_summary.out CSIRO_cmfw_year_summary.out
cp harvest.csv CSIRO_cmfw_harvest.csv	
cp dc_sip.csv CSIRO_cmfw_dc_sip.csv	
cp soiln.out CSIRO_cmfw_soiln.out
cp vswc.out CSIRO_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2G_cmfw.lis 
cp summary.out GFDL_ESM2G_cmfw_summary.out 
cp year_summary.out GFDL_ESM2G_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cmfw_soiln.out
cp vswc.out GFDL_ESM2G_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2M_cmfw.lis 
cp summary.out GFDL_ESM2M_cmfw_summary.out 
cp year_summary.out GFDL_ESM2M_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cmfw_soiln.out
cp vswc.out GFDL_ESM2M_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_CC_cmfw.lis 
cp summary.out HadGEM2_CC_cmfw_summary.out 
cp year_summary.out HadGEM2_CC_cmfw_year_summary.out
cp harvest.csv HadGEM2_CC_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cmfw_soiln.out
cp vswc.out HadGEM2_CC_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_ES_cmfw.lis 
cp summary.out HadGEM2_ES_cmfw_summary.out 
cp year_summary.out HadGEM2_ES_cmfw_year_summary.out
cp harvest.csv HadGEM2_ES_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cmfw_soiln.out
cp vswc.out HadGEM2_ES_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis inmcm4_cmfw.lis 
cp summary.out inmcm4_cmfw_summary.out 
cp year_summary.out inmcm4_cmfw_year_summary.out
cp harvest.csv inmcm4_cmfw_harvest.csv	
cp dc_sip.csv inmcm4_cmfw_dc_sip.csv	
cp soiln.out inmcm4_cmfw_soiln.out
cp vswc.out inmcm4_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5ALR_cmfw.lis 
cp summary.out IPSL_CM5ALR_cmfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cmfw_soiln.out
cp vswc.out IPSL_CM5ALR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5BLR_cmfw.lis 
cp summary.out IPSL_CM5BLR_cmfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cmfw_soiln.out
cp vswc.out IPSL_CM5BLR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC5_cmfw.lis 
cp summary.out MIROC5_cmfw_summary.out 
cp year_summary.out MIROC5_cmfw_year_summary.out
cp harvest.csv MIROC5_cmfw_harvest.csv	
cp dc_sip.csv MIROC5_cmfw_dc_sip.csv	
cp soiln.out MIROC5_cmfw_soiln.out
cp vswc.out MIROC5_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC_CHEM_cmfw.lis 
cp summary.out MIROC_CHEM_cmfw_summary.out 
cp year_summary.out MIROC_CHEM_cmfw_year_summary.out
cp harvest.csv MIROC_CHEM_cmfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cmfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cmfw_soiln.out
cp vswc.out MIROC_CHEM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MRI_CGCM3_cmfw.lis 
cp summary.out MRI_CGCM3_cmfw_summary.out 
cp year_summary.out MRI_CGCM3_cmfw_year_summary.out
cp harvest.csv MRI_CGCM3_cmfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cmfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cmfw_soiln.out
cp vswc.out MRI_CGCM3_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11m_mfwc.lis 
cp summary.out bcc_csm11m_mfwc_summary.out 
cp year_summary.out bcc_csm11m_mfwc_year_summary.out
cp harvest.csv bcc_csm11m_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11m_mfwc_soiln.out
cp vswc.out bcc_csm11m_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11_mfwc.lis 
cp summary.out bcc_csm11_mfwc_summary.out 
cp year_summary.out bcc_csm11_mfwc_year_summary.out
cp harvest.csv bcc_csm11_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11_mfwc_soiln.out
cp vswc.out bcc_csm11_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis BNU_mfwc.lis 
cp summary.out BNU_mfwc_summary.out 
cp year_summary.out BNU_mfwc_year_summary.out
cp harvest.csv BNU_mfwc_harvest.csv	
cp dc_sip.csv BNU_mfwc_dc_sip.csv	
cp soiln.out BNU_mfwc_soiln.out
cp vswc.out BNU_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CanESM2_mfwc.lis 
cp summary.out CanESM2_mfwc_summary.out 
cp year_summary.out CanESM2_mfwc_year_summary.out
cp harvest.csv CanESM2_mfwc_harvest.csv	
cp dc_sip.csv CanESM2_mfwc_dc_sip.csv	
cp soiln.out CanESM2_mfwc_soiln.out
cp vswc.out CanESM2_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CNRM_mfwc.lis 
cp summary.out CNRM_mfwc_summary.out 
cp year_summary.out CNRM_mfwc_year_summary.out
cp harvest.csv CNRM_mfwc_harvest.csv	
cp dc_sip.csv CNRM_mfwc_dc_sip.csv	
cp soiln.out CNRM_mfwc_soiln.out
cp vswc.out CNRM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CSIRO_mfwc.lis 
cp summary.out CSIRO_mfwc_summary.out 
cp year_summary.out CSIRO_mfwc_year_summary.out
cp harvest.csv CSIRO_mfwc_harvest.csv	
cp dc_sip.csv CSIRO_mfwc_dc_sip.csv	
cp soiln.out CSIRO_mfwc_soiln.out
cp vswc.out CSIRO_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2G_mfwc.lis 
cp summary.out GFDL_ESM2G_mfwc_summary.out 
cp year_summary.out GFDL_ESM2G_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2G_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_mfwc_soiln.out
cp vswc.out GFDL_ESM2G_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2M_mfwc.lis 
cp summary.out GFDL_ESM2M_mfwc_summary.out 
cp year_summary.out GFDL_ESM2M_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2M_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_mfwc_soiln.out
cp vswc.out GFDL_ESM2M_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_CC_mfwc.lis 
cp summary.out HadGEM2_CC_mfwc_summary.out 
cp year_summary.out HadGEM2_CC_mfwc_year_summary.out
cp harvest.csv HadGEM2_CC_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_mfwc_soiln.out
cp vswc.out HadGEM2_CC_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_ES_mfwc.lis 
cp summary.out HadGEM2_ES_mfwc_summary.out 
cp year_summary.out HadGEM2_ES_mfwc_year_summary.out
cp harvest.csv HadGEM2_ES_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_mfwc_soiln.out
cp vswc.out HadGEM2_ES_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis inmcm4_mfwc.lis 
cp summary.out inmcm4_mfwc_summary.out 
cp year_summary.out inmcm4_mfwc_year_summary.out
cp harvest.csv inmcm4_mfwc_harvest.csv	
cp dc_sip.csv inmcm4_mfwc_dc_sip.csv	
cp soiln.out inmcm4_mfwc_soiln.out
cp vswc.out inmcm4_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5ALR_mfwc.lis 
cp summary.out IPSL_CM5ALR_mfwc_summary.out 
cp year_summary.out IPSL_CM5ALR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_mfwc_soiln.out
cp vswc.out IPSL_CM5ALR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5BLR_mfwc.lis 
cp summary.out IPSL_CM5BLR_mfwc_summary.out 
cp year_summary.out IPSL_CM5BLR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_mfwc_soiln.out
cp vswc.out IPSL_CM5BLR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC5_mfwc.lis 
cp summary.out MIROC5_mfwc_summary.out 
cp year_summary.out MIROC5_mfwc_year_summary.out
cp harvest.csv MIROC5_mfwc_harvest.csv	
cp dc_sip.csv MIROC5_mfwc_dc_sip.csv	
cp soiln.out MIROC5_mfwc_soiln.out
cp vswc.out MIROC5_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC_CHEM_mfwc.lis 
cp summary.out MIROC_CHEM_mfwc_summary.out 
cp year_summary.out MIROC_CHEM_mfwc_year_summary.out
cp harvest.csv MIROC_CHEM_mfwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_mfwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_mfwc_soiln.out
cp vswc.out MIROC_CHEM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MRI_CGCM3_mfwc.lis 
cp summary.out MRI_CGCM3_mfwc_summary.out 
cp year_summary.out MRI_CGCM3_mfwc_year_summary.out
cp harvest.csv MRI_CGCM3_mfwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_mfwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_mfwc_soiln.out
cp vswc.out MRI_CGCM3_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11m_fwcm.lis 
cp summary.out bcc_csm11m_fwcm_summary.out 
cp year_summary.out bcc_csm11m_fwcm_year_summary.out
cp harvest.csv bcc_csm11m_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11m_fwcm_soiln.out
cp vswc.out bcc_csm11m_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11_fwcm.lis 
cp summary.out bcc_csm11_fwcm_summary.out 
cp year_summary.out bcc_csm11_fwcm_year_summary.out
cp harvest.csv bcc_csm11_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11_fwcm_soiln.out
cp vswc.out bcc_csm11_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis BNU_fwcm.lis 
cp summary.out BNU_fwcm_summary.out 
cp year_summary.out BNU_fwcm_year_summary.out
cp harvest.csv BNU_fwcm_harvest.csv	
cp dc_sip.csv BNU_fwcm_dc_sip.csv	
cp soiln.out BNU_fwcm_soiln.out
cp vswc.out BNU_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CanESM2_fwcm.lis 
cp summary.out CanESM2_fwcm_summary.out 
cp year_summary.out CanESM2_fwcm_year_summary.out
cp harvest.csv CanESM2_fwcm_harvest.csv	
cp dc_sip.csv CanESM2_fwcm_dc_sip.csv	
cp soiln.out CanESM2_fwcm_soiln.out
cp vswc.out CanESM2_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CNRM_fwcm.lis 
cp summary.out CNRM_fwcm_summary.out 
cp year_summary.out CNRM_fwcm_year_summary.out
cp harvest.csv CNRM_fwcm_harvest.csv	
cp dc_sip.csv CNRM_fwcm_dc_sip.csv	
cp soiln.out CNRM_fwcm_soiln.out
cp vswc.out CNRM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CSIRO_fwcm.lis 
cp summary.out CSIRO_fwcm_summary.out 
cp year_summary.out CSIRO_fwcm_year_summary.out
cp harvest.csv CSIRO_fwcm_harvest.csv	
cp dc_sip.csv CSIRO_fwcm_dc_sip.csv	
cp soiln.out CSIRO_fwcm_soiln.out
cp vswc.out CSIRO_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2G_fwcm.lis 
cp summary.out GFDL_ESM2G_fwcm_summary.out 
cp year_summary.out GFDL_ESM2G_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2G_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwcm_soiln.out
cp vswc.out GFDL_ESM2G_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2M_fwcm.lis 
cp summary.out GFDL_ESM2M_fwcm_summary.out 
cp year_summary.out GFDL_ESM2M_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2M_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwcm_soiln.out
cp vswc.out GFDL_ESM2M_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_CC_fwcm.lis 
cp summary.out HadGEM2_CC_fwcm_summary.out 
cp year_summary.out HadGEM2_CC_fwcm_year_summary.out
cp harvest.csv HadGEM2_CC_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwcm_soiln.out
cp vswc.out HadGEM2_CC_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_ES_fwcm.lis 
cp summary.out HadGEM2_ES_fwcm_summary.out 
cp year_summary.out HadGEM2_ES_fwcm_year_summary.out
cp harvest.csv HadGEM2_ES_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwcm_soiln.out
cp vswc.out HadGEM2_ES_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis inmcm4_fwcm.lis 
cp summary.out inmcm4_fwcm_summary.out 
cp year_summary.out inmcm4_fwcm_year_summary.out
cp harvest.csv inmcm4_fwcm_harvest.csv	
cp dc_sip.csv inmcm4_fwcm_dc_sip.csv	
cp soiln.out inmcm4_fwcm_soiln.out
cp vswc.out inmcm4_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5ALR_fwcm.lis 
cp summary.out IPSL_CM5ALR_fwcm_summary.out 
cp year_summary.out IPSL_CM5ALR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwcm_soiln.out
cp vswc.out IPSL_CM5ALR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5BLR_fwcm.lis 
cp summary.out IPSL_CM5BLR_fwcm_summary.out 
cp year_summary.out IPSL_CM5BLR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwcm_soiln.out
cp vswc.out IPSL_CM5BLR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC5_fwcm.lis 
cp summary.out MIROC5_fwcm_summary.out 
cp year_summary.out MIROC5_fwcm_year_summary.out
cp harvest.csv MIROC5_fwcm_harvest.csv	
cp dc_sip.csv MIROC5_fwcm_dc_sip.csv	
cp soiln.out MIROC5_fwcm_soiln.out
cp vswc.out MIROC5_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC_CHEM_fwcm.lis 
cp summary.out MIROC_CHEM_fwcm_summary.out 
cp year_summary.out MIROC_CHEM_fwcm_year_summary.out
cp harvest.csv MIROC_CHEM_fwcm_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwcm_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwcm_soiln.out
cp vswc.out MIROC_CHEM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MRI_CGCM3_fwcm.lis 
cp summary.out MRI_CGCM3_fwcm_summary.out 
cp year_summary.out MRI_CGCM3_fwcm_year_summary.out
cp harvest.csv MRI_CGCM3_fwcm_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwcm_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwcm_soiln.out
cp vswc.out MRI_CGCM3_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_side_$f"; done
for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### OPPORTUNITY CROP ROTATION (CONTINUOUS CROPPING) FOR SIDESLOPES

cp spin.1 spin.bin
cp base.1 base.bin

cp rot10_side.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11m_opp.lis 
cp summary.out bcc_csm11m_opp_summary.out 
cp year_summary.out bcc_csm11m_opp_year_summary.out
cp harvest.csv bcc_csm11m_opp_harvest.csv	
cp dc_sip.csv bcc_csm11m_opp_dc_sip.csv	
cp soiln.out bcc_csm11m_opp_soiln.out
cp vswc.out bcc_csm11m_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11_opp.lis 
cp summary.out bcc_csm11_opp_summary.out 
cp year_summary.out bcc_csm11_opp_year_summary.out
cp harvest.csv bcc_csm11_opp_harvest.csv	
cp dc_sip.csv bcc_csm11_opp_dc_sip.csv	
cp soiln.out bcc_csm11_opp_soiln.out
cp vswc.out bcc_csm11_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis BNU_opp.lis 
cp summary.out BNU_opp_summary.out 
cp year_summary.out BNU_opp_year_summary.out
cp harvest.csv BNU_opp_harvest.csv	
cp dc_sip.csv BNU_opp_dc_sip.csv	
cp soiln.out BNU_opp_soiln.out
cp vswc.out BNU_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CanESM2_opp.lis 
cp summary.out CanESM2_opp_summary.out 
cp year_summary.out CanESM2_opp_year_summary.out
cp harvest.csv CanESM2_opp_harvest.csv	
cp dc_sip.csv CanESM2_opp_dc_sip.csv	
cp soiln.out CanESM2_opp_soiln.out
cp vswc.out CanESM2_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CNRM_opp.lis 
cp summary.out CNRM_opp_summary.out 
cp year_summary.out CNRM_opp_year_summary.out
cp harvest.csv CNRM_opp_harvest.csv	
cp dc_sip.csv CNRM_opp_dc_sip.csv	
cp soiln.out CNRM_opp_soiln.out
cp vswc.out CNRM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CSIRO_opp.lis 
cp summary.out CSIRO_opp_summary.out 
cp year_summary.out CSIRO_opp_year_summary.out
cp harvest.csv CSIRO_opp_harvest.csv	
cp dc_sip.csv CSIRO_opp_dc_sip.csv	
cp soiln.out CSIRO_opp_soiln.out
cp vswc.out CSIRO_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2G_opp.lis 
cp summary.out GFDL_ESM2G_opp_summary.out 
cp year_summary.out GFDL_ESM2G_opp_year_summary.out
cp harvest.csv GFDL_ESM2G_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2G_opp_soiln.out
cp vswc.out GFDL_ESM2G_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2M_opp.lis 
cp summary.out GFDL_ESM2M_opp_summary.out 
cp year_summary.out GFDL_ESM2M_opp_year_summary.out
cp harvest.csv GFDL_ESM2M_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2M_opp_soiln.out
cp vswc.out GFDL_ESM2M_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_CC_opp.lis 
cp summary.out HadGEM2_CC_opp_summary.out 
cp year_summary.out HadGEM2_CC_opp_year_summary.out
cp harvest.csv HadGEM2_CC_opp_harvest.csv	
cp dc_sip.csv HadGEM2_CC_opp_dc_sip.csv	
cp soiln.out HadGEM2_CC_opp_soiln.out
cp vswc.out HadGEM2_CC_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_ES_opp.lis 
cp summary.out HadGEM2_ES_opp_summary.out 
cp year_summary.out HadGEM2_ES_opp_year_summary.out
cp harvest.csv HadGEM2_ES_opp_harvest.csv	
cp dc_sip.csv HadGEM2_ES_opp_dc_sip.csv	
cp soiln.out HadGEM2_ES_opp_soiln.out
cp vswc.out HadGEM2_ES_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis inmcm4_opp.lis 
cp summary.out inmcm4_opp_summary.out 
cp year_summary.out inmcm4_opp_year_summary.out
cp harvest.csv inmcm4_opp_harvest.csv	
cp dc_sip.csv inmcm4_opp_dc_sip.csv	
cp soiln.out inmcm4_opp_soiln.out
cp vswc.out inmcm4_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5ALR_opp.lis 
cp summary.out IPSL_CM5ALR_opp_summary.out 
cp year_summary.out IPSL_CM5ALR_opp_year_summary.out
cp harvest.csv IPSL_CM5ALR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_opp_soiln.out
cp vswc.out IPSL_CM5ALR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5BLR_opp.lis 
cp summary.out IPSL_CM5BLR_opp_summary.out 
cp year_summary.out IPSL_CM5BLR_opp_year_summary.out
cp harvest.csv IPSL_CM5BLR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_opp_soiln.out
cp vswc.out IPSL_CM5BLR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC5_opp.lis 
cp summary.out MIROC5_opp_summary.out 
cp year_summary.out MIROC5_opp_year_summary.out
cp harvest.csv MIROC5_opp_harvest.csv	
cp dc_sip.csv MIROC5_opp_dc_sip.csv	
cp soiln.out MIROC5_opp_soiln.out
cp vswc.out MIROC5_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC_CHEM_opp.lis 
cp summary.out MIROC_CHEM_opp_summary.out 
cp year_summary.out MIROC_CHEM_opp_year_summary.out
cp harvest.csv MIROC_CHEM_opp_harvest.csv	
cp dc_sip.csv MIROC_CHEM_opp_dc_sip.csv	
cp soiln.out MIROC_CHEM_opp_soiln.out
cp vswc.out MIROC_CHEM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MRI_CGCM3_opp.lis 
cp summary.out MRI_CGCM3_opp_summary.out 
cp year_summary.out MRI_CGCM3_opp_year_summary.out
cp harvest.csv MRI_CGCM3_opp_harvest.csv	
cp dc_sip.csv MRI_CGCM3_opp_dc_sip.csv	
cp soiln.out MRI_CGCM3_opp_soiln.out
cp vswc.out MRI_CGCM3_opp_vswc.out

rm opp.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_side_$f"; done
for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### GRASSLAND FOR SIDESLOPES

cp base.1 base.bin
cp spin.1 spin.bin

cp grass_09.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth
cp f_grass.sch grass.sch

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11m_grass.lis 
cp summary.out bcc_csm11m_grass_summary.out 
cp year_summary.out bcc_csm11m_grass_year_summary.out
cp harvest.csv bcc_csm11m_grass_harvest.csv	
cp dc_sip.csv bcc_csm11m_grass_dc_sip.csv	
cp soiln.out bcc_csm11m_grass_soiln.out
cp vswc.out bcc_csm11m_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11_grass.lis 
cp summary.out bcc_csm11_grass_summary.out 
cp year_summary.out bcc_csm11_grass_year_summary.out
cp harvest.csv bcc_csm11_grass_harvest.csv	
cp dc_sip.csv bcc_csm11_grass_dc_sip.csv	
cp soiln.out bcc_csm11_grass_soiln.out
cp vswc.out bcc_csm11_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis BNU_grass.lis 
cp summary.out BNU_grass_summary.out 
cp year_summary.out BNU_grass_year_summary.out
cp harvest.csv BNU_grass_harvest.csv	
cp dc_sip.csv BNU_grass_dc_sip.csv	
cp soiln.out BNU_grass_soiln.out
cp vswc.out BNU_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CanESM2_grass.lis 
cp summary.out CanESM2_grass_summary.out 
cp year_summary.out CanESM2_grass_year_summary.out
cp harvest.csv CanESM2_grass_harvest.csv	
cp dc_sip.csv CanESM2_grass_dc_sip.csv	
cp soiln.out CanESM2_grass_soiln.out
cp vswc.out CanESM2_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CNRM_grass.lis 
cp summary.out CNRM_grass_summary.out 
cp year_summary.out CNRM_grass_year_summary.out
cp harvest.csv CNRM_grass_harvest.csv	
cp dc_sip.csv CNRM_grass_dc_sip.csv	
cp soiln.out CNRM_grass_soiln.out
cp vswc.out CNRM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CSIRO_grass.lis 
cp summary.out CSIRO_grass_summary.out 
cp year_summary.out CSIRO_grass_year_summary.out
cp harvest.csv CSIRO_grass_harvest.csv	
cp dc_sip.csv CSIRO_grass_dc_sip.csv	
cp soiln.out CSIRO_grass_soiln.out
cp vswc.out CSIRO_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2G_grass.lis 
cp summary.out GFDL_ESM2G_grass_summary.out 
cp year_summary.out GFDL_ESM2G_grass_year_summary.out
cp harvest.csv GFDL_ESM2G_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2G_grass_soiln.out
cp vswc.out GFDL_ESM2G_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2M_grass.lis 
cp summary.out GFDL_ESM2M_grass_summary.out 
cp year_summary.out GFDL_ESM2M_grass_year_summary.out
cp harvest.csv GFDL_ESM2M_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2M_grass_soiln.out
cp vswc.out GFDL_ESM2M_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_CC_grass.lis 
cp summary.out HadGEM2_CC_grass_summary.out 
cp year_summary.out HadGEM2_CC_grass_year_summary.out
cp harvest.csv HadGEM2_CC_grass_harvest.csv	
cp dc_sip.csv HadGEM2_CC_grass_dc_sip.csv	
cp soiln.out HadGEM2_CC_grass_soiln.out
cp vswc.out HadGEM2_CC_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_ES_grass.lis 
cp summary.out HadGEM2_ES_grass_summary.out 
cp year_summary.out HadGEM2_ES_grass_year_summary.out
cp harvest.csv HadGEM2_ES_grass_harvest.csv	
cp dc_sip.csv HadGEM2_ES_grass_dc_sip.csv	
cp soiln.out HadGEM2_ES_grass_soiln.out
cp vswc.out HadGEM2_ES_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis inmcm4_grass.lis 
cp summary.out inmcm4_grass_summary.out 
cp year_summary.out inmcm4_grass_year_summary.out
cp harvest.csv inmcm4_grass_harvest.csv	
cp dc_sip.csv inmcm4_grass_dc_sip.csv	
cp soiln.out inmcm4_grass_soiln.out
cp vswc.out inmcm4_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5ALR_grass.lis 
cp summary.out IPSL_CM5ALR_grass_summary.out 
cp year_summary.out IPSL_CM5ALR_grass_year_summary.out
cp harvest.csv IPSL_CM5ALR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_grass_soiln.out
cp vswc.out IPSL_CM5ALR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5BLR_grass.lis 
cp summary.out IPSL_CM5BLR_grass_summary.out 
cp year_summary.out IPSL_CM5BLR_grass_year_summary.out
cp harvest.csv IPSL_CM5BLR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_grass_soiln.out
cp vswc.out IPSL_CM5BLR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC5_grass.lis 
cp summary.out MIROC5_grass_summary.out 
cp year_summary.out MIROC5_grass_year_summary.out
cp harvest.csv MIROC5_grass_harvest.csv	
cp dc_sip.csv MIROC5_grass_dc_sip.csv	
cp soiln.out MIROC5_grass_soiln.out
cp vswc.out MIROC5_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC_CHEM_grass.lis 
cp summary.out MIROC_CHEM_grass_summary.out 
cp year_summary.out MIROC_CHEM_grass_year_summary.out
cp harvest.csv MIROC_CHEM_grass_harvest.csv	
cp dc_sip.csv MIROC_CHEM_grass_dc_sip.csv	
cp soiln.out MIROC_CHEM_grass_soiln.out
cp vswc.out MIROC_CHEM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MRI_CGCM3_grass.lis 
cp summary.out MRI_CGCM3_grass_summary.out 
cp year_summary.out MRI_CGCM3_grass_year_summary.out
cp harvest.csv MRI_CGCM3_grass_harvest.csv	
cp dc_sip.csv MRI_CGCM3_grass_dc_sip.csv	
cp soiln.out MRI_CGCM3_grass_soiln.out
cp vswc.out MRI_CGCM3_grass_vswc.out

rm grass.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_side_$f"; done
for f in *.lis; do mv "$f" "ste_side_$f"; done
for f in *.out; do mv "$f" "ste_side_$f"; done
for f in *.csv; do mv "$f" "ste_side_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm soils.in

####### FOR TOESLOPE

cp toe.in soils.in

./DDcentEVI -s spin -n spin
./DDClist100 spin spin outvars.txt

./DDcentEVI -s base -n base -e spin
./DDClist100 base base outvars.txt

cp rot1_toe.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11m_wf.lis 
cp summary.out bcc_csm11m_wf_summary.out 
cp year_summary.out bcc_csm11m_wf_year_summary.out
cp harvest.csv bcc_csm11m_wf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wf_dc_sip.csv	
cp soiln.out bcc_csm11m_wf_soiln.out
cp vswc.out bcc_csm11m_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis bcc_csm11_wf.lis 
cp summary.out bcc_csm11_wf_summary.out 
cp year_summary.out bcc_csm11_wf_year_summary.out
cp harvest.csv bcc_csm11_wf_harvest.csv	
cp dc_sip.csv bcc_csm11_wf_dc_sip.csv	
cp soiln.out bcc_csm11_wf_soiln.out
cp vswc.out bcc_csm11_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis BNU_wf.lis 
cp summary.out BNU_wf_summary.out 
cp year_summary.out BNU_wf_year_summary.out
cp harvest.csv BNU_wf_harvest.csv	
cp dc_sip.csv BNU_wf_dc_sip.csv	
cp soiln.out BNU_wf_soiln.out
cp vswc.out BNU_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CanESM2_wf.lis 
cp summary.out CanESM2_wf_summary.out 
cp year_summary.out CanESM2_wf_year_summary.out
cp harvest.csv CanESM2_wf_harvest.csv	
cp dc_sip.csv CanESM2_wf_dc_sip.csv	
cp soiln.out CanESM2_wf_soiln.out
cp vswc.out CanESM2_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CNRM_wf.lis 
cp summary.out CNRM_wf_summary.out 
cp year_summary.out CNRM_wf_year_summary.out
cp harvest.csv CNRM_wf_harvest.csv	
cp dc_sip.csv CNRM_wf_dc_sip.csv	
cp soiln.out CNRM_wf_soiln.out
cp vswc.out CNRM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis CSIRO_wf.lis 
cp summary.out CSIRO_wf_summary.out 
cp year_summary.out CSIRO_wf_year_summary.out
cp harvest.csv CSIRO_wf_harvest.csv	
cp dc_sip.csv CSIRO_wf_dc_sip.csv	
cp soiln.out CSIRO_wf_soiln.out
cp vswc.out CSIRO_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2G_wf.lis 
cp summary.out GFDL_ESM2G_wf_summary.out 
cp year_summary.out GFDL_ESM2G_wf_year_summary.out
cp harvest.csv GFDL_ESM2G_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wf_soiln.out
cp vswc.out GFDL_ESM2G_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis GFDL_ESM2M_wf.lis 
cp summary.out GFDL_ESM2M_wf_summary.out 
cp year_summary.out GFDL_ESM2M_wf_year_summary.out
cp harvest.csv GFDL_ESM2M_wf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wf_soiln.out
cp vswc.out GFDL_ESM2M_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_CC_wf.lis 
cp summary.out HadGEM2_CC_wf_summary.out 
cp year_summary.out HadGEM2_CC_wf_year_summary.out
cp harvest.csv HadGEM2_CC_wf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wf_soiln.out
cp vswc.out HadGEM2_CC_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis HadGEM2_ES_wf.lis 
cp summary.out HadGEM2_ES_wf_summary.out 
cp year_summary.out HadGEM2_ES_wf_year_summary.out
cp harvest.csv HadGEM2_ES_wf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wf_soiln.out
cp vswc.out HadGEM2_ES_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis inmcm4_wf.lis 
cp summary.out inmcm4_wf_summary.out 
cp year_summary.out inmcm4_wf_year_summary.out
cp harvest.csv inmcm4_wf_harvest.csv	
cp dc_sip.csv inmcm4_wf_dc_sip.csv	
cp soiln.out inmcm4_wf_soiln.out
cp vswc.out inmcm4_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5ALR_wf.lis 
cp summary.out IPSL_CM5ALR_wf_summary.out 
cp year_summary.out IPSL_CM5ALR_wf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wf_soiln.out
cp vswc.out IPSL_CM5ALR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis IPSL_CM5BLR_wf.lis 
cp summary.out IPSL_CM5BLR_wf_summary.out 
cp year_summary.out IPSL_CM5BLR_wf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wf_soiln.out
cp vswc.out IPSL_CM5BLR_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC5_wf.lis 
cp summary.out MIROC5_wf_summary.out 
cp year_summary.out MIROC5_wf_year_summary.out
cp harvest.csv MIROC5_wf_harvest.csv	
cp dc_sip.csv MIROC5_wf_dc_sip.csv	
cp soiln.out MIROC5_wf_soiln.out
cp vswc.out MIROC5_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MIROC_CHEM_wf.lis 
cp summary.out MIROC_CHEM_wf_summary.out 
cp year_summary.out MIROC_CHEM_wf_year_summary.out
cp harvest.csv MIROC_CHEM_wf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wf_soiln.out
cp vswc.out MIROC_CHEM_wf_vswc.out

rm wf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wf -n wf -e base2 
./DDClist100 wf wf outvars.txt

cp wf.lis MRI_CGCM3_wf.lis 
cp summary.out MRI_CGCM3_wf_summary.out 
cp year_summary.out MRI_CGCM3_wf_year_summary.out
cp harvest.csv MRI_CGCM3_wf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wf_soiln.out
cp vswc.out MRI_CGCM3_wf_vswc.out

rm wf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11m_fw.lis 
cp summary.out bcc_csm11m_fw_summary.out 
cp year_summary.out bcc_csm11m_fw_year_summary.out
cp harvest.csv bcc_csm11m_fw_harvest.csv	
cp dc_sip.csv bcc_csm11m_fw_dc_sip.csv	
cp soiln.out bcc_csm11m_fw_soiln.out
cp vswc.out bcc_csm11m_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis bcc_csm11_fw.lis 
cp summary.out bcc_csm11_fw_summary.out 
cp year_summary.out bcc_csm11_fw_year_summary.out
cp harvest.csv bcc_csm11_fw_harvest.csv	
cp dc_sip.csv bcc_csm11_fw_dc_sip.csv	
cp soiln.out bcc_csm11_fw_soiln.out
cp vswc.out bcc_csm11_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis BNU_fw.lis 
cp summary.out BNU_fw_summary.out 
cp year_summary.out BNU_fw_year_summary.out
cp harvest.csv BNU_fw_harvest.csv	
cp dc_sip.csv BNU_fw_dc_sip.csv	
cp soiln.out BNU_fw_soiln.out
cp vswc.out BNU_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CanESM2_fw.lis 
cp summary.out CanESM2_fw_summary.out 
cp year_summary.out CanESM2_fw_year_summary.out
cp harvest.csv CanESM2_fw_harvest.csv	
cp dc_sip.csv CanESM2_fw_dc_sip.csv	
cp soiln.out CanESM2_fw_soiln.out
cp vswc.out CanESM2_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CNRM_fw.lis 
cp summary.out CNRM_fw_summary.out 
cp year_summary.out CNRM_fw_year_summary.out
cp harvest.csv CNRM_fw_harvest.csv	
cp dc_sip.csv CNRM_fw_dc_sip.csv	
cp soiln.out CNRM_fw_soiln.out
cp vswc.out CNRM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis CSIRO_fw.lis 
cp summary.out CSIRO_fw_summary.out 
cp year_summary.out CSIRO_fw_year_summary.out
cp harvest.csv CSIRO_fw_harvest.csv	
cp dc_sip.csv CSIRO_fw_dc_sip.csv	
cp soiln.out CSIRO_fw_soiln.out
cp vswc.out CSIRO_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2G_fw.lis 
cp summary.out GFDL_ESM2G_fw_summary.out 
cp year_summary.out GFDL_ESM2G_fw_year_summary.out
cp harvest.csv GFDL_ESM2G_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fw_soiln.out
cp vswc.out GFDL_ESM2G_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis GFDL_ESM2M_fw.lis 
cp summary.out GFDL_ESM2M_fw_summary.out 
cp year_summary.out GFDL_ESM2M_fw_year_summary.out
cp harvest.csv GFDL_ESM2M_fw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fw_soiln.out
cp vswc.out GFDL_ESM2M_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_CC_fw.lis 
cp summary.out HadGEM2_CC_fw_summary.out 
cp year_summary.out HadGEM2_CC_fw_year_summary.out
cp harvest.csv HadGEM2_CC_fw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fw_dc_sip.csv	
cp soiln.out HadGEM2_CC_fw_soiln.out
cp vswc.out HadGEM2_CC_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis HadGEM2_ES_fw.lis 
cp summary.out HadGEM2_ES_fw_summary.out 
cp year_summary.out HadGEM2_ES_fw_year_summary.out
cp harvest.csv HadGEM2_ES_fw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fw_dc_sip.csv	
cp soiln.out HadGEM2_ES_fw_soiln.out
cp vswc.out HadGEM2_ES_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis inmcm4_fw.lis 
cp summary.out inmcm4_fw_summary.out 
cp year_summary.out inmcm4_fw_year_summary.out
cp harvest.csv inmcm4_fw_harvest.csv	
cp dc_sip.csv inmcm4_fw_dc_sip.csv	
cp soiln.out inmcm4_fw_soiln.out
cp vswc.out inmcm4_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5ALR_fw.lis 
cp summary.out IPSL_CM5ALR_fw_summary.out 
cp year_summary.out IPSL_CM5ALR_fw_year_summary.out
cp harvest.csv IPSL_CM5ALR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fw_soiln.out
cp vswc.out IPSL_CM5ALR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis IPSL_CM5BLR_fw.lis 
cp summary.out IPSL_CM5BLR_fw_summary.out 
cp year_summary.out IPSL_CM5BLR_fw_year_summary.out
cp harvest.csv IPSL_CM5BLR_fw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fw_soiln.out
cp vswc.out IPSL_CM5BLR_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC5_fw.lis 
cp summary.out MIROC5_fw_summary.out 
cp year_summary.out MIROC5_fw_year_summary.out
cp harvest.csv MIROC5_fw_harvest.csv	
cp dc_sip.csv MIROC5_fw_dc_sip.csv	
cp soiln.out MIROC5_fw_soiln.out
cp vswc.out MIROC5_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MIROC_CHEM_fw.lis 
cp summary.out MIROC_CHEM_fw_summary.out 
cp year_summary.out MIROC_CHEM_fw_year_summary.out
cp harvest.csv MIROC_CHEM_fw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fw_dc_sip.csv	
cp soiln.out MIROC_CHEM_fw_soiln.out
cp vswc.out MIROC_CHEM_fw_vswc.out

rm fw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fw -n fw -e base2 
./DDClist100 fw fw outvars.txt

cp fw.lis MRI_CGCM3_fw.lis 
cp summary.out MRI_CGCM3_fw_summary.out 
cp year_summary.out MRI_CGCM3_fw_year_summary.out
cp harvest.csv MRI_CGCM3_fw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fw_dc_sip.csv	
cp soiln.out MRI_CGCM3_fw_soiln.out
cp vswc.out MRI_CGCM3_fw_vswc.out

rm fw.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_toe_$f"; done
for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FW/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-FALLOW ROTATION FOR TOESLOPES

cp base.1 base.bin
cp spin.1 spin.bin

cp rot3_toe.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11m_wcf.lis 
cp summary.out bcc_csm11m_wcf_summary.out 
cp year_summary.out bcc_csm11m_wcf_year_summary.out
cp harvest.csv bcc_csm11m_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcf_soiln.out
cp vswc.out bcc_csm11m_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis bcc_csm11_wcf.lis 
cp summary.out bcc_csm11_wcf_summary.out 
cp year_summary.out bcc_csm11_wcf_year_summary.out
cp harvest.csv bcc_csm11_wcf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcf_dc_sip.csv	
cp soiln.out bcc_csm11_wcf_soiln.out
cp vswc.out bcc_csm11_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis BNU_wcf.lis 
cp summary.out BNU_wcf_summary.out 
cp year_summary.out BNU_wcf_year_summary.out
cp harvest.csv BNU_wcf_harvest.csv	
cp dc_sip.csv BNU_wcf_dc_sip.csv	
cp soiln.out BNU_wcf_soiln.out
cp vswc.out BNU_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CanESM2_wcf.lis 
cp summary.out CanESM2_wcf_summary.out 
cp year_summary.out CanESM2_wcf_year_summary.out
cp harvest.csv CanESM2_wcf_harvest.csv	
cp dc_sip.csv CanESM2_wcf_dc_sip.csv	
cp soiln.out CanESM2_wcf_soiln.out
cp vswc.out CanESM2_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CNRM_wcf.lis 
cp summary.out CNRM_wcf_summary.out 
cp year_summary.out CNRM_wcf_year_summary.out
cp harvest.csv CNRM_wcf_harvest.csv	
cp dc_sip.csv CNRM_wcf_dc_sip.csv	
cp soiln.out CNRM_wcf_soiln.out
cp vswc.out CNRM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis CSIRO_wcf.lis 
cp summary.out CSIRO_wcf_summary.out 
cp year_summary.out CSIRO_wcf_year_summary.out
cp harvest.csv CSIRO_wcf_harvest.csv	
cp dc_sip.csv CSIRO_wcf_dc_sip.csv	
cp soiln.out CSIRO_wcf_soiln.out
cp vswc.out CSIRO_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2G_wcf.lis 
cp summary.out GFDL_ESM2G_wcf_summary.out 
cp year_summary.out GFDL_ESM2G_wcf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcf_soiln.out
cp vswc.out GFDL_ESM2G_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis GFDL_ESM2M_wcf.lis 
cp summary.out GFDL_ESM2M_wcf_summary.out 
cp year_summary.out GFDL_ESM2M_wcf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcf_soiln.out
cp vswc.out GFDL_ESM2M_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_CC_wcf.lis 
cp summary.out HadGEM2_CC_wcf_summary.out 
cp year_summary.out HadGEM2_CC_wcf_year_summary.out
cp harvest.csv HadGEM2_CC_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcf_soiln.out
cp vswc.out HadGEM2_CC_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis HadGEM2_ES_wcf.lis 
cp summary.out HadGEM2_ES_wcf_summary.out 
cp year_summary.out HadGEM2_ES_wcf_year_summary.out
cp harvest.csv HadGEM2_ES_wcf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcf_soiln.out
cp vswc.out HadGEM2_ES_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis inmcm4_wcf.lis 
cp summary.out inmcm4_wcf_summary.out 
cp year_summary.out inmcm4_wcf_year_summary.out
cp harvest.csv inmcm4_wcf_harvest.csv	
cp dc_sip.csv inmcm4_wcf_dc_sip.csv	
cp soiln.out inmcm4_wcf_soiln.out
cp vswc.out inmcm4_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5ALR_wcf.lis 
cp summary.out IPSL_CM5ALR_wcf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcf_soiln.out
cp vswc.out IPSL_CM5ALR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis IPSL_CM5BLR_wcf.lis 
cp summary.out IPSL_CM5BLR_wcf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcf_soiln.out
cp vswc.out IPSL_CM5BLR_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC5_wcf.lis 
cp summary.out MIROC5_wcf_summary.out 
cp year_summary.out MIROC5_wcf_year_summary.out
cp harvest.csv MIROC5_wcf_harvest.csv	
cp dc_sip.csv MIROC5_wcf_dc_sip.csv	
cp soiln.out MIROC5_wcf_soiln.out
cp vswc.out MIROC5_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MIROC_CHEM_wcf.lis 
cp summary.out MIROC_CHEM_wcf_summary.out 
cp year_summary.out MIROC_CHEM_wcf_year_summary.out
cp harvest.csv MIROC_CHEM_wcf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcf_soiln.out
cp vswc.out MIROC_CHEM_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcf -n wcf -e base2 
./DDClist100 wcf wcf outvars.txt

cp wcf.lis MRI_CGCM3_wcf.lis 
cp summary.out MRI_CGCM3_wcf_summary.out 
cp year_summary.out MRI_CGCM3_wcf_year_summary.out
cp harvest.csv MRI_CGCM3_wcf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcf_soiln.out
cp vswc.out MRI_CGCM3_wcf_vswc.out

rm wcf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11m_cfw.lis 
cp summary.out bcc_csm11m_cfw_summary.out 
cp year_summary.out bcc_csm11m_cfw_year_summary.out
cp harvest.csv bcc_csm11m_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cfw_soiln.out
cp vswc.out bcc_csm11m_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis bcc_csm11_cfw.lis 
cp summary.out bcc_csm11_cfw_summary.out 
cp year_summary.out bcc_csm11_cfw_year_summary.out
cp harvest.csv bcc_csm11_cfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cfw_dc_sip.csv	
cp soiln.out bcc_csm11_cfw_soiln.out
cp vswc.out bcc_csm11_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis BNU_cfw.lis 
cp summary.out BNU_cfw_summary.out 
cp year_summary.out BNU_cfw_year_summary.out
cp harvest.csv BNU_cfw_harvest.csv	
cp dc_sip.csv BNU_cfw_dc_sip.csv	
cp soiln.out BNU_cfw_soiln.out
cp vswc.out BNU_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CanESM2_cfw.lis 
cp summary.out CanESM2_cfw_summary.out 
cp year_summary.out CanESM2_cfw_year_summary.out
cp harvest.csv CanESM2_cfw_harvest.csv	
cp dc_sip.csv CanESM2_cfw_dc_sip.csv	
cp soiln.out CanESM2_cfw_soiln.out
cp vswc.out CanESM2_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CNRM_cfw.lis 
cp summary.out CNRM_cfw_summary.out 
cp year_summary.out CNRM_cfw_year_summary.out
cp harvest.csv CNRM_cfw_harvest.csv	
cp dc_sip.csv CNRM_cfw_dc_sip.csv	
cp soiln.out CNRM_cfw_soiln.out
cp vswc.out CNRM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis CSIRO_cfw.lis 
cp summary.out CSIRO_cfw_summary.out 
cp year_summary.out CSIRO_cfw_year_summary.out
cp harvest.csv CSIRO_cfw_harvest.csv	
cp dc_sip.csv CSIRO_cfw_dc_sip.csv	
cp soiln.out CSIRO_cfw_soiln.out
cp vswc.out CSIRO_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2G_cfw.lis 
cp summary.out GFDL_ESM2G_cfw_summary.out 
cp year_summary.out GFDL_ESM2G_cfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cfw_soiln.out
cp vswc.out GFDL_ESM2G_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis GFDL_ESM2M_cfw.lis 
cp summary.out GFDL_ESM2M_cfw_summary.out 
cp year_summary.out GFDL_ESM2M_cfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cfw_soiln.out
cp vswc.out GFDL_ESM2M_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_CC_cfw.lis 
cp summary.out HadGEM2_CC_cfw_summary.out 
cp year_summary.out HadGEM2_CC_cfw_year_summary.out
cp harvest.csv HadGEM2_CC_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cfw_soiln.out
cp vswc.out HadGEM2_CC_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis HadGEM2_ES_cfw.lis 
cp summary.out HadGEM2_ES_cfw_summary.out 
cp year_summary.out HadGEM2_ES_cfw_year_summary.out
cp harvest.csv HadGEM2_ES_cfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cfw_soiln.out
cp vswc.out HadGEM2_ES_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis inmcm4_cfw.lis 
cp summary.out inmcm4_cfw_summary.out 
cp year_summary.out inmcm4_cfw_year_summary.out
cp harvest.csv inmcm4_cfw_harvest.csv	
cp dc_sip.csv inmcm4_cfw_dc_sip.csv	
cp soiln.out inmcm4_cfw_soiln.out
cp vswc.out inmcm4_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5ALR_cfw.lis 
cp summary.out IPSL_CM5ALR_cfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cfw_soiln.out
cp vswc.out IPSL_CM5ALR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis IPSL_CM5BLR_cfw.lis 
cp summary.out IPSL_CM5BLR_cfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cfw_soiln.out
cp vswc.out IPSL_CM5BLR_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC5_cfw.lis 
cp summary.out MIROC5_cfw_summary.out 
cp year_summary.out MIROC5_cfw_year_summary.out
cp harvest.csv MIROC5_cfw_harvest.csv	
cp dc_sip.csv MIROC5_cfw_dc_sip.csv	
cp soiln.out MIROC5_cfw_soiln.out
cp vswc.out MIROC5_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MIROC_CHEM_cfw.lis 
cp summary.out MIROC_CHEM_cfw_summary.out 
cp year_summary.out MIROC_CHEM_cfw_year_summary.out
cp harvest.csv MIROC_CHEM_cfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cfw_soiln.out
cp vswc.out MIROC_CHEM_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cfw -n cfw -e base2 
./DDClist100 cfw cfw outvars.txt

cp cfw.lis MRI_CGCM3_cfw.lis 
cp summary.out MRI_CGCM3_cfw_summary.out 
cp year_summary.out MRI_CGCM3_cfw_year_summary.out
cp harvest.csv MRI_CGCM3_cfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cfw_soiln.out
cp vswc.out MRI_CGCM3_cfw_vswc.out

rm cfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CFW/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11m_fwc.lis 
cp summary.out bcc_csm11m_fwc_summary.out 
cp year_summary.out bcc_csm11m_fwc_year_summary.out
cp harvest.csv bcc_csm11m_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwc_dc_sip.csv	
cp soiln.out bcc_csm11m_fwc_soiln.out
cp vswc.out bcc_csm11m_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis bcc_csm11_fwc.lis 
cp summary.out bcc_csm11_fwc_summary.out 
cp year_summary.out bcc_csm11_fwc_year_summary.out
cp harvest.csv bcc_csm11_fwc_harvest.csv	
cp dc_sip.csv bcc_csm11_fwc_dc_sip.csv	
cp soiln.out bcc_csm11_fwc_soiln.out
cp vswc.out bcc_csm11_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis BNU_fwc.lis 
cp summary.out BNU_fwc_summary.out 
cp year_summary.out BNU_fwc_year_summary.out
cp harvest.csv BNU_fwc_harvest.csv	
cp dc_sip.csv BNU_fwc_dc_sip.csv	
cp soiln.out BNU_fwc_soiln.out
cp vswc.out BNU_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CanESM2_fwc.lis 
cp summary.out CanESM2_fwc_summary.out 
cp year_summary.out CanESM2_fwc_year_summary.out
cp harvest.csv CanESM2_fwc_harvest.csv	
cp dc_sip.csv CanESM2_fwc_dc_sip.csv	
cp soiln.out CanESM2_fwc_soiln.out
cp vswc.out CanESM2_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CNRM_fwc.lis 
cp summary.out CNRM_fwc_summary.out 
cp year_summary.out CNRM_fwc_year_summary.out
cp harvest.csv CNRM_fwc_harvest.csv	
cp dc_sip.csv CNRM_fwc_dc_sip.csv	
cp soiln.out CNRM_fwc_soiln.out
cp vswc.out CNRM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis CSIRO_fwc.lis 
cp summary.out CSIRO_fwc_summary.out 
cp year_summary.out CSIRO_fwc_year_summary.out
cp harvest.csv CSIRO_fwc_harvest.csv	
cp dc_sip.csv CSIRO_fwc_dc_sip.csv	
cp soiln.out CSIRO_fwc_soiln.out
cp vswc.out CSIRO_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2G_fwc.lis 
cp summary.out GFDL_ESM2G_fwc_summary.out 
cp year_summary.out GFDL_ESM2G_fwc_year_summary.out
cp harvest.csv GFDL_ESM2G_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwc_soiln.out
cp vswc.out GFDL_ESM2G_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis GFDL_ESM2M_fwc.lis 
cp summary.out GFDL_ESM2M_fwc_summary.out 
cp year_summary.out GFDL_ESM2M_fwc_year_summary.out
cp harvest.csv GFDL_ESM2M_fwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwc_soiln.out
cp vswc.out GFDL_ESM2M_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_CC_fwc.lis 
cp summary.out HadGEM2_CC_fwc_summary.out 
cp year_summary.out HadGEM2_CC_fwc_year_summary.out
cp harvest.csv HadGEM2_CC_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwc_soiln.out
cp vswc.out HadGEM2_CC_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis HadGEM2_ES_fwc.lis 
cp summary.out HadGEM2_ES_fwc_summary.out 
cp year_summary.out HadGEM2_ES_fwc_year_summary.out
cp harvest.csv HadGEM2_ES_fwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwc_soiln.out
cp vswc.out HadGEM2_ES_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis inmcm4_fwc.lis 
cp summary.out inmcm4_fwc_summary.out 
cp year_summary.out inmcm4_fwc_year_summary.out
cp harvest.csv inmcm4_fwc_harvest.csv	
cp dc_sip.csv inmcm4_fwc_dc_sip.csv	
cp soiln.out inmcm4_fwc_soiln.out
cp vswc.out inmcm4_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5ALR_fwc.lis 
cp summary.out IPSL_CM5ALR_fwc_summary.out 
cp year_summary.out IPSL_CM5ALR_fwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwc_soiln.out
cp vswc.out IPSL_CM5ALR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis IPSL_CM5BLR_fwc.lis 
cp summary.out IPSL_CM5BLR_fwc_summary.out 
cp year_summary.out IPSL_CM5BLR_fwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwc_soiln.out
cp vswc.out IPSL_CM5BLR_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC5_fwc.lis 
cp summary.out MIROC5_fwc_summary.out 
cp year_summary.out MIROC5_fwc_year_summary.out
cp harvest.csv MIROC5_fwc_harvest.csv	
cp dc_sip.csv MIROC5_fwc_dc_sip.csv	
cp soiln.out MIROC5_fwc_soiln.out
cp vswc.out MIROC5_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MIROC_CHEM_fwc.lis 
cp summary.out MIROC_CHEM_fwc_summary.out 
cp year_summary.out MIROC_CHEM_fwc_year_summary.out
cp harvest.csv MIROC_CHEM_fwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwc_soiln.out
cp vswc.out MIROC_CHEM_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwc -n fwc -e base2 
./DDClist100 fwc fwc outvars.txt

cp fwc.lis MRI_CGCM3_fwc.lis 
cp summary.out MRI_CGCM3_fwc_summary.out 
cp year_summary.out MRI_CGCM3_fwc_year_summary.out
cp harvest.csv MRI_CGCM3_fwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwc_soiln.out
cp vswc.out MRI_CGCM3_fwc_vswc.out

rm fwc.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_toe_$f"; done
for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWC/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### WHEAT-CORN-MILLET-FALLOW ROTATION FOR TOESLOPES

cp spin.1 spin.bin
cp base.1 base.bin

cp rot6_toe.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11m_wcmf.lis 
cp summary.out bcc_csm11m_wcmf_summary.out 
cp year_summary.out bcc_csm11m_wcmf_year_summary.out
cp harvest.csv bcc_csm11m_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11m_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11m_wcmf_soiln.out
cp vswc.out bcc_csm11m_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis bcc_csm11_wcmf.lis 
cp summary.out bcc_csm11_wcmf_summary.out 
cp year_summary.out bcc_csm11_wcmf_year_summary.out
cp harvest.csv bcc_csm11_wcmf_harvest.csv	
cp dc_sip.csv bcc_csm11_wcmf_dc_sip.csv	
cp soiln.out bcc_csm11_wcmf_soiln.out
cp vswc.out bcc_csm11_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis BNU_wcmf.lis 
cp summary.out BNU_wcmf_summary.out 
cp year_summary.out BNU_wcmf_year_summary.out
cp harvest.csv BNU_wcmf_harvest.csv	
cp dc_sip.csv BNU_wcmf_dc_sip.csv	
cp soiln.out BNU_wcmf_soiln.out
cp vswc.out BNU_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CanESM2_wcmf.lis 
cp summary.out CanESM2_wcmf_summary.out 
cp year_summary.out CanESM2_wcmf_year_summary.out
cp harvest.csv CanESM2_wcmf_harvest.csv	
cp dc_sip.csv CanESM2_wcmf_dc_sip.csv	
cp soiln.out CanESM2_wcmf_soiln.out
cp vswc.out CanESM2_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CNRM_wcmf.lis 
cp summary.out CNRM_wcmf_summary.out 
cp year_summary.out CNRM_wcmf_year_summary.out
cp harvest.csv CNRM_wcmf_harvest.csv	
cp dc_sip.csv CNRM_wcmf_dc_sip.csv	
cp soiln.out CNRM_wcmf_soiln.out
cp vswc.out CNRM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis CSIRO_wcmf.lis 
cp summary.out CSIRO_wcmf_summary.out 
cp year_summary.out CSIRO_wcmf_year_summary.out
cp harvest.csv CSIRO_wcmf_harvest.csv	
cp dc_sip.csv CSIRO_wcmf_dc_sip.csv	
cp soiln.out CSIRO_wcmf_soiln.out
cp vswc.out CSIRO_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2G_wcmf.lis 
cp summary.out GFDL_ESM2G_wcmf_summary.out 
cp year_summary.out GFDL_ESM2G_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2G_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2G_wcmf_soiln.out
cp vswc.out GFDL_ESM2G_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis GFDL_ESM2M_wcmf.lis 
cp summary.out GFDL_ESM2M_wcmf_summary.out 
cp year_summary.out GFDL_ESM2M_wcmf_year_summary.out
cp harvest.csv GFDL_ESM2M_wcmf_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_wcmf_dc_sip.csv	
cp soiln.out GFDL_ESM2M_wcmf_soiln.out
cp vswc.out GFDL_ESM2M_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_CC_wcmf.lis 
cp summary.out HadGEM2_CC_wcmf_summary.out 
cp year_summary.out HadGEM2_CC_wcmf_year_summary.out
cp harvest.csv HadGEM2_CC_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_CC_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_CC_wcmf_soiln.out
cp vswc.out HadGEM2_CC_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis HadGEM2_ES_wcmf.lis 
cp summary.out HadGEM2_ES_wcmf_summary.out 
cp year_summary.out HadGEM2_ES_wcmf_year_summary.out
cp harvest.csv HadGEM2_ES_wcmf_harvest.csv	
cp dc_sip.csv HadGEM2_ES_wcmf_dc_sip.csv	
cp soiln.out HadGEM2_ES_wcmf_soiln.out
cp vswc.out HadGEM2_ES_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis inmcm4_wcmf.lis 
cp summary.out inmcm4_wcmf_summary.out 
cp year_summary.out inmcm4_wcmf_year_summary.out
cp harvest.csv inmcm4_wcmf_harvest.csv	
cp dc_sip.csv inmcm4_wcmf_dc_sip.csv	
cp soiln.out inmcm4_wcmf_soiln.out
cp vswc.out inmcm4_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5ALR_wcmf.lis 
cp summary.out IPSL_CM5ALR_wcmf_summary.out 
cp year_summary.out IPSL_CM5ALR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5ALR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_wcmf_soiln.out
cp vswc.out IPSL_CM5ALR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis IPSL_CM5BLR_wcmf.lis 
cp summary.out IPSL_CM5BLR_wcmf_summary.out 
cp year_summary.out IPSL_CM5BLR_wcmf_year_summary.out
cp harvest.csv IPSL_CM5BLR_wcmf_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_wcmf_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_wcmf_soiln.out
cp vswc.out IPSL_CM5BLR_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC5_wcmf.lis 
cp summary.out MIROC5_wcmf_summary.out 
cp year_summary.out MIROC5_wcmf_year_summary.out
cp harvest.csv MIROC5_wcmf_harvest.csv	
cp dc_sip.csv MIROC5_wcmf_dc_sip.csv	
cp soiln.out MIROC5_wcmf_soiln.out
cp vswc.out MIROC5_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MIROC_CHEM_wcmf.lis 
cp summary.out MIROC_CHEM_wcmf_summary.out 
cp year_summary.out MIROC_CHEM_wcmf_year_summary.out
cp harvest.csv MIROC_CHEM_wcmf_harvest.csv	
cp dc_sip.csv MIROC_CHEM_wcmf_dc_sip.csv	
cp soiln.out MIROC_CHEM_wcmf_soiln.out
cp vswc.out MIROC_CHEM_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s wcmf -n wcmf -e base2 
./DDClist100 wcmf wcmf outvars.txt

cp wcmf.lis MRI_CGCM3_wcmf.lis 
cp summary.out MRI_CGCM3_wcmf_summary.out 
cp year_summary.out MRI_CGCM3_wcmf_year_summary.out
cp harvest.csv MRI_CGCM3_wcmf_harvest.csv	
cp dc_sip.csv MRI_CGCM3_wcmf_dc_sip.csv	
cp soiln.out MRI_CGCM3_wcmf_soiln.out
cp vswc.out MRI_CGCM3_wcmf_vswc.out

rm wcmf.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/WCMF/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11m_cmfw.lis 
cp summary.out bcc_csm11m_cmfw_summary.out 
cp year_summary.out bcc_csm11m_cmfw_year_summary.out
cp harvest.csv bcc_csm11m_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11m_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11m_cmfw_soiln.out
cp vswc.out bcc_csm11m_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis bcc_csm11_cmfw.lis 
cp summary.out bcc_csm11_cmfw_summary.out 
cp year_summary.out bcc_csm11_cmfw_year_summary.out
cp harvest.csv bcc_csm11_cmfw_harvest.csv	
cp dc_sip.csv bcc_csm11_cmfw_dc_sip.csv	
cp soiln.out bcc_csm11_cmfw_soiln.out
cp vswc.out bcc_csm11_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis BNU_cmfw.lis 
cp summary.out BNU_cmfw_summary.out 
cp year_summary.out BNU_cmfw_year_summary.out
cp harvest.csv BNU_cmfw_harvest.csv	
cp dc_sip.csv BNU_cmfw_dc_sip.csv	
cp soiln.out BNU_cmfw_soiln.out
cp vswc.out BNU_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CanESM2_cmfw.lis 
cp summary.out CanESM2_cmfw_summary.out 
cp year_summary.out CanESM2_cmfw_year_summary.out
cp harvest.csv CanESM2_cmfw_harvest.csv	
cp dc_sip.csv CanESM2_cmfw_dc_sip.csv	
cp soiln.out CanESM2_cmfw_soiln.out
cp vswc.out CanESM2_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CNRM_cmfw.lis 
cp summary.out CNRM_cmfw_summary.out 
cp year_summary.out CNRM_cmfw_year_summary.out
cp harvest.csv CNRM_cmfw_harvest.csv	
cp dc_sip.csv CNRM_cmfw_dc_sip.csv	
cp soiln.out CNRM_cmfw_soiln.out
cp vswc.out CNRM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis CSIRO_cmfw.lis 
cp summary.out CSIRO_cmfw_summary.out 
cp year_summary.out CSIRO_cmfw_year_summary.out
cp harvest.csv CSIRO_cmfw_harvest.csv	
cp dc_sip.csv CSIRO_cmfw_dc_sip.csv	
cp soiln.out CSIRO_cmfw_soiln.out
cp vswc.out CSIRO_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2G_cmfw.lis 
cp summary.out GFDL_ESM2G_cmfw_summary.out 
cp year_summary.out GFDL_ESM2G_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2G_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2G_cmfw_soiln.out
cp vswc.out GFDL_ESM2G_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis GFDL_ESM2M_cmfw.lis 
cp summary.out GFDL_ESM2M_cmfw_summary.out 
cp year_summary.out GFDL_ESM2M_cmfw_year_summary.out
cp harvest.csv GFDL_ESM2M_cmfw_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_cmfw_dc_sip.csv	
cp soiln.out GFDL_ESM2M_cmfw_soiln.out
cp vswc.out GFDL_ESM2M_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_CC_cmfw.lis 
cp summary.out HadGEM2_CC_cmfw_summary.out 
cp year_summary.out HadGEM2_CC_cmfw_year_summary.out
cp harvest.csv HadGEM2_CC_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_CC_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_CC_cmfw_soiln.out
cp vswc.out HadGEM2_CC_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis HadGEM2_ES_cmfw.lis 
cp summary.out HadGEM2_ES_cmfw_summary.out 
cp year_summary.out HadGEM2_ES_cmfw_year_summary.out
cp harvest.csv HadGEM2_ES_cmfw_harvest.csv	
cp dc_sip.csv HadGEM2_ES_cmfw_dc_sip.csv	
cp soiln.out HadGEM2_ES_cmfw_soiln.out
cp vswc.out HadGEM2_ES_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis inmcm4_cmfw.lis 
cp summary.out inmcm4_cmfw_summary.out 
cp year_summary.out inmcm4_cmfw_year_summary.out
cp harvest.csv inmcm4_cmfw_harvest.csv	
cp dc_sip.csv inmcm4_cmfw_dc_sip.csv	
cp soiln.out inmcm4_cmfw_soiln.out
cp vswc.out inmcm4_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5ALR_cmfw.lis 
cp summary.out IPSL_CM5ALR_cmfw_summary.out 
cp year_summary.out IPSL_CM5ALR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5ALR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_cmfw_soiln.out
cp vswc.out IPSL_CM5ALR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis IPSL_CM5BLR_cmfw.lis 
cp summary.out IPSL_CM5BLR_cmfw_summary.out 
cp year_summary.out IPSL_CM5BLR_cmfw_year_summary.out
cp harvest.csv IPSL_CM5BLR_cmfw_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_cmfw_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_cmfw_soiln.out
cp vswc.out IPSL_CM5BLR_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC5_cmfw.lis 
cp summary.out MIROC5_cmfw_summary.out 
cp year_summary.out MIROC5_cmfw_year_summary.out
cp harvest.csv MIROC5_cmfw_harvest.csv	
cp dc_sip.csv MIROC5_cmfw_dc_sip.csv	
cp soiln.out MIROC5_cmfw_soiln.out
cp vswc.out MIROC5_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MIROC_CHEM_cmfw.lis 
cp summary.out MIROC_CHEM_cmfw_summary.out 
cp year_summary.out MIROC_CHEM_cmfw_year_summary.out
cp harvest.csv MIROC_CHEM_cmfw_harvest.csv	
cp dc_sip.csv MIROC_CHEM_cmfw_dc_sip.csv	
cp soiln.out MIROC_CHEM_cmfw_soiln.out
cp vswc.out MIROC_CHEM_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s cmfw -n cmfw -e base2 
./DDClist100 cmfw cmfw outvars.txt

cp cmfw.lis MRI_CGCM3_cmfw.lis 
cp summary.out MRI_CGCM3_cmfw_summary.out 
cp year_summary.out MRI_CGCM3_cmfw_year_summary.out
cp harvest.csv MRI_CGCM3_cmfw_harvest.csv	
cp dc_sip.csv MRI_CGCM3_cmfw_dc_sip.csv	
cp soiln.out MRI_CGCM3_cmfw_soiln.out
cp vswc.out MRI_CGCM3_cmfw_vswc.out

rm cmfw.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/CMFW/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11m_mfwc.lis 
cp summary.out bcc_csm11m_mfwc_summary.out 
cp year_summary.out bcc_csm11m_mfwc_year_summary.out
cp harvest.csv bcc_csm11m_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11m_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11m_mfwc_soiln.out
cp vswc.out bcc_csm11m_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis bcc_csm11_mfwc.lis 
cp summary.out bcc_csm11_mfwc_summary.out 
cp year_summary.out bcc_csm11_mfwc_year_summary.out
cp harvest.csv bcc_csm11_mfwc_harvest.csv	
cp dc_sip.csv bcc_csm11_mfwc_dc_sip.csv	
cp soiln.out bcc_csm11_mfwc_soiln.out
cp vswc.out bcc_csm11_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis BNU_mfwc.lis 
cp summary.out BNU_mfwc_summary.out 
cp year_summary.out BNU_mfwc_year_summary.out
cp harvest.csv BNU_mfwc_harvest.csv	
cp dc_sip.csv BNU_mfwc_dc_sip.csv	
cp soiln.out BNU_mfwc_soiln.out
cp vswc.out BNU_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CanESM2_mfwc.lis 
cp summary.out CanESM2_mfwc_summary.out 
cp year_summary.out CanESM2_mfwc_year_summary.out
cp harvest.csv CanESM2_mfwc_harvest.csv	
cp dc_sip.csv CanESM2_mfwc_dc_sip.csv	
cp soiln.out CanESM2_mfwc_soiln.out
cp vswc.out CanESM2_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CNRM_mfwc.lis 
cp summary.out CNRM_mfwc_summary.out 
cp year_summary.out CNRM_mfwc_year_summary.out
cp harvest.csv CNRM_mfwc_harvest.csv	
cp dc_sip.csv CNRM_mfwc_dc_sip.csv	
cp soiln.out CNRM_mfwc_soiln.out
cp vswc.out CNRM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis CSIRO_mfwc.lis 
cp summary.out CSIRO_mfwc_summary.out 
cp year_summary.out CSIRO_mfwc_year_summary.out
cp harvest.csv CSIRO_mfwc_harvest.csv	
cp dc_sip.csv CSIRO_mfwc_dc_sip.csv	
cp soiln.out CSIRO_mfwc_soiln.out
cp vswc.out CSIRO_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2G_mfwc.lis 
cp summary.out GFDL_ESM2G_mfwc_summary.out 
cp year_summary.out GFDL_ESM2G_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2G_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2G_mfwc_soiln.out
cp vswc.out GFDL_ESM2G_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis GFDL_ESM2M_mfwc.lis 
cp summary.out GFDL_ESM2M_mfwc_summary.out 
cp year_summary.out GFDL_ESM2M_mfwc_year_summary.out
cp harvest.csv GFDL_ESM2M_mfwc_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_mfwc_dc_sip.csv	
cp soiln.out GFDL_ESM2M_mfwc_soiln.out
cp vswc.out GFDL_ESM2M_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_CC_mfwc.lis 
cp summary.out HadGEM2_CC_mfwc_summary.out 
cp year_summary.out HadGEM2_CC_mfwc_year_summary.out
cp harvest.csv HadGEM2_CC_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_CC_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_CC_mfwc_soiln.out
cp vswc.out HadGEM2_CC_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis HadGEM2_ES_mfwc.lis 
cp summary.out HadGEM2_ES_mfwc_summary.out 
cp year_summary.out HadGEM2_ES_mfwc_year_summary.out
cp harvest.csv HadGEM2_ES_mfwc_harvest.csv	
cp dc_sip.csv HadGEM2_ES_mfwc_dc_sip.csv	
cp soiln.out HadGEM2_ES_mfwc_soiln.out
cp vswc.out HadGEM2_ES_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis inmcm4_mfwc.lis 
cp summary.out inmcm4_mfwc_summary.out 
cp year_summary.out inmcm4_mfwc_year_summary.out
cp harvest.csv inmcm4_mfwc_harvest.csv	
cp dc_sip.csv inmcm4_mfwc_dc_sip.csv	
cp soiln.out inmcm4_mfwc_soiln.out
cp vswc.out inmcm4_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5ALR_mfwc.lis 
cp summary.out IPSL_CM5ALR_mfwc_summary.out 
cp year_summary.out IPSL_CM5ALR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5ALR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_mfwc_soiln.out
cp vswc.out IPSL_CM5ALR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis IPSL_CM5BLR_mfwc.lis 
cp summary.out IPSL_CM5BLR_mfwc_summary.out 
cp year_summary.out IPSL_CM5BLR_mfwc_year_summary.out
cp harvest.csv IPSL_CM5BLR_mfwc_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_mfwc_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_mfwc_soiln.out
cp vswc.out IPSL_CM5BLR_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC5_mfwc.lis 
cp summary.out MIROC5_mfwc_summary.out 
cp year_summary.out MIROC5_mfwc_year_summary.out
cp harvest.csv MIROC5_mfwc_harvest.csv	
cp dc_sip.csv MIROC5_mfwc_dc_sip.csv	
cp soiln.out MIROC5_mfwc_soiln.out
cp vswc.out MIROC5_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MIROC_CHEM_mfwc.lis 
cp summary.out MIROC_CHEM_mfwc_summary.out 
cp year_summary.out MIROC_CHEM_mfwc_year_summary.out
cp harvest.csv MIROC_CHEM_mfwc_harvest.csv	
cp dc_sip.csv MIROC_CHEM_mfwc_dc_sip.csv	
cp soiln.out MIROC_CHEM_mfwc_soiln.out
cp vswc.out MIROC_CHEM_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s mfwc -n mfwc -e base2 
./DDClist100 mfwc mfwc outvars.txt

cp mfwc.lis MRI_CGCM3_mfwc.lis 
cp summary.out MRI_CGCM3_mfwc_summary.out 
cp year_summary.out MRI_CGCM3_mfwc_year_summary.out
cp harvest.csv MRI_CGCM3_mfwc_harvest.csv	
cp dc_sip.csv MRI_CGCM3_mfwc_dc_sip.csv	
cp soiln.out MRI_CGCM3_mfwc_soiln.out
cp vswc.out MRI_CGCM3_mfwc_vswc.out

rm mfwc.bin
rm 09_100.wth

for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/MFWC/RCP85/

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11m_fwcm.lis 
cp summary.out bcc_csm11m_fwcm_summary.out 
cp year_summary.out bcc_csm11m_fwcm_year_summary.out
cp harvest.csv bcc_csm11m_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11m_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11m_fwcm_soiln.out
cp vswc.out bcc_csm11m_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis bcc_csm11_fwcm.lis 
cp summary.out bcc_csm11_fwcm_summary.out 
cp year_summary.out bcc_csm11_fwcm_year_summary.out
cp harvest.csv bcc_csm11_fwcm_harvest.csv	
cp dc_sip.csv bcc_csm11_fwcm_dc_sip.csv	
cp soiln.out bcc_csm11_fwcm_soiln.out
cp vswc.out bcc_csm11_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis BNU_fwcm.lis 
cp summary.out BNU_fwcm_summary.out 
cp year_summary.out BNU_fwcm_year_summary.out
cp harvest.csv BNU_fwcm_harvest.csv	
cp dc_sip.csv BNU_fwcm_dc_sip.csv	
cp soiln.out BNU_fwcm_soiln.out
cp vswc.out BNU_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CanESM2_fwcm.lis 
cp summary.out CanESM2_fwcm_summary.out 
cp year_summary.out CanESM2_fwcm_year_summary.out
cp harvest.csv CanESM2_fwcm_harvest.csv	
cp dc_sip.csv CanESM2_fwcm_dc_sip.csv	
cp soiln.out CanESM2_fwcm_soiln.out
cp vswc.out CanESM2_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CNRM_fwcm.lis 
cp summary.out CNRM_fwcm_summary.out 
cp year_summary.out CNRM_fwcm_year_summary.out
cp harvest.csv CNRM_fwcm_harvest.csv	
cp dc_sip.csv CNRM_fwcm_dc_sip.csv	
cp soiln.out CNRM_fwcm_soiln.out
cp vswc.out CNRM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis CSIRO_fwcm.lis 
cp summary.out CSIRO_fwcm_summary.out 
cp year_summary.out CSIRO_fwcm_year_summary.out
cp harvest.csv CSIRO_fwcm_harvest.csv	
cp dc_sip.csv CSIRO_fwcm_dc_sip.csv	
cp soiln.out CSIRO_fwcm_soiln.out
cp vswc.out CSIRO_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2G_fwcm.lis 
cp summary.out GFDL_ESM2G_fwcm_summary.out 
cp year_summary.out GFDL_ESM2G_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2G_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2G_fwcm_soiln.out
cp vswc.out GFDL_ESM2G_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis GFDL_ESM2M_fwcm.lis 
cp summary.out GFDL_ESM2M_fwcm_summary.out 
cp year_summary.out GFDL_ESM2M_fwcm_year_summary.out
cp harvest.csv GFDL_ESM2M_fwcm_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_fwcm_dc_sip.csv	
cp soiln.out GFDL_ESM2M_fwcm_soiln.out
cp vswc.out GFDL_ESM2M_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_CC_fwcm.lis 
cp summary.out HadGEM2_CC_fwcm_summary.out 
cp year_summary.out HadGEM2_CC_fwcm_year_summary.out
cp harvest.csv HadGEM2_CC_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_CC_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_CC_fwcm_soiln.out
cp vswc.out HadGEM2_CC_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis HadGEM2_ES_fwcm.lis 
cp summary.out HadGEM2_ES_fwcm_summary.out 
cp year_summary.out HadGEM2_ES_fwcm_year_summary.out
cp harvest.csv HadGEM2_ES_fwcm_harvest.csv	
cp dc_sip.csv HadGEM2_ES_fwcm_dc_sip.csv	
cp soiln.out HadGEM2_ES_fwcm_soiln.out
cp vswc.out HadGEM2_ES_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis inmcm4_fwcm.lis 
cp summary.out inmcm4_fwcm_summary.out 
cp year_summary.out inmcm4_fwcm_year_summary.out
cp harvest.csv inmcm4_fwcm_harvest.csv	
cp dc_sip.csv inmcm4_fwcm_dc_sip.csv	
cp soiln.out inmcm4_fwcm_soiln.out
cp vswc.out inmcm4_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5ALR_fwcm.lis 
cp summary.out IPSL_CM5ALR_fwcm_summary.out 
cp year_summary.out IPSL_CM5ALR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5ALR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_fwcm_soiln.out
cp vswc.out IPSL_CM5ALR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis IPSL_CM5BLR_fwcm.lis 
cp summary.out IPSL_CM5BLR_fwcm_summary.out 
cp year_summary.out IPSL_CM5BLR_fwcm_year_summary.out
cp harvest.csv IPSL_CM5BLR_fwcm_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_fwcm_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_fwcm_soiln.out
cp vswc.out IPSL_CM5BLR_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC5_fwcm.lis 
cp summary.out MIROC5_fwcm_summary.out 
cp year_summary.out MIROC5_fwcm_year_summary.out
cp harvest.csv MIROC5_fwcm_harvest.csv	
cp dc_sip.csv MIROC5_fwcm_dc_sip.csv	
cp soiln.out MIROC5_fwcm_soiln.out
cp vswc.out MIROC5_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MIROC_CHEM_fwcm.lis 
cp summary.out MIROC_CHEM_fwcm_summary.out 
cp year_summary.out MIROC_CHEM_fwcm_year_summary.out
cp harvest.csv MIROC_CHEM_fwcm_harvest.csv	
cp dc_sip.csv MIROC_CHEM_fwcm_dc_sip.csv	
cp soiln.out MIROC_CHEM_fwcm_soiln.out
cp vswc.out MIROC_CHEM_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s fwcm -n fwcm -e base2 
./DDClist100 fwcm fwcm outvars.txt

cp fwcm.lis MRI_CGCM3_fwcm.lis 
cp summary.out MRI_CGCM3_fwcm_summary.out 
cp year_summary.out MRI_CGCM3_fwcm_year_summary.out
cp harvest.csv MRI_CGCM3_fwcm_harvest.csv	
cp dc_sip.csv MRI_CGCM3_fwcm_dc_sip.csv	
cp soiln.out MRI_CGCM3_fwcm_soiln.out
cp vswc.out MRI_CGCM3_fwcm_vswc.out

rm fwcm.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_toe_$f"; done
for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/FWCM/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### OPPORTUNITY CROP ROTATION (CONTINUOUS CROPPING) FOR TOESLOPES

cp spin.1 spin.bin
cp base.1 base.bin

cp rot10_toe.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11m_opp.lis 
cp summary.out bcc_csm11m_opp_summary.out 
cp year_summary.out bcc_csm11m_opp_year_summary.out
cp harvest.csv bcc_csm11m_opp_harvest.csv	
cp dc_sip.csv bcc_csm11m_opp_dc_sip.csv	
cp soiln.out bcc_csm11m_opp_soiln.out
cp vswc.out bcc_csm11m_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis bcc_csm11_opp.lis 
cp summary.out bcc_csm11_opp_summary.out 
cp year_summary.out bcc_csm11_opp_year_summary.out
cp harvest.csv bcc_csm11_opp_harvest.csv	
cp dc_sip.csv bcc_csm11_opp_dc_sip.csv	
cp soiln.out bcc_csm11_opp_soiln.out
cp vswc.out bcc_csm11_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis BNU_opp.lis 
cp summary.out BNU_opp_summary.out 
cp year_summary.out BNU_opp_year_summary.out
cp harvest.csv BNU_opp_harvest.csv	
cp dc_sip.csv BNU_opp_dc_sip.csv	
cp soiln.out BNU_opp_soiln.out
cp vswc.out BNU_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CanESM2_opp.lis 
cp summary.out CanESM2_opp_summary.out 
cp year_summary.out CanESM2_opp_year_summary.out
cp harvest.csv CanESM2_opp_harvest.csv	
cp dc_sip.csv CanESM2_opp_dc_sip.csv	
cp soiln.out CanESM2_opp_soiln.out
cp vswc.out CanESM2_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CNRM_opp.lis 
cp summary.out CNRM_opp_summary.out 
cp year_summary.out CNRM_opp_year_summary.out
cp harvest.csv CNRM_opp_harvest.csv	
cp dc_sip.csv CNRM_opp_dc_sip.csv	
cp soiln.out CNRM_opp_soiln.out
cp vswc.out CNRM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis CSIRO_opp.lis 
cp summary.out CSIRO_opp_summary.out 
cp year_summary.out CSIRO_opp_year_summary.out
cp harvest.csv CSIRO_opp_harvest.csv	
cp dc_sip.csv CSIRO_opp_dc_sip.csv	
cp soiln.out CSIRO_opp_soiln.out
cp vswc.out CSIRO_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2G_opp.lis 
cp summary.out GFDL_ESM2G_opp_summary.out 
cp year_summary.out GFDL_ESM2G_opp_year_summary.out
cp harvest.csv GFDL_ESM2G_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2G_opp_soiln.out
cp vswc.out GFDL_ESM2G_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis GFDL_ESM2M_opp.lis 
cp summary.out GFDL_ESM2M_opp_summary.out 
cp year_summary.out GFDL_ESM2M_opp_year_summary.out
cp harvest.csv GFDL_ESM2M_opp_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_opp_dc_sip.csv	
cp soiln.out GFDL_ESM2M_opp_soiln.out
cp vswc.out GFDL_ESM2M_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_CC_opp.lis 
cp summary.out HadGEM2_CC_opp_summary.out 
cp year_summary.out HadGEM2_CC_opp_year_summary.out
cp harvest.csv HadGEM2_CC_opp_harvest.csv	
cp dc_sip.csv HadGEM2_CC_opp_dc_sip.csv	
cp soiln.out HadGEM2_CC_opp_soiln.out
cp vswc.out HadGEM2_CC_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis HadGEM2_ES_opp.lis 
cp summary.out HadGEM2_ES_opp_summary.out 
cp year_summary.out HadGEM2_ES_opp_year_summary.out
cp harvest.csv HadGEM2_ES_opp_harvest.csv	
cp dc_sip.csv HadGEM2_ES_opp_dc_sip.csv	
cp soiln.out HadGEM2_ES_opp_soiln.out
cp vswc.out HadGEM2_ES_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis inmcm4_opp.lis 
cp summary.out inmcm4_opp_summary.out 
cp year_summary.out inmcm4_opp_year_summary.out
cp harvest.csv inmcm4_opp_harvest.csv	
cp dc_sip.csv inmcm4_opp_dc_sip.csv	
cp soiln.out inmcm4_opp_soiln.out
cp vswc.out inmcm4_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5ALR_opp.lis 
cp summary.out IPSL_CM5ALR_opp_summary.out 
cp year_summary.out IPSL_CM5ALR_opp_year_summary.out
cp harvest.csv IPSL_CM5ALR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_opp_soiln.out
cp vswc.out IPSL_CM5ALR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis IPSL_CM5BLR_opp.lis 
cp summary.out IPSL_CM5BLR_opp_summary.out 
cp year_summary.out IPSL_CM5BLR_opp_year_summary.out
cp harvest.csv IPSL_CM5BLR_opp_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_opp_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_opp_soiln.out
cp vswc.out IPSL_CM5BLR_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC5_opp.lis 
cp summary.out MIROC5_opp_summary.out 
cp year_summary.out MIROC5_opp_year_summary.out
cp harvest.csv MIROC5_opp_harvest.csv	
cp dc_sip.csv MIROC5_opp_dc_sip.csv	
cp soiln.out MIROC5_opp_soiln.out
cp vswc.out MIROC5_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MIROC_CHEM_opp.lis 
cp summary.out MIROC_CHEM_opp_summary.out 
cp year_summary.out MIROC_CHEM_opp_year_summary.out
cp harvest.csv MIROC_CHEM_opp_harvest.csv	
cp dc_sip.csv MIROC_CHEM_opp_dc_sip.csv	
cp soiln.out MIROC_CHEM_opp_soiln.out
cp vswc.out MIROC_CHEM_opp_vswc.out

rm opp.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s opp -n opp -e base2 
./DDClist100 opp opp outvars.txt

cp opp.lis MRI_CGCM3_opp.lis 
cp summary.out MRI_CGCM3_opp_summary.out 
cp year_summary.out MRI_CGCM3_opp_year_summary.out
cp harvest.csv MRI_CGCM3_opp_harvest.csv	
cp dc_sip.csv MRI_CGCM3_opp_dc_sip.csv	
cp soiln.out MRI_CGCM3_opp_soiln.out
cp vswc.out MRI_CGCM3_opp_vswc.out

rm opp.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_toe_$f"; done
for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/OPP/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv
rm base2.sch

##### GRASSLAND FOR TOESLOPES

cp base.1 base.bin
cp spin.1 spin.bin

cp grass_09.sch base2.sch

./DDcentEVI -s base2 -n base2 -e base 
./DDClist100 base2 base2 outvars.txt

cp bcc_csm11m_rcp85.wth 09_100.wth
cp f_grass.sch grass.sch

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11m_grass.lis 
cp summary.out bcc_csm11m_grass_summary.out 
cp year_summary.out bcc_csm11m_grass_year_summary.out
cp harvest.csv bcc_csm11m_grass_harvest.csv	
cp dc_sip.csv bcc_csm11m_grass_dc_sip.csv	
cp soiln.out bcc_csm11m_grass_soiln.out
cp vswc.out bcc_csm11m_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp bcc_csm11_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis bcc_csm11_grass.lis 
cp summary.out bcc_csm11_grass_summary.out 
cp year_summary.out bcc_csm11_grass_year_summary.out
cp harvest.csv bcc_csm11_grass_harvest.csv	
cp dc_sip.csv bcc_csm11_grass_dc_sip.csv	
cp soiln.out bcc_csm11_grass_soiln.out
cp vswc.out bcc_csm11_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp BNU_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis BNU_grass.lis 
cp summary.out BNU_grass_summary.out 
cp year_summary.out BNU_grass_year_summary.out
cp harvest.csv BNU_grass_harvest.csv	
cp dc_sip.csv BNU_grass_dc_sip.csv	
cp soiln.out BNU_grass_soiln.out
cp vswc.out BNU_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CanESM2_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CanESM2_grass.lis 
cp summary.out CanESM2_grass_summary.out 
cp year_summary.out CanESM2_grass_year_summary.out
cp harvest.csv CanESM2_grass_harvest.csv	
cp dc_sip.csv CanESM2_grass_dc_sip.csv	
cp soiln.out CanESM2_grass_soiln.out
cp vswc.out CanESM2_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CNRM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CNRM_grass.lis 
cp summary.out CNRM_grass_summary.out 
cp year_summary.out CNRM_grass_year_summary.out
cp harvest.csv CNRM_grass_harvest.csv	
cp dc_sip.csv CNRM_grass_dc_sip.csv	
cp soiln.out CNRM_grass_soiln.out
cp vswc.out CNRM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp CSIRO_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis CSIRO_grass.lis 
cp summary.out CSIRO_grass_summary.out 
cp year_summary.out CSIRO_grass_year_summary.out
cp harvest.csv CSIRO_grass_harvest.csv	
cp dc_sip.csv CSIRO_grass_dc_sip.csv	
cp soiln.out CSIRO_grass_soiln.out
cp vswc.out CSIRO_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2G_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2G_grass.lis 
cp summary.out GFDL_ESM2G_grass_summary.out 
cp year_summary.out GFDL_ESM2G_grass_year_summary.out
cp harvest.csv GFDL_ESM2G_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2G_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2G_grass_soiln.out
cp vswc.out GFDL_ESM2G_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp GFDL_ESM2M_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis GFDL_ESM2M_grass.lis 
cp summary.out GFDL_ESM2M_grass_summary.out 
cp year_summary.out GFDL_ESM2M_grass_year_summary.out
cp harvest.csv GFDL_ESM2M_grass_harvest.csv	
cp dc_sip.csv GFDL_ESM2M_grass_dc_sip.csv	
cp soiln.out GFDL_ESM2M_grass_soiln.out
cp vswc.out GFDL_ESM2M_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_CC_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_CC_grass.lis 
cp summary.out HadGEM2_CC_grass_summary.out 
cp year_summary.out HadGEM2_CC_grass_year_summary.out
cp harvest.csv HadGEM2_CC_grass_harvest.csv	
cp dc_sip.csv HadGEM2_CC_grass_dc_sip.csv	
cp soiln.out HadGEM2_CC_grass_soiln.out
cp vswc.out HadGEM2_CC_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp HadGEM2_ES_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis HadGEM2_ES_grass.lis 
cp summary.out HadGEM2_ES_grass_summary.out 
cp year_summary.out HadGEM2_ES_grass_year_summary.out
cp harvest.csv HadGEM2_ES_grass_harvest.csv	
cp dc_sip.csv HadGEM2_ES_grass_dc_sip.csv	
cp soiln.out HadGEM2_ES_grass_soiln.out
cp vswc.out HadGEM2_ES_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp inmcm4_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis inmcm4_grass.lis 
cp summary.out inmcm4_grass_summary.out 
cp year_summary.out inmcm4_grass_year_summary.out
cp harvest.csv inmcm4_grass_harvest.csv	
cp dc_sip.csv inmcm4_grass_dc_sip.csv	
cp soiln.out inmcm4_grass_soiln.out
cp vswc.out inmcm4_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5ALR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5ALR_grass.lis 
cp summary.out IPSL_CM5ALR_grass_summary.out 
cp year_summary.out IPSL_CM5ALR_grass_year_summary.out
cp harvest.csv IPSL_CM5ALR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5ALR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5ALR_grass_soiln.out
cp vswc.out IPSL_CM5ALR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp IPSL_CM5BLR_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis IPSL_CM5BLR_grass.lis 
cp summary.out IPSL_CM5BLR_grass_summary.out 
cp year_summary.out IPSL_CM5BLR_grass_year_summary.out
cp harvest.csv IPSL_CM5BLR_grass_harvest.csv	
cp dc_sip.csv IPSL_CM5BLR_grass_dc_sip.csv	
cp soiln.out IPSL_CM5BLR_grass_soiln.out
cp vswc.out IPSL_CM5BLR_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC5_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC5_grass.lis 
cp summary.out MIROC5_grass_summary.out 
cp year_summary.out MIROC5_grass_year_summary.out
cp harvest.csv MIROC5_grass_harvest.csv	
cp dc_sip.csv MIROC5_grass_dc_sip.csv	
cp soiln.out MIROC5_grass_soiln.out
cp vswc.out MIROC5_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MIROC_CHEM_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MIROC_CHEM_grass.lis 
cp summary.out MIROC_CHEM_grass_summary.out 
cp year_summary.out MIROC_CHEM_grass_year_summary.out
cp harvest.csv MIROC_CHEM_grass_harvest.csv	
cp dc_sip.csv MIROC_CHEM_grass_dc_sip.csv	
cp soiln.out MIROC_CHEM_grass_soiln.out
cp vswc.out MIROC_CHEM_grass_vswc.out

rm grass.bin
rm 09_100.wth

cp MRI_CGCM3_rcp85.wth 09_100.wth

./DDcentEVI -s grass -n grass -e base2 
./DDClist100 grass grass outvars.txt

cp grass.lis MRI_CGCM3_grass.lis 
cp summary.out MRI_CGCM3_grass_summary.out 
cp year_summary.out MRI_CGCM3_grass_year_summary.out
cp harvest.csv MRI_CGCM3_grass_harvest.csv	
cp dc_sip.csv MRI_CGCM3_grass_dc_sip.csv	
cp soiln.out MRI_CGCM3_grass_soiln.out
cp vswc.out MRI_CGCM3_grass_vswc.out

rm grass.bin
rm 09_100.wth

rm summary.out
rm year_summary.out
rm harvest.csv
rm dc_sip.csv
rm soiln.out
rm vswc.out			

cp spin.bin spin.1
cp base.bin base.1

for f in *.bin; do mv "$f" "ste_toe_$f"; done
for f in *.lis; do mv "$f" "ste_toe_$f"; done
for f in *.out; do mv "$f" "ste_toe_$f"; done
for f in *.csv; do mv "$f" "ste_toe_$f"; done

mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.bin /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.lis /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.out /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/
mv /media/andy/Modelling/DAP_files/future_sims/ste_sims85/*.csv /media/andy/Modelling/Outputs/LAI_LX_Future/Sterling/Grass/RCP85/

rm *.bin
rm *.out
rm *.lis
rm *.csv

find -maxdepth 1 -type f -delete
