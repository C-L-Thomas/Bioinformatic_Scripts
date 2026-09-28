cd $SLURM_SUBMIT_DIR

TAPAS_EXE="../APA_sites_detection"
ANNOTATION="../genome.refFlat.txt"
COVERAGE_DIR="../TAPAS_coverage"
RESULTS_DIR="../TAPAS_results"
READ_LENGTH=51 #based on fastqc results

mkdir -p "$RESULTS_DIR"

for COVERAGE_FILE in "$COVERAGE_DIR"/SRR*.read_coverage.txt
do
    SAMPLE=$(basename "$COVERAGE_FILE" .read_coverage.txt)
    OUTPUT_FILE="${RESULTS_DIR}/${SAMPLE}.APA_sites.txt"

    echo "Starting ${SAMPLE}: $(date)"

    "$TAPAS_EXE" \
        -ref "$ANNOTATION" \
        -cov "$COVERAGE_FILE" \
        -l "$READ_LENGTH" \
        -o "$OUTPUT_FILE"

    echo "Finished ${SAMPLE}: $(date)"
done
