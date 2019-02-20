# This target extract all the pairs if any of them is in the unmapped reads 
include modules/Makefile.inc

LOGDIR ?= log/extract_any_unmapped_pairs.$(NOW)

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: extract_unmapped_pairs

VPATH = bam
JAVA = $(HOME)/share/usr/jdk1.8.0_121/bin/java
PICARD = /lila/data/riazlab/lib/src/picard.jar

extract_any_unmapped_pairs : $(foreach sample,$(SAMPLES),extracted_reads/any_unmapped_pairs/$(sample)_1.fastq.gz)

define extract-unmapped-pairs
## 1. Extract the unique read ID from all the unmmaped_reads
extracted_reads/unmapped_pairs/%.txt: unmapped_reads/%.bam
	$$(call RUN,-c -n 1 -s 4G -m 9G,"$(SAMTOOLS2) view $$< | cut -f1 | sort | uniq > extracted_reads/unmapped_pairs/$$*.txt")

## 2. Extract any/all the paired reads based on the unique ID from step 1
extracted_reads/any_unmapped_pairs/%.bam : extracted_reads/unmapped_pairs/%.txt
	$$(call RUN,-c -n 4 -s 4G -m 9G,"$(JAVA) -jar $(PICARD) FilterSamReads I=bam/$$*.bam O=extracted_reads/any_unmapped_pairs/$$*.bam \
		READ_LIST_FILE=extracted_reads/unmapped_pairs/$$*.txt FILTER=includeReadList")

## 3. Convert the extracted bam files to fastq.gz format
extracted_reads/any_unmapped_pairs/%_1.fastq.gz extracted_reads/any_unmapped_pairs/%_2.fastq.gz : extracted_reads/any_unmapped_pairs/%.bam
	$(call RUN,-n 4 -s 4G -m 9G,"$(SAMTOOLS2) sort -T $(<D)/$* -O bam -n -@ 4 -m 6G $< | $(SAMTOOLS2) fastq -f 1 -1 >(gzip -c > extracted_reads/any_unmapped_pairs/fastq/$*.1.fastq.gz) -2 >(gzip -c > extracted_reads/any_unmapped_pairs/fastq/$*.2.fastq.gz) -")

	################## Previous code to convert to fastq
	# $$(call RUN,-n 4 -s 4G -m 9G,"bamToFastq -i $$< -fq extracted_reads/unmapped_pairs/$$*_1.fastq -fq2 extracted_reads/unmapped_pairs/$$*_2.fastq")
endef
$(foreach pair,$(SAMPLES),\
		$(eval $(call extract-unmapped-pairs,$sample)))
