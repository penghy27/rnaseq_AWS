#!/usr/bin/env bash
# salmonQuant_SE.sh
# Usage: bash scripts/salmonQuant_SE.sh 1>results/logs/salmonQuant.log 2>results/logs/salmonQuant.err &

in_dir="raw_data/trimmed/"
out_dir="salmon_out"
INDEX_dir="index"

mkdir -p "$out_dir"

# loop over all files 
function salmon_se {
    for fq in "$in_dir$"*.trimmed.fastq
    do
        # Remove path to get sample name
	filename=$(basename "$fq")
        sample="${filename%.trimmed.fastq}"   # remove path
    	
	echo "Processing $sample..."

        salmon quant -l A \
        -r "$fq" \
	-i "INDEX_dir" \
	--validateMappings \       
	-o "$out_dir/$sample" \ 
    done        
}

salmon_se
