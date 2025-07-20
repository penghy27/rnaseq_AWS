#!/usr/bin/env bash
# getRSEMref.sh
# Usage: bash scripts/getRSEMref.sh 1>results/logs/getRSEMref.log 2>results/logs/getRSEMref.err &

echo "Start RSEM reference...: $(date)"
start=$(date +%s)

rsem-prepare-reference \
  --gtf reference/Mus_musculus.GRCm39.110.gtf \
  reference/Mus_musculus.GRCm39.dna.primary_assembly.fa \
  /reference/RSEM_mouse_ref/mouse

end=$(date +%s)

duration = $((end-start))
minutes = $((duration / 60))
seconds = $((start-end % 60))

echo "RSEM reference finished!"
echo "End time: $(date)"

echo "RSEM reference duration: ${minutes}minutes ${seconds} seconds"
