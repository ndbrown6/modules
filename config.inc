ifndef CONFIG_INC

REF ?= b37
SEQ_PLATFORM ?= illumina
SAMPLE_SET_FILE ?= sample_sets.txt
SAMPLE_FILE ?= samples.txt
SAMPLE_SPLIT_FILE ?= samples.split.txt # generate using scripts/prepareFastq.sh [remove underscores from sample names]

##Interpreters
ANACONDA_PYTHON ?= python
PYTHON ?= python
PERL ?= perl
R ?= R
MY_RSCRIPT ?= Rscript
RSCRIPT ?= Rscript

# General python 2.7 environment
ANACONDA_27_ENV ?= $(HOME)/share/usr/anaconda-envs/anaconda-2.7

# SUFAM python environment
SUFAM_ENV ?= $(HOME)/share/usr/anaconda-envs/sufam-dev

MUTSIG_REPORT_ENV = $(HOME)/share/usr/anaconda-envs/mutsig-report-0.0.1

JARDIR ?= $(HOME)/share/usr/lib/java

# jrflab modules environment
JRFLAB_MODULES_ENV ?= $(HOME)/share/usr/anaconda-envs/jrflab-modules-0.1.4

### Applications
UNZIP ?= /usr/bin/unzip
FASTQC ?= $(PERL) $(HOME)/share/usr/FastQC/fastqc
MUTECT_JAR ?= $(JARDIR)/muTect-1.1.7.jar
BOWTIE ?= $(PERL) $(HOME)/share/usr/bowtie2-2.2.4/bowtie2
BWA ?= bwa
#PBWA ?= mpiexec $(HOME)/share/usr/bin/pBWA
#GSNAP ?= $(HOME)/share/usr/bin/gsnap
#GSNAP_REF ?= $(HOME)/share/references/gmapdb/
#GSNAP_MAPS ?= $(GSNAP_REF)/$(REF)/$(REF).maps
SAMTOOLS ?= samtools
SAMTOOLS2 ?= samtools
VCFUTILS ?= $(HOME)/share/usr/bin/vcfutils.pl
BCFTOOLS2 ?= bcftools
BCFTOOLS ?= bcftools
BEDTOOLS ?= $(HOME)/share/usr/bin/bedtools
BGZIP ?= $(HOME)/share/usr/bin/bgzip
IGVTOOLS ?= $(HOME)/share/usr/IGVTools/igvtools
VCFTOOLS ?= $(HOME)/share/usr/bin/vcftools-0.1.10
VCF_SORT ?= $(PERL) $(HOME)/share/usr/bin/vcfsorter.pl

SNP_EFF_JAR ?= $(JARDIR)/snpEff-4.3.jar
SNP_SIFT_JAR ?= $(JARDIR)/SnpSift-4.3.jar
SNP_EFF_CONFIG ?= modules/snpEff.config
#DB_NSFP ?= $(HOME)/share/reference/snpEff/dbNSFP2.4.txt.gz
DB_NSFP ?= $(HOME)/share/reference/snpEff-4.1/dbNSFP3.0b1a.hg19.txt.gz
NSFP_FIELDS ?= Uniprot_acc_Polyphen2 Uniprot_id_Polyphen2 Polyphen2_HVAR_score Polyphen2_HVAR_pred 1000Gp3_AF ESP6500_AA_AF ESP6500_EA_AF MutationAssessor_pred MutationAssessor_score MutationTaster_pred MutationTaster_score PROVEAN_pred ExAC_Adj_AF clinvar_rs clinvar_clnsig Interpro_domain

CUFFLINKS ?= cufflinks
CUFFCMP ?= cuffcompare
#SNVMIX ?= $(HOME)/share/usr/bin/SNVMix2
#BAM2FASTQ ?= $(HOME)/share/usr/bin/bam2fastq
#QUALIMAP ?= $(HOME)/share/usr/qualimap/qualimap
TOPHAT ?= tophat
DEFUSE ?= $(PERL) $(HOME)/share/usr/defuse-0.6.1/scripts/defuse.pl

#VARSCAN
ONCOFUSE_JAR ?= $(HOME)/share/usr/oncofuse-1.0.9b2/Oncofuse.jar
VARSCAN_JAR ?= $(JARDIR)/VarScan.v2.3.9.jar

# PICARD tools
PICARD_DIR ?= $(JARDIR)/picard-1.92
PICARD_JAR ?= $(JARDIR)/picard-tools-1.141/picard.jar

# scripts
SCRIPTS_DIR ?= modules/scripts
MERGE ?= $(SCRIPTS_DIR)/merge.R
VCF_TO_TABLE ?= $(SCRIPTS_DIR)/vcfToTable.R
INTRON_POSN_LOOKUP ?= $(SCRIPTS_DIR)/posnGeneLookup.pl
RBIND ?= $(SCRIPTS_DIR)/rbind.R
NORMAL_FILTER ?= $(PERL) $(SCRIPTS_DIR)/normalFilterVCF.pl
SOMATIC_FILTER_VCF ?= $(PERL) $(SCRIPTS_DIR)/somaticFilterVCF.pl

#JAVA_TMP := $(HOME)/tmp
JAVA_BIN ?=  $(JAVA8_BIN)
JAVA6_BIN ?= $(HOME)/share/usr/jdk1.6.0_45/bin/java
JAVA7_BIN ?= $(HOME)/share/usr/jdk1.7.0_45/bin/java
JAVA8_BIN ?= $(HOME)/share/usr/jdk1.8.0_121/bin/java
#JAVA ?= /usr/bin/java $(JAVA_ARGS)

GET_INSERT_SIZE ?= $(HOME)/share/usr/bin/getInsertSize.py

#GATK
GATK_JAR ?= $(JARDIR)/GenomeAnalysisTK.jar
GATK_JAR2 ?= $(JARDIR)/GenomeAnalysisTK-3.7.jar

VT ?= $(HOME)/share/usr/bin/vt
TABIX ?= $(HOME)/share/usr/bin/tabix

CLUSTER_ENGINE ?= SGE
ifeq ($(CLUSTER_ENGINE),PBS)
MYSQLDB_HOST = cpu-6-2
EMBL_MYSQLDB_HOST = cpu-6-2
EMBL_MYSQLDB_PORT = 9992
EMBL_MYSQLDB_USER = embl
EMBL_MYSQLDB_PW = embl
EMBL_MYSQLDB_DB = homo_sapiens_core_85_37
endif
ifeq ($(CLUSTER_ENGINE),LSF)
MYSQLDB_HOST = lilac
EMBL_MYSQLDB_HOST = lilac
EMBL_MYSQLDB_PORT = 38493
EMBL_MYSQLDB_USER = embl
EMBL_MYSQLDB_PW = embl
EMBL_MYSQLDB_DB = homo_sapiens_core_75_37
endif
ifeq ($(CLUSTER_ENGINE),SGE)
MYSQLDB_HOST = ika
EMBL_MYSQLDB_HOST = ika
EMBL_MYSQLDB_PORT = 38493
EMBL_MYSQLDB_USER = embl
EMBL_MYSQLDB_PW = embl
EMBL_MYSQLDB_DB = homo_sapiens_core_75_37
endif
SNVBOX_CONF = $(PWD)/modules/db/snv_box-$(MYSQLDB_HOST).conf
FATHMM_CONF = $(PWD)/modules/db/fathmm_config-$(MYSQLDB_HOST).ini

INTEGRATE ?= $(HOME)/share/usr/Integrate_0.2.0/bin/Integrate

VCF2MAF ?= $(PERL) $(HOME)/share/usr/bin/vcf2maf.pl
MAF2MAF ?= $(PERL) $(HOME)/share/usr/bin/maf2maf.pl
MAF2VCF ?= $(PERL) $(HOME)/share/usr/bin/maf2vcf.pl

HISAT ?= $(HOME)/share/usr/hisat2-2.0.2-beta/hisat2

TVC ?= $(HOME)/share/usr/bin/tvc

ANNOVAR = $(PERL) $(HOME)/share/usr/annovar-2017-07-16/table_annovar.pl

ONCOTATOR_ENV = $(HOME)/share/usr/venv/oncotator-1.9.2.0

VEP_ENV = $(HOME)/share/usr/anaconda-envs/variant-effect-predictor-86
VEP_PATH = $(VEP_ENV)/bin

SPLIT_BED = python modules/scripts/split_bed.py

INDEL_FILTER_VCF = python modules/vcf_tools/indel_filter_vcf.py
SNP_FILTER_VCF = python modules/vcf_tools/snp_filter_vcf.py

MERGE_VCF = python modules/vcf_tools/merge_vcf.py

endif
CONFIG_INC = true
