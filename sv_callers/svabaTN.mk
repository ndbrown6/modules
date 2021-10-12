## Makefile to run https://github.com/walaj/svaba

include modules/Makefile.inc
LOGDIR ?= log/svabaTN.$(NOW)

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: svabaTN

VPATH = bam
CORES=16 ## set any number of cores
#SVABAREF=$(HOME)/share/reference/GATK_bundle/2.3/human_g1k_v37.fasta
SVABAREF=$(REF_FASTA)
DBSNP=/data/riazlab/lib/reference/svaba/dbsnp_indel.vcf

svabaTN : $(foreach pair,$(SAMPLE_PAIRS),svaba/$(pair).svaba.somatic.indel.vcf)

define svaba-tumor-normal
svaba/$1_$2.svaba.somatic.indel.vcf : bam/$1.bam bam/$2.bam
	$$(call RUN,-c -n 16 -s 4G -m 6G -w 7200,"svaba run -t bam/$1.bam -n bam/$2.bam -p $$(CORES) -D $$(DBSNP) -L 100000 -x 25000 -k /data/riazlab/lib/reference/wgs_blacklist_meres.bed -a $1_$2 -G $$(SVABAREF) && mkdir -p svaba && mv *svaba*.vcf svaba/")
endef
$(foreach pair,$(SAMPLE_PAIRS),\
		$(eval $(call svaba-tumor-normal,$(tumor.$(pair)),$(normal.$(pair)))))
