#! /usr/bin/env python3

import sys

from fasta_iterator_class import FASTAReader 
#from file name pulling from, import class

#read in query sequence
query = sys.argv[1]
target = sys.argv[2]
k = int(sys.argv[3])

query = FASTAReader(open(query))

#for seq_id, sequence in FASTAReader(open('droYak2_seq.fa')): #give file path
    #print(seq_id, sequence) #one sequence id and one sequence at a time

kmers_query = {} 

#divide query into kmers
#make a dictionary where key is kmer, value is start position
for seq_id, sequence in query:
    for i in range(0, len(sequence) - k + 1):
        kmer = sequence[i: i + k]
        kmers_query.setdefault(kmer, []) 
        kmers_query[kmer].append(i)

#read in target sequences
target = FASTAReader(open(target))

#make nested dictionary for target sequences
kmers_target = {}
# key = frozenset(target_id.items())

for seq_id, sequence in target:
    for i in range(0, len(sequence) - k + 1):
        kmer2 = sequence[i:i + k]
        kmers_target.setdefault(kmer2, {})
        kmers_target[kmer2].setdefault(seq_id,[])
        kmers_target[kmer2][seq_id].append(i)

for key in kmers_query:
    if key in kmers_target:
        target_name = kmers_target[key]
        query_start = kmers_query[key]
        kmer = key
        for key3 in target_name:
            print(str(key3)+'\t'+str((target_name[key3]))+'\t'+
                 (str(query_start))+'\t'+str(kmer))
            
if __name__ == "__main__":
    print("Executed")