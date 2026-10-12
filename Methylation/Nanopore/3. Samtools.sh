module load samtools

for bam in *.bam; do
    base="${bam%.bam}"

    samtools sort -o "${base}.sorted.bam" "$bam"
    samtools index "${base}.sorted.bam"
done

