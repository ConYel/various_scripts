# Author "Constantinos Yeles" github:conyel 21_Nov_2019
# creating summarizing table from SPAR resulted tables
## add todate
todate <- format(Sys.time(), "%d_%b_%Y")
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
annot_stat <- c(
  "RNA_class", "Reads", "Peaks")

my_summary <- map(mapstat_files, ~ read_tsv(.x,
                              trim_ws = TRUE,
                              col_names = c("Summary", "Counts", "percent"),
                              col_types = c(
                                Summary = "c",
                                Count = "i", 
                                percent = "n"
                              )) %>% 
  filter(Summary %in% general_stat) %>% 
  mutate(Summary = if_else(Summary == "Reads [all]:",
                           "Reads Final", Summary)) %>% 
    select(-percent)
      ) %>% 
  bind_rows(.id = "samples") %>% 
  mutate(Summary = Summary %>% 
           str_remove(":") %>% 
           str_replace_all(" ","_") %>% 
           str_replace_all("-","_")) %>% 
  pivot_wider(names_from = Summary, values_from = Counts)

my_annot <- map(annot_files, ~ read_tsv(.x, 
                                        trim_ws = TRUE) %>% 
                  rename(RNA_class = "#RNA class") %>% 
                  select(RNA_class, Reads) 
                  ) %>% 
  bind_rows(.id = "samples") %>% 
  mutate(RNA_class = RNA_class %>% 
           str_replace_all("-","_")) %>% 
  pivot_wider(names_from = RNA_class, values_from = Reads)

complete_table <- my_summary %>% 
  inner_join(my_annot, by = "samples") %>% 
  write_tsv(str_glue("summary_full_stat_{todate}.txt"))

