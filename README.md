# This is a folk from jrflab/modules. Please take caution that this module is for development/experiment only.

    The goal for this repo is:
        1. Make genomic calling for WGS work.
        2. Add and explore new features.
        3. Add tests to ensure callers are used properly.

[![Build Status](https://travis-ci.org/cBioPortal/cbioportal.svg?branch=master)](https://travis-ci.org/jrflab/modules)

# Summary
  To start a new project:

            `git clone https://github.com/jrflab/modules.git`

            `./modules/init_project`  or 

            `perl modules/scripts/initProject.pl` 

In addition to the jrflab modules, there is a docs folder, which contains more information about the new receipe implemented/tried in this repo.


# Getting started
    [wiki](https://github.com/jrflab/modules/wiki).

## Installation

## Dependencies
- An instance of [anaconda](https://www.anaconda.com) or [miniconda](https://conda.io/en/latest/miniconda.html)
- IMB's Platform Load Sharing Facility (LSF) or Oracle's Sun Grid Engine (SGE) for resource management

### Following R Packages
- [xxx](https://)

## Best practices
	
### Conventions
- Sample names cannot have "/" or "." in them
- Fastq files end in ".fastq.gz"
- Fastq files are stored in DATA_DIR (Set as Environment Variable) 

### Whole genome, whole exome and targeted sequencing
- QC
- BWA
- Broad Standard Practices on bwa bam  
- Haplotype Caller, Platypus, MuTect, Strelka
- snpEff, Annovar, SIFT, pph2, vcf2maf, VEP, OncoKB, ClinVar
- Copy number, tumor purity using Facets
- Contamination using 
- HLA Typing
	* [xxx](http://)

### RNA transcriptome sequencing
- QC
- Tophat, STAR
- Cufflinks (ENS and UCSC)
- In-house Exon Expression (ENS and UCSC)
- fusion-catcher, tophat-fusion, deFuse
- OncoFuse actionable fusion classification

### Patient:
- Genotyping On Patient. 
	1000g sites are evaluated for every library and then compared (all vs all)
	If two libraries come from a patient the match should be pretty good >80%
- Still to develop:
	If the match is below a certain threshold, break the pipeline for patient

## Detailed usage
[wiki](https://github.com/jrflab/modules/wiki)

## Known issues

### Known bugs

### Currently under development
