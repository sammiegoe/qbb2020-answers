# Convert semicolon delimited to tab delimited

#!/bin/bash 
for file in *.kraken; do
	cat $file | tr '[;]' '[\t]' > new_${file};
done 

# Remove first column 
for file in new_*.kraken; do
	cut -f2- $file > cut_${file};
done

# ktImportText 
# Specify that -n is root, not default all 

for file in cut_new_*.kraken; do
	ktImportText -q -n root -o ${file}.html $file;
done

# Create index
bwa index week13_data/assembly.fasta

# Align paired end reads

#!/bin/bash
for SAMPLE in week13_data/READS/SRR492183 week13_data/READS/SRR492186 week13_data/READS/SRR492188 week13_data/READS/SRR492189 week13_data/READS/SRR492190 week13_data/READS/SRR492193 week13_data/READS/SRR492194 week13_data/READS/SRR492197
do
	bwa mem -t 4 -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}" -o ${SAMPLE}.sam week13_data/assembly.fasta ${SAMPLE}_1.fastq ${SAMPLE}_2.fastq
done

mv *.sam ~/qbb2020-answers/lab10/

# Use samtools 
conda activate cmdb

# Convert SAM to sorted BAM

#!/bin/bash 
for f in *.sam
do
	base=`basename $f .sam`
	echo "Processing $f"
	samtools view $f | samtools sort $f -o ${base}.sorted.bam 
done

# Switch to environment that can use jgi_summarize_bam_contig_depths

# Generate depth file from BAM files
jgi_summarize_bam_contig_depths --outputDepth depth.txt *.bam

# Run metabat
metabat2 -i week13_data/assembly.fasta -a depth.txt -o bins_dir/bin

# MetaBAT 2 (2.15 (Bioconda)) using minContig 2500, minCV 1.0, minCVSum 1.0, maxP 95%, minS 60, maxEdges 200 and minClsSize 200000. with random seed=1607108410
# 6 bins (13187322 bases in total) formed.

metabat2 -i week13_data/assembly.fasta -a depth.txt -o bins_out/bin -v

# Extract scaffold names from each bin and remove the > character

for f in *.fa
do 
	base=`basename $f .fa`
	echo "Processing $f"
	grep ">" $f > ${base}_scaffolds.txt
	cut -c 2- < ${base}_scaffolds.txt > ${base}.txt
done

# Convert Kraken assembly to tab delimited for parsing
cat assembly.kraken | tr '[;]' '[\t]' > new_assembly.txt

# Cut columns 1 and 10 to isolate NODE and species
cut -f 1,11 new_assembly.txt > assembly_species.txt

# Join bin nodes and assembly nodes + species
for f in bins/bin*.txt
do
	base=`basename $f .txt`
	echo "Processing $f"
	join -t $'\t' <(sort $f) <(sort assembly_species.txt) > ${base}_merged.txt
done

# Count unique genus and species for each bin and output to text file 
for f in *merged.txt
do
	base=`basename $f _merged.txt`
	echo "Processing $f"
	printf '%s\n' "${base}" >> out_file.txt
	awk -F '\t' '{print $2}' $f | sort | uniq -c >> out_file.txt
done

