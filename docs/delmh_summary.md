# Name: 
   delmh_summary

# Description
   Caculate:
    - tsv/delmh_found.tsv:    deletion with microhomology
    - tsv/delmh_filtered.tsv:  filter by apropriate deletion caller filter
    - tsv/delmh_summary.tsv:   sample level summary of deleltions/mh
                                (focusing on del-len>=4, mh-len>=3 for now)

# Input
    tsv/all.somatic_indels.tsv

# Output
```
    - tsv/delmh_found.tsv:    deletion with microhomology
    - tsv/delmh_filtered.tsv:  filter by apropriate deletion caller filter
    - tsv/delmh_summary.tsv:   sample level summary of deleltions/mh
                                (focusing on del-len>=4, mh-len>=3 for now)
```

# Error

# Examples
    `make delm_summary`  # This will generate all 3 output 
