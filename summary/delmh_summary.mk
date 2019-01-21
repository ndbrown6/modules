include modules/Makefile.inc
# delmh_summary will generate deletion-micromology summary per samples
# the result is saved as tsv/delmh_summary.tsv 

LOGDIR ?= log/delmh_summary.$(NOW)
PHONY += delmh_summary

HOTSPOT ?= $(wildcard $(foreach sample,$(SAMPLES),hotspot/$(sample).txt))

delmh_summary : tsv/delmh_summary.tsv

# step 3: summary of filtered delmh
tsv/delmh_summary.tsv : tsv/delmh_filtered.tsv
	$(call RUN,-n 1 -s 4G -m 4G,"$(RSCRIPT) modules/summary/delmh_summary.R")

# step 2: filter delmh
tsv/delmh_filtered.tsv : tsv/delmh_found.tsv
	$(call RUN,-n 1 -s 4G -m 4G,"$(RSCRIPT) modules/summary/delmh_filter.R")

# step 1: calculate delmh
tsv/delmh_found.tsv : tsv/all.somatic_indels.tsv
	$(call RUN,-n 1 -s 4G -m 4G,"python modules/summary/calc_delmh.py")

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: $(PHONY)
