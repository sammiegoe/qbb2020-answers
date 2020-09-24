#!/bin/bash

cd /Users/cmdb/qbb2020-answers/lab2/bwa_output

for f in *.sam
do
base=`basename $f .sam`
echo "Processing $f"
samtools view $f | samtools sort $f -o /Users/cmdb/qbb2020-answers/lab2/bam_output/${base}.sorted.bam
done
