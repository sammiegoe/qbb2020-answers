#! /usr/bin/env python3

import sys 
import numpy as np 

#read in from command line

fs = open(sys.argv[1])
data = []
for line in fs: 
    data.append(line.rstrip().split('\t')) #split on tab
fs.close()

contigs = []
for line in data:
    contigs.append(int(line[1]))

#sort contigs longest to shortest
all_len = sorted(contigs, reverse=True)
#create array with cumulative sums
csum = np.cumsum(all_len)

#median
n2 = int(sum(contigs)/2)

#get index for cumsum >= N/2, which is the N50 contig
csum2 = min(csum[csum >= n2])
ind = np.where(csum == csum2)
n50 = all_len[int(ind[0])]

print(n50)
