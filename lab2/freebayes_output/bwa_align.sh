#!/bin/bash

for fname in *.fastq
do
base=`basename $fname .fastq`
bwa mem -t 4 -R "@RG\tID:${base}\tSM:${base}" /Users/cmdb/qbb2020-answers/lab2/sacCer3.fa "$fname" > "/Users/cmdb/qbb2020-answers/lab2/bwa_output/${base}.sam"

done
