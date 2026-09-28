cd $SLURM_SUBMIT_DIR

module load samtools

mkdir -p TAPAS_coverage

for bam in SRR*.trimmed.Aligned.sortedByCoord.out.bam; do
    sample="${bam%.trimmed.Aligned.sortedByCoord.out.bam}"
    samtools quickcheck -v "$bam" &&
    samtools index -@ 4 "$bam" &&
    samtools depth "$bam" > "TAPAS_coverage/${sample}.read_coverage.txt"
done
