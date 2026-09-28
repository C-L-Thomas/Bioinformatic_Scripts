set -euo pipefail
cd "$SLURM_SUBMIT_DIR"
module load cellranger

fasta=GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fa
gtf=GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.gtf

filtered_gtf=GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.cellranger.gtf

awk -F '\t' 'BEGIN { OFS=FS }
  /^#/ { print; next }
  ($7 == "+" || $7 == "-") &&
  $9 !~ /(^|;[[:space:]]*)gene_id "Dmel_CG32491";/ { print }
' "$gtf" > "$filtered_gtf"

cellranger mkref \
  --genome=Drosophila_v2 \
  --fasta="$fasta" \
  --genes="$filtered_gtf" \
  --localcores=1 \
  --localmem=36
