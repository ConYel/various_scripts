# Author "Constantinos Yeles" github:conyel 05_Mar_2020
## creating summarize per group from Granges object to 
## get length/width statistics per biotype
tr_sRNA %>% as_tibble() %>% 
  group_by(gene_type) %>% 
  select(gene_type,width) %>% 
  summarise_all(
                c(min = min, 
                  q25 = partial(quantile, probs = 0.25), 
                  median = median, 
                  q75 = partial(quantile, probs = 0.75), 
                  max = max,
                  mean = mean, 
                  sd = sd))
