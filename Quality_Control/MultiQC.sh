cd "$SLURM_SUBMIT_DIR"

module load fastqc
module load multiqc

mkdir -p fastqc multiqc

fastqc \
  --threads 4 \
  --outdir fastqc \
  ./*_1.fq.gz ./*_2.fq.gz

multiqc \
  --outdir multiqc \
  fastqc/
