cd $SLURM_SUBMIT_DIR

module load samtools

mkdir -p TAPAS_coverage

for bam in SRR*.trimmed.Aligned.sortedByCoord.out.bam; do
    sample="${bam%.trimmed.Aligned.sortedByCoord.out.bam}"
    samtools quickcheck -v "$bam" &&
    samtools index -@ 4 "$bam" &&
    samtools depth "$bam" > "TAPAS_coverage/${sample}.read_coverage.txt"
done

OUTPUT="library_sizes.tsv"

printf "Sample\tMapped_primary_alignments\n" > "$OUTPUT"

for bam in SRR*.trimmed.Aligned.sortedByCoord.out.bam; do

    [ -f "$bam" ] || continue

    sample="${bam%.trimmed.Aligned.sortedByCoord.out.bam}"

    count=$(samtools view -@ 4 -c -F 3844 "$bam")

    printf "%s\t%s\n" "$sample" "$count" >> "$OUTPUT"

    echo "$sample: $count"

done

echo "Library-size extraction completed: $(date)"
