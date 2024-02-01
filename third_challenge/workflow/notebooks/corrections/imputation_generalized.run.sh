#PBS -o results/main/cmi_pb_datasets/processed/all_versus_all/imputation/
#PBS -e results/main/cmi_pb_datasets/processed/all_versus_all/imputation/
#PBS -N imputation_generalized
#PBS -l walltime=200:00:00
#PBS -l mem=20gb
#PBS -l nodes=1:ppn=4
#PBS -t 0-2

# This script has to be run from the parent directory of imputation_generalized.Rmd

# list the years to run
# reminder: bash arrays are zero-indexed
years=("2020" "2021" "2022")

# determine the user's choice of year
if [[ -v PBS_ARRAYID ]]; then
  echo "Running with qsub"
  year=${years[$PBS_ARRAYID]}
else
  echo "Running with bash"
  year=${years[$1]}
fi

echo "Running imputation for year ${year}"

# building the command to run the Rmd
code="workflow/notebooks/corrections/imputation_generalized.Rmd"
report="../../../results/main/cmi_pb_datasets/processed/all_versus_all/imputation/imputation_report.${year}.html"
rmarkdown_call="rmarkdown::render('${code}', params=list(year='${year}'), output_file = '${report}')"

# run the Rmd
echo /mnt/BioApps/R/4.2.2/bin/Rscript -e "${rmarkdown_call}"
/mnt/BioApps/R/4.2.2/bin/Rscript -e "${rmarkdown_call}"
#Rscript -e "${rmarkdown_call
