# indexcovTN needs goleft binary to work:
# https://github.com/brentp/goleft/tree/master/indexcov
#
include modules/Makefile.inc

LOGDIR ?= log/indexcovTN.$(NOW)
PHONY += indexcovTN

indexcovTN : $(foreach pair,$(SAMPLE_PAIRS),indexcovTN/$(tumor.$(pair))/index.html)


define run-indexcovTN
indexcovTN/$1/index.html : bam/$1.bam bam/$2.bam
	$$(call RUN,-n 2 -s 4G -m 6G,"mkdir -p indexcovTN/$1; \
		                          goleft indexcov -d indexcovTN/$1 bam/$1.bam bam/$2.bam")
endef
$(foreach pair,$(SAMPLE_PAIRS),\
		$(eval $(call run-indexcovTN,$(tumor.$(pair)),$(normal.$(pair)))))

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: $(PHONY)
