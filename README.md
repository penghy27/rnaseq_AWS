# RNA-seq FASTQ Retrieval, Compression & Preprocessing, (pseudo)alignment, quantification
# AWS EC2 Workflow

## Environment
Instance type: t3.large (2 vCPU, 8 GB RAM)  
Storage: Start with 60 GB EBS (default is 30g GB, too small for multiple FASTQ files)  
Operating System: Ubuntu 20.04 or later  
Environment manager: Conda  

## Workflow Overview
Step 1: Create EC2 & Set Up Environment

```
# Connect via SSH
ssh -i ~/yourkey.pem ubuntu@<your-ec2-public-ip>

# Install Miniconda if not present
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Create environment with required tools
conda create -n rnaseq_env -c bioconda -c conda-forge fastqc multiqc pigz sra-tools trimmomatic samtool star rsem
conda activate rnaseq_env

```

Step 2: Retrieve RNA-seq Data (FASTQ)

```
bash getSRA.sh
```

Step 3: Compress FASTQ Files Using pigz  
Due to limited storage space, here we compress fastq files to .gz

```
cd raw_data/

# Compress all .fastq files using pigz (multi-threaded gzip)
pigz *.fastq
```

* ⚠️ pigz will automatically delete original .fastq files after successful compression.  
Each 9–11 GB FASTQ will typically compress down to ~2.5–3.5 GB .fastq.gz.*  

Step 4: Quality Control (FastQC)

```
bash fastqc.sh

```

Step 5: Adapter & Quality Trimming (Trimmomatic)

```
bash seqTrim.sh
```

Step 6: Transcript Quantification (Salmon pseudoalignment)
```
bash salmonQuant_SE.sh
```

Step 7: Import into R (tximport + DESeq2)
```
tximport.R
DEseq.R
```

Optional: STAR Alignment (ongoing work)  

If full genome alignment is needed for downstream applications (e.g., splice junction detection, variant calling)

```
bash star.sh
```

### Recommended Folder Structure
```
project/
├── raw_dat              # FASTQ (.gz)a
├── reference            # Transcriptome fasta + Salmon index
├── results              # All output run by scripts
└── script               # All shell scripts
```




