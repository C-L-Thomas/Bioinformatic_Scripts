set -euo pipefail

eval "$(conda shell.bash hook)"
conda activate polyApipe_env

base="PolyAPipe"
bams="cellranger_results"
peaks="shared_polyA_peaks.gff"

for n in {22868588..22868604}; do
    run="SRR$n"
    sample_dir="$base/polyapipe_counts/$run"
    [[ -f "$sample_dir/complete" ]] && continue

    mkdir -p "$sample_dir"
    cd "$sample_dir"
    echo "Counting $run"

    python "$base/polyApipe/polyApipe.py" \
        -i "$bams/$run/outs/possorted_genome_bam.bam" \
        -o "$run" \
        --peaks_gff "$peaks" \
        -t "$SLURM_CPUS_PER_TASK"

    gzip -t "${run}_counts.tab.gz"
    touch complete
done
