# Author "Constantinos Yeles" github:conyel 21_Nov_2019
# creating summarizing table from SPAR resulted tables
## add todate
todate <- format(Sys.time(), "%d_%b_%Y")

dat_path <- str_glue("{my_exp}_analysis")
## import data and make dataframe
library(tidyverse)
path <- "/home/0/Project_piRNA/3_IPP_COLO205_SPAR_results"
mapstat_files <- dir(path, full.names = TRUE,
                      pattern = "MAPSTAT",
                      recursive = TRUE) %>% 
  set_names(. %>% str_remove(".+SPAR_results/") %>%
              str_remove(".trimmed_.+")) %>% 
  as.list()
  
annot_files <- dir(path, full.names = TRUE,
                     pattern = "annotation_summary.txt$",
                     recursive = TRUE) %>% 
  set_names(. %>% str_remove(".+SPAR_results/") %>%
              str_remove(".trimmed_.+")) %>% 
  as.list()

general_stat <- c(
  "FASTQ reads:", "Total mapped reads:", "Uniquely-mapped reads:",
  "Multi-mapped reads:", "Total mapped reads:", "Reads [all]:"
)

<- read_tsv(annot_files[1], 
            trim_ws = TRUE,
         col_names = c("Summary", "Count"),
         col_types = c(
                  Summary = "c",
                  Count = "i"
                  ) 
                ) %>% 
  filter(Summary %in% general_stat) %>% 
  mutate(Summary = if_else(Summary == "Reads [all]:",
                           "Reads Final",Summary)) 

my_sum_list <- map(mapstat_files, ~ read_tsv(.x,
                              trim_ws = TRUE,
                              col_names = c("Summary", "Counts"),
                              col_types = c(
                                Summary = "c",
                                Count = "i",  
                              )) %>% 
  filter(Summary %in% general_stat) %>% 
  mutate(Summary = if_else(Summary == "Reads [all]:",
                           "Reads Final", Summary))
      ) %>% 
  bind_rows(.id = "samples") %>% 
  mutate(Summary = Summary %>% 
           str_remove(":") %>% 
           str_replace_all(" ","_") %>% 
           str_replace_all("-","_")) %>% 
  pivot_wider(names_from = Summary, values_from = Counts)


