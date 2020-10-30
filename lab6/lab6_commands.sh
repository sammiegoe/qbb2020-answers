# Index reference genome where downloaded chr6 is in folder ref/
bismark_genome_preparation ref 

# Map experiments to genome 
bismark ref/ -1 E40ICM_rep1.fastq -2 E40ICM_rep2.fastq
bismark ref/ -1 E55Epi_rep1.fastq -2 E55Epi_rep2.fastq

# Sort and index 
for sample in *.bam
do
	samtools sort ${sample}.bam -o ${sample}.sorted.bam
	samtools index ${sample}.sorted.bam
done 

# Visualize with IGV 

# Extract methylation data
bismark_methylation_extractor --bedgraph --comprehensive -p E40ICM_rep1_bismark_bt2_pe.bam
bismark_methylation_extractor --bedgraph --comprehensive -p E55Epi_rep1_bismark_bt2_pe.bam




