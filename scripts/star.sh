#!/usr/bin/env bash
# star.sh
# Usage: bash scripts/star.sh 1>results/logs/star.log 2>results/logs/star.err &

echo "Start STAR alignment...: $(date)"
start=$(date +%s)

set -e

# Initialize varialbes 
STAR_INDEX_DIR=~/reference/STAR_mouse_index
Suffix="trimmed.fastq.gz"
THREADS=8
inputPath="raw_data/trimmed/"
outputPath="results/sam/"

mkdir -p $outputPath

# alignAll will loop through all files
function alignAll {
    for fq in $inputPath*$Suffix
    do
	    # extract file name (remove suffix)
        sampleName=$(basename "$fq" "$Suffix")
        echo "$sampleName"
        STAR \
     	--runThreadN $THREADS \
     	--genomeDir $STAR_INDEX_DIR \
     	--readFilesIn "$fq" \
   	--readFilesCommand zcat \
     	--outFileNamePrefix "${outputPath}${sampleName}_" \
     	--outSAMtype BAM SortedByCoordinate
done
}

alignAll

end=$(date +%s)

duration=$((end-start))
minutes=$((duration/60))
seconds=$((end-start%60))

echo "STAR alignment finished!"
echo "STAR alignment duration: ${minutes}minutes ${seconds} seconds"

