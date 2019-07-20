library(data.table)
library(textclean)
library(tidyverse)
library(tidytext)
library(stringi)

# fwrite(dataset,"data/nlp_papers.csv")
dataset <- fread("data/nlp_papers.csv",encoding = "UTF-8")

# dataset$clean_abstrak <- dataset$abstrak
# dataset$encod <- stri_enc_mark(dataset$clean_abstrak)
# 
# data1 <- dataset %>% 
#   filter(encod == "UTF-8")
# data1$clean_abstrak <- stri_encode(data1$clean_abstrak, "UTF-8", "ASCII")
# data1$clean_abstrak <- tolower(data1$clean_abstrak)
# 
# data2 <- dataset %>% 
#   filter(encod != "UTF-8")
# data2$clean_abstrak <- tolower(data2$clean_abstrak)
# 
# 
# dataset <- bind_rows(data1, data2)
# dataset$encod1 <- stri_enc_mark(dataset$clean_abstrak)
# 
# rm(data1, data2)
# 
# dataset$clean_abstrak <- replace_non_ascii(dataset$clean_abstrak)
# dataset$clean_abstrak <- replace_curly_quote(dataset$clean_abstrak)
# dataset$clean_abstrak <- replace_contraction(dataset$clean_abstrak)
# dataset$clean_abstrak <- replace_kern(dataset$clean_abstrak)
# dataset$clean_abstrak <- replace_white(dataset$clean_abstrak)
# dataset$clean_abstrak <- gsub("[[:blank:]]", "", dataset$c)

dataset$clean_abstrak <- gsub("- ", "", dataset$clean_abstrak)
teks_clean <- tweet_cleaner(data = dataset$clean_abstrak)

dataset$clean_abstrak <- teks_clean$clean_text

dataset$clean_abstrak[60]

# top words
top_words <- dataset %>%
  select(topik, clean_abstrak) %>%
  group_by(topik) %>%
  unnest_tokens(term, clean_abstrak, token = "ngrams", n = 2,
                drop = TRUE, to_lower = TRUE) %>%
  count(topik, term, sort = TRUE) %>%
  filter(!term %in% stop_words$word) %>%
  bind_tf_idf(term, topik, n)

top_words %>%
  group_by(topik) %>%
  arrange(desc(tf_idf)) %>%
  slice(1:8) %>%
  ggplot(aes(reorder(term, tf_idf), tf_idf , fill = topik)) +
  geom_col(show.legend = FALSE) + coord_flip() +
  facet_wrap(~topik, scales = "free") + 
  labs(x = "Kata", y = "tf-idf") + 
  scale_fill_viridis_d()

# dataset <- dataset[, -c(10:11)]
# write_csv(dataset, "data/nlp_papers.csv")
