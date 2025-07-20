#!/usr/bin/env bash
# TrimSE.sh
# Usage: bash scripts/TrimSE.sh 1>results/logs/TrimSE.log 2>results/logs/TrimSE.err &

echo "Start trimming: $(date +%s)"
start=$(date +%s)

set -e

# Set folder
in_folder="raw_data"
out_folder="raw_data/trimmed/

mkdir -p "$out_folder"

# Get adapter path
ADAPTER_PATH=$(ls $CONDA_PREFIX/share/trimmomatic-*/adapters/TruSeq3-SE.fa | head -1)

# Define trimming function
function trim_se {
    in_dir=$1
    out_dir=$2
    fq_file=$3

    in_path="${in_dir}${fq_file}"
    out_path="${out_dir}${fq_file%.fastq}.trimmed.fastq"

    trimmomatic SE \
        -threads 2 -phred33 \
        "$in_path" \
        "$out_path" \
        ILLUMINACLIP:"$ADAPTER_PATH":2:30:10 \
        HEADCROP:0
	LEADING:20 TRAILING:20 SLIDINGWINDOW:4:30 MINLEN:36
}

# === Batch processing all fastq files ====

for fq in $({in_folder}*.fastq); do
    # extract file name
    fq_file=$(basename "$fq")
    echo "Trimming $fq_file..."
    trim_se "$in_folder" "$out_folder" "$fq_file"
done

end=$(date +%s)
echo "All files finished!"
echo "End trimming: $(date +%s)"
echo "Trimming duration: $((end-start)) seconds"





