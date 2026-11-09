set -euo pipefail

module load cellranger

work="$SLURM_SUBMIT_DIR"
ref="/scratch/drosleep/clt54/Genome/GCF_000001215.4_Release_6_plus_ISO1_MT/Drosophila_v2"
results="$work/cellranger_results"

mkdir -p "$results"
cd "$results"

for n in {22868588..22868604}; do
    run="SRR$n"
    [[ -f "$run/_complete" ]] && continue

    fastqs="$work/cellranger_fastqs/$run"
    mkdir -p "$fastqs"

    for read in 1 2; do
        fq="$work/${run}_${read}.fastq.gz"
        test -s "$fq"
        ln -sfn "$fq" "$fastqs/${run}_S1_L001_R${read}_001.fastq.gz"
    done

    cellranger count \
        --id="$run" \
        --transcriptome="$ref" \
        --fastqs="$fastqs" \
        --sample="$run" \
        --localcores=8 \
        --localmem=60
done
