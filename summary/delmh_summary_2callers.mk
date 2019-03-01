include modules/Makefile.inc
# delmh_summary will generate deletion-micromology summary per samples
#  -- this target will use only 2 callers as filters
# the result is saved as tsv/delmh_summary.tsv 

LOGDIR ?= log/delmh_summary_2callers.$(NOW)
PHONY += delmh_summary_2callers
DEFAULT_ENV = $(HOME)/share/usr/anaconda-envs/jrflab-modules-0.1.4

delmh_summary_2callers : tsv/delmh_summary.tsv

# step 3: summary of filtered delmh
tsv/delmh_summary.tsv : tsv/delmh_filtered.tsv
	$(call RUN,-n 1 -s 8G -m 8G -v $(DEFAULT_ENV),"$(RSCRIPT) modules/summary/delmh_summary.R")

# step 2: filter delmh - any deletions with 2 callers
tsv/delmh_filtered.tsv : tsv/delmh_found.tsv
	$(call RUN,-n 1 -s 8G -m 8G -v $(DEFAULT_ENV),"$(RSCRIPT) modules/summary/delmh_filter_2callers.R")

# step 1: calculate delmh
tsv/delmh_found.tsv : tsv/all.somatic_indels.tsv
	$(call RUN,-n 1 -s 8G -m 8G -v $(DEFAULT_ENV),"python modules/summary/calc_delmh.py" --ref-fasta $(REF_FASTA))

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: $(PHONY)
