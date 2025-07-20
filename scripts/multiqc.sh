#!/usr/bin/env bash
# multiqc.sh

mkdir -p multiqc_report/

multiqc qc_results/ -o multiqc_report/
