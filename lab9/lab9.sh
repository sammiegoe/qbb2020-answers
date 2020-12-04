# Create genomic partition file
hifive fends -L genome/mm9.len --binned 100000 genome_partition.txt

# Create data file containing counts of interaction reads for each pairs of partitions
hifive hic-data -X data/WT_100kb/raw\*.mat genome_partition.txt data_file.txt

# Create project file
hifive hic-project -f 25 -n 25 -j 100000 data_file.txt project_file.txt

# Normalize data using express method
hifive hic_normalize express -f 25 -w cis project_file.txt

# Extract data for positive and negative compartment scores
grep -v "-" hic_comp.bed > positive_hic_comp.bed
grep "-" hic_comp.bed > negative_hic_comp.bed

# Intersect with WT_fpkm to get gene names
bedtools intersect -a data/WT_fpkm.bed -b pos_hic_comp.bed -f 0.5 -wa > pos_overlap
bedtools intersect -a data/WT_fpkm.bed -b neg_hic_comp.bed -f 0.5 -wa > neg_overlap