module load trimmomatic

#!/usr/bin/env bash
set -euo pipefail

module load trimmomatic

# Run one sample at a time; each Trimmomatic job uses 10 threads
for r1 in *_1.fastq.gz; do
    sample="${r1%_1.fastq.gz}"
    r2="${sample}_2.fastq.gz"

    if [[ ! -f "$r2" ]]; then
        echo "Missing read2 for sample: $sample" >&2
        continue
    fi

    echo "Trimming sample: $sample"

    trimmomatic PE -threads 10 \
        "$r1" "$r2" \
        "${sample}_trim_1.fq.gz" "${sample}_unpaired_1.fq.gz" \
        "${sample}_trim_2.fq.gz" "${sample}_unpaired_2.fq.gz" \
        ILLUMINACLIP:illumina_adapters.fa:2:30:10 \
        LEADING:30 TRAILING:30 MINLEN:50 HEADCROP:10
