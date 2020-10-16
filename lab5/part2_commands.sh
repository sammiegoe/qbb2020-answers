# Get 100 strongest ChIP-seq peaks, sorted by p value (-log(p) so sort greatest to least)
sort -k8 -nr CTCF_ER4_peaks.narrowPeak | head -n 100 > ER4_strongest2.bed

# Get fasta sequences for top 100 peaks
bedtools getfasta -fi chr19.fa -bed ER4_strongest2.bed -fo ER4_strongest2.fa

# Check that it has 100 sequences 
grep -c ">" ER4_strongest2.fa 

# Motif finding in strongest 100 peaks, motif widths up to 20 bp
meme-chip ER4_strongest2.fa -meme-maxw 20 

# Scan motifs against JASPAR_CORE_2016 database
tomtom memechip_out/meme_out/meme.txt motif_databases/JASPAR/JASPAR_CORE_2016.meme

# Sort output by p values (column 6) to find strongest motif 
sort -k6 -g tomtom.txt > sorted_tomtom.txt
# Strongest motif was ID MA0139.1

# Create sequence logo with meme
ceqlogo -i motif_databases/JASPAR/JASPAR_CORE_2016.meme -m MA0139.1 -o logo2.eps
# tomtom html output showed logos in reverse comp orientation, so I produced it as well
ceqlogo -i motif_databases/JASPAR/JASPAR_CORE_2016.meme -m MA0139.1 -r -o logo_revcomp.eps -t MA0139.1 

# Convert to pdf 
epstopdf logo2.eps logo2.pdf
epstopdf logo_revcomp.eps logo_revcomp.pdf 