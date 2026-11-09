conda create -n polyApipe_env \
    --override-channels \
    -c conda-forge -c bioconda \
    python pysam samtools subread 'umi_tools=1.0.0'

set -euo pipefail

cd "$SLURM_SUBMIT_DIR"

eval "$(conda shell.bash hook)"
conda activate polyApipe_env

results_dir="cellranger_results"
polyapipe="polyApipe.py"
outdir="$SLURM_SUBMIT_DIR/polyapipe_shared"

mkdir -p "$outdir/input_bams"

for n in {22868588..22868604}; do
    run="SRR$n"

    ln -sfn \
	"$results_dir/$run/outs/possorted_genome_bam.bam" \
        "$outdir/input_bams/$run.bam"
done

echo "Starting shared peak calling: $(date)"

python "$polyapipe" \
    -i "$outdir/input_bams" \
    -o "$outdir/shared" \
    -t "$SLURM_CPUS_PER_TASK" \
    --no_count

echo "Finished shared peak calling: $(date)"

