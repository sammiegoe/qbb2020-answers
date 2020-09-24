#!/bin/bash

cd /Users/cmdb/qbb2020-answers/lab2/bam_output

for fname in *.sorted.bam
do
	freebayes -f /Users/cmdb/qbb2020-answers/lab2/sacCer3.fa -p 1 --genotype-qualities *.sorted.bam > /Users/cmdb/qbb2020-answers/lab2/freebayes_output/var.vcf

done
