#!/usr/bin/env bash
# getStarIndex.sh
# # Usage: bash scripts/getStarIndex.sh 1>results/logs/getStarIndex.log 2>results/logs/getStarIndex.err &

echo echo "Start trimming: $(date)"
start=$(date +%s)

STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir /reference/STAR_mouse_index \
     --genomeFastaFiles Mus_musculus.GRCm39.dna.primary_assembly.fa \
     --sjdbGTFfile Mus_musculus.GRCm39.111.gtf

end=$(date +%s)

duration = $((end-start))
minutes = $((duration / 60))
seconds = $((start-end % 60))

echo "STAR index finished!"
echo "End time: $(date)"

echo "STAR indexing duration: ${minutes}minutes ${seconds} seconds"


