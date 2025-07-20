#!/usr/bin/env bash
# fastqc.sh

mkdir -p qc_results

fastqc raw_data/*.fastq -o qc_results/
