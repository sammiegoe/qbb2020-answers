# Get 100 strongest ChIP-seq peaks
sort -k7 -nr CTCF_ER4_peaks.narrowPeak | head -n 100 > ER4_strongest.bed

# Get fasta sequences for top 100 peaks
bedtools getfasta -fi chr19.fa -bed ER4_strongest.bed -fo ER4_strongest.fa

# Check that it has 100 sequences 
grep -c ">" ER4_strongest.fa 

# Motif finding in strongest 100 peaks, motif widths up to 20 bp
meme-chip ER4_strongest.fa -meme-maxw 20 

# Scan motifs against JASPAR_CORE_2016 database
tomtom memechip_out/meme_out/meme.txt motif_databases/JASPAR/JASPAR_CORE_2016.meme

# Sort output by p values (column 6) to find strongest motif 
sort -k6 -g tomtom.txt > sorted_tomtom.txt
# Strongest motif was ID MA0139.1

# Create sequence logo with meme
ceqlogo -i motif_databases/JASPAR/JASPAR_CORE_2016.meme -m MA0139.1 -o logo.eps

# Convert to pdf 
epstopdf logo.eps logo.pdf 