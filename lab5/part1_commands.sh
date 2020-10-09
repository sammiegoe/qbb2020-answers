# List of commands for lab 5

# Build an index
bowtie2-build chr19.fa chr19

# Map the reads 
# Unpaired reads
for sample in CTCF_ER4 CTCF_G1E input_ER4 input_G1E
do
	bowtie2 -x chr19 -U ${sample}.fastq -S ${sample}.sam -p 6
	samtools view -bSo ${sample}.bam ${sample}.sam
	samtools sort ${sample}.bam -o ${sample}.sorted.bam
	samtools index ${sample}.sorted.bam
done

# Calling peaks
macs2 callpeak -t CTCF_ER4.bam -c input_ER4.bam --format=BAM --name=CTCF_ER4 \
--gsize=61000000 --tsize=26

macs2 callpeak -t CTCF_G1E.bam -c input_G1E.bam --format=BAM --name=CTCF_G1E \
--gsize=61000000 --tsize=26

# Differential binding
# Sites lost in ER4 line
bedtools intersect \
-a CTCF_G1E_peaks.narrowPeak \
-b CTCF_ER4_peaks.narrowPeak \
-v -wo > CTCF_siteslost.bed # -v reports entries in A that have no overlap in B

# Sites gained in ER4 line, reports entries in A that have no overlap in B
bedtools intersect \
-a CTCF_ER4_peaks.narrowPeak \
-b CTCF_G1E_peaks.narrowPeak \
-v -wo > CTCF_sitesgained.bed

# Sites lost in G1E line
bedtools intersect \
-a CTCF_ER4_peaks.narrowPeak \
-b CTCF_G1E_peaks.narrowPeak \
-v -wo > G1E_siteslost.bed

# Sites gained in G1E line
bedtools intersect \
-a CTCF_G1E_peaks.narrowPeak \
-b CTCF_ER4_peaks.narrowPeak \
-v -wo > G1E_sitesgained.bed

# Feature overlapping
bedtools intersect \
-a Mus_musculus.GRCm38.94_features.bed \
-b CTCF_ER4_peaks.narrowPeak CTCF_G1E_peaks.narrowPeak -C -filenames -wo > overlaps.bed

# Getting number of binding sites in each type of region
# Repeated for each region and cell type
grep "ER4" overlaps.bed | grep "promoter" | cut -f 8 | paste -sd+ - | bc
# Created txt file called feature_overlaps.txt and manually wrote tab-delimited dataset

# Getting number of sites lost and gained
wc CTCF_sitesgained.bed
wc CTCF_siteslost.bed
wc G1E_sitesgained.bed
wc G1E_siteslost.bed
# Manually wrote to txt file called differential_binding.txt tab-delimited 
# Sites gained in ER4 is same as sites lost in G1E



