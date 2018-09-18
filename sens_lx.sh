### THIS SHELL SCRIPT PREPS ALL THE FOLDERS NEEDED TO RUN SENSITIVITY ANALYSES FOR ALL TREATMENTS ACROSS ALL SLOPES AND SITES
#
# All simulations are run in the "sims" folder that corresponds to each site. After running
# the simulation outputs are moved into a separate folder in "Outputs/..." before all files
# in the "sims" folder are deleted. Outputs of interest were limited so only include some
# (summary.out / year_summary.out / harvest.csv / dc_sip.csv / soiln.out / vswc.out)

# This first part removes all old sensitivity results. Because these can take a long time to create I have included a prompt
#

echo "You are about to remove old sensitivity results. Do you wish to save the old ones to a new folder first?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) foldername=$"sensitivity_$(date +%Y-%m-%d)" ; mkdir -p  /media/andy/Modelling/Outputs/"$foldername"; mv /media/andy/Modelling/Outputs/LAI_Sensitivity/* /media/andy/Modelling/Outputs/"$foldername"/ ; break;;
        No ) echo "No" ; break ;;
    esac
done

rm -r /media/andy/Modelling/Outputs/LAI_Sensitivity/*

#  STERLING

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/"
fi

rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/*

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/ste_*.* /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe/

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Summit

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Side

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WF/Toe

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Summit

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Side

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCF/Toe

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Summit

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Side

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/WCMF/Toe

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Summit

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Side

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/OPP/Toe

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Summit

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Side

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Sterling/Grass/Toe

for f in ste_*.*; do mv "$f" "${f#ste_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in

# STRATTON

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/"
fi

rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/*

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/str_*.* /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe/

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Summit

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Side

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WF/Toe

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Summit

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Side

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCF/Toe

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Summit

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Side

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/WCMF/Toe

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Summit

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Side

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/OPP/Toe

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Summit

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Side

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Stratton/Grass/Toe

for f in str_*.*; do mv "$f" "${f#str_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in

# WALSH

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/"
fi

if [ -d "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/"
fi

rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/*
rm -r /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/*

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe/


cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit/

cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side/
 
cp -a /media/andy/Modelling/DAP_files/100_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/model_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/sens_files/. /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/wth_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/
cp -a /media/andy/Modelling/DAP_files/site_files/wal_*.* /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe/

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Summit

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit_site.100 site.100
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Side

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side_site.100 site.100
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WF/Toe

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe_site.100 site.100
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Summit

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit_site.100 site.100
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Side

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side_site.100 site.100
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCF/Toe

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe_site.100 site.100
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Summit

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit_site.100 site.100
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Side

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side_site.100 site.100
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/WCMF/Toe

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe_site.100 site.100
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Summit

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit_site.100 site.100
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Side

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side_site.100 site.100
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/OPP/Toe

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe_site.100 site.100
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in


cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Summit

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp summit_site.100 site.100
cp summit.in soils_base.txt
cp sens_outs.txt outfiles.in
 
cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Side

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm summit.in
rm toe.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp side_site.100 site.100
cp side.in soils_base.txt
cp sens_outs.txt outfiles.in

cd /media/andy/Modelling/DAP_files/sens_sims/Walsh/Grass/Toe

for f in wal_*.*; do mv "$f" "${f#wal_}"; done

rm side.in
rm summit.in
rm outfiles.in
cp 85_09.wth clim_base.txt
cp toe_site.100 site.100
cp toe.in soils_base.txt
cp sens_outs.txt outfiles.in

# Moving all above directories etc to an output directory before the next line in R loops over performing the sensitivity analysis in that folder

if [ -d "/media/andy/Modelling/Outputs/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/"
fi
    
if [ -d "/media/andy/Modelling/Outputs/LAI_Sensitivity/" ]; then
echo "Folder exists"
else
mkdir "/media/andy/Modelling/Outputs/LAI_Sensitivity/"
fi

mv /media/andy/Modelling/DAP_files/sens_sims/* /media/andy/Modelling/Outputs/LAI_Sensitivity/
