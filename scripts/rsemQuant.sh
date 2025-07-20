#!/usr/bin/env bash
# rsemQuant.sh
# Usage: bash scripts/rsemQuant.sh 1>results/logs/rsemQuant.log 2>results/logs/rsemQuant.err &

RSEM_REF_DIR="$HOME/reference/RSEM_mouse_ref/mouse"
THREADS=8
in_folder="results/star/"
out_folder="results/rsem/"

mkdir -p $out_folder

for file in ${in_folder}*Aligned.sortedByCoord.out.bam; do
    sample=$(basename "$file" _Aligned.sortedByCoord.out.bam)
    echo "Processing $sample"
    rsem-calculate-expression \
    	--alignments \
    	--bam \
    	--no-bam-output \
    	-p $THREADS \
	"$file" \
    	$RSEM_REF_DIR \
    	${out_folder}/${sample}
done


