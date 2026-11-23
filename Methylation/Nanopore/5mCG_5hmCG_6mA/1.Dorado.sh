module load gcc/12.3.0
module load cuda12.1/toolkit
module load cudnn8.9-cuda12.1

# Change directory to the directory from which the job was submitted:
cd $SLURM_SUBMIT_DIR

/dorado-0.9.1-linux-x64/bin/dorado basecaller sup,5mCG_5hmCG,6mA \
 /pod5_pass/ \
  --recursive \
  --reference genomic.fa \
  --kit-name SQK-NBD114-24 > 5mcg,hmcg,6ma.bam
