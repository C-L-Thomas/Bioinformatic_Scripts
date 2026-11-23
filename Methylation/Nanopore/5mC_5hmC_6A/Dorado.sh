# load gcc, cuda and cudnn modules
module load gcc/12.3.0
module load cuda12.1/toolkit
module load cudnn8.9-cuda12.1

# Change directory to the directory from which the job was submitted:
cd $SLURM_SUBMIT_DIR

dorado-0.9.1-linux-x64/bin/dorado basecaller sup,5mC_5hmC,6mA \
  /pod5_pass/ \
  --recursive \ #Means that folder above (pod5_pass) has subfolders with barcode name. Exlcude if not
  --reference GCF_009193385.2_Nvit_psr_1.1_genomic.fa \
  --kit-name SQK-NBD114-24 > 5mc,hmc,6ma.bam
