#!/usr/bin/env bash
# rsemQuant_v2.sh
# Usage: bash scripts/rsemQuant_v2.sh 1>results/logs/rsemQuant_v2.log 2>results/logs/rsemQuant_v2.err &


RSEM_REF_DIR="$HOME/reference/RSEM_mouse_ref/mouse"
THREADS=8
in_folder="raw_data/trimmed/"
out_folder="results/rsem/"

mkdir -p "$out_folder"

for file in ${in_folder}*.fastq.gz; do
    sample=$(basename "$file" trimmed.fastq.gz)
    echo "Processing $sample"
    rsem-calculate-expression \
        --star \
        --star-path "$(dirname $(which STAR))" \
        --single-end \
        --star-gzipped-read-file \
        -p $THREADS \
        "$file" \
        $RSEM_REF_DIR \
        "${out_folder}${sample}"
done
