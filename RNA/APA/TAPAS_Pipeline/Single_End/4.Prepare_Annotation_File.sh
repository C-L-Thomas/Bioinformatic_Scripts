cd $SLURM_SUBMIT_DIR

module load Miniconda3
conda activate tapas_tools

#Prepare pred file
conda run -n tapas_tools gtfToGenePred \
  -ignoreGroupsWithoutExons \
  -genePredExt \
  -geneNameAsName2 \
  genome.gtf \
  genome.genePred

#Organise into refFlat format:

awk 'BEGIN {OFS="\t"}
     NF >= 12 {
       print $12,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10
     }' genome.genePred |
  sort -k3,3 -k5,5n \
  > genome.refFlat.txt
