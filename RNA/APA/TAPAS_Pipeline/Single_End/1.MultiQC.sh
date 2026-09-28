### Run script in the working directory it was submitted in
cd $SLURM_SUBMIT_DIR

module load fastqc
module load multiqc

mkdir -p fastqc

fastqc \
  --threads 4 \
  --outdir fastqc \
  ./*.fastq.gz

multiqc \
  --outdir multiqc \
  fastqc/
