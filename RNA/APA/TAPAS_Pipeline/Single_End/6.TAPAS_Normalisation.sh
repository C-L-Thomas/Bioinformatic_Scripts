cd "$SLURM_SUBMIT_DIR"

############################################################
# README
############################################################
#
# This script normalises the original TAPAS output files.
#
# Original TAPAS columns:
#
# Column 1: Gene ID
# Column 2: Chromosome
# Column 3: Strand
# Column 4: APA site coordinates
# Column 5: TAPAS abundance
# Column 6: TAPAS read counts
#
# TAPAS abundance = Read count / Associated UTR length
#
# Additional columns:
#
# Column 7: Normalised TAPAS abundance (RPKM-like)
#
#   (TAPAS abundance / Library size) * 1000000000
#
# Column 8: Normalised read counts (CPM)
#
#   (Read count / Library size) * 1000000
#
# Column 9: Relative APA abundance (%)
#
#   (APA site abundance / Total gene abundance) * 100
#
# Total gene abundance is the sum of TAPAS abundances
# for all detected APA sites within a gene and sample.
#
# Library sizes were previously calculated using samtools
# and are retrieved from library_sizes.tsv.
#
# Relative abundance does not require library normalisation.
#
# All APA site values remain comma-separated and in their
# original order.
#
############################################################


#################### Input and output ####################

RESULTS_DIR="/TAPAS_results"

LIBRARY_SIZES="library_sizes.tsv"

OUTPUT_DIR="/TAPAS_normalised"

mkdir -p "$OUTPUT_DIR"


#################### Normalisation ####################

for INPUT_FILE in "$RESULTS_DIR"/SRR*.APA_sites.txt
do

    # Get sample name
    SAMPLE=$(basename "$INPUT_FILE" .APA_sites.txt)

    # Define output file
    OUTPUT_FILE="$OUTPUT_DIR/$SAMPLE.APA_sites.normalised.txt"

    # Retrieve library size from the samtools results
    LIB_SIZE=$(awk -v sample="$SAMPLE" '$1 == sample {print $2}' "$LIBRARY_SIZES")

    # Calculate normalised values
    awk -v library_size="$LIB_SIZE" '

    BEGIN {
        FS = "\t"
        OFS = "\t"
    }

    {
        # Separate the comma-separated values
        number_of_sites = split($5, abundance, ",")
        split($6, counts, ",")

        # Calculate total gene abundance
        total_abundance = 0

        for (i = 1; i <= number_of_sites; i++) {
            total_abundance = total_abundance + abundance[i]
        }

        # Create empty output columns
        normalised_abundance = ""
        normalised_counts = ""
        relative_abundance = ""

        # Calculate measurements for each APA site
        for (i = 1; i <= number_of_sites; i++) {

            # Column 7: Normalised TAPAS abundance
            norm = (abundance[i] / library_size) * 1000000000

            # Column 8: CPM normalised read counts
            cpm = (counts[i] / library_size) * 1000000

            # Column 9: Relative abundance
            if (total_abundance > 0) {
                relative = (abundance[i] / total_abundance) * 100
            } else {
                relative = "NA"
            }

            # Round values to six decimal places
            norm = sprintf("%.6f", norm)
            cpm = sprintf("%.6f", cpm)

            if (relative != "NA") {
                relative = sprintf("%.6f", relative)
            }

            # Add commas between APA sites
            if (i > 1) {
                normalised_abundance = normalised_abundance ","
                normalised_counts = normalised_counts ","
                relative_abundance = relative_abundance ","
            }

            # Add values to the output columns
            normalised_abundance = normalised_abundance norm
            normalised_counts = normalised_counts cpm
            relative_abundance = relative_abundance relative
        }

        # Print original columns and three new columns
        print $0, normalised_abundance, normalised_counts, relative_abundance
    }

    ' "$INPUT_FILE" > "$OUTPUT_FILE"

done
