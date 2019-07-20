library(tidyverse)

nlp_papers <- read_delim("nlp_papers.csv", 
                         ";", escape_double = FALSE)

# nlp_papers <- nlp_papers %>% 
#   mutate(topik = case_when(
#     row_number() %in% 1:3 ~ "1 : Part-of-speech Tagging", 
#     row_number() %in% 4:5 ~ "2 : Parsing",
#     row_number() %in% 6:7 ~ "3 : Named Entity Recognition",
#     row_number() %in% 8:10 ~ "4 : Coreference Resolution",
#     row_number() %in% 11:12 ~ "5 : Sentiment Analysis",
#     row_number() %in% 13:16 ~ "6 : Natural Logic/Inference",
#     row_number() %in% 17:25 ~ "7 : Machine Translation",
#     row_number() %in% 26:29 ~ "8 : Semantic Parsing",
#     row_number() %in% 30:31 ~ "9 : Question Answering/Reading Comprehension",
#     row_number() %in% 32:35 ~ "10 : Natural Language Generation/Summarization",
#     row_number() %in% 36:45 ~ "11 : Dialogue Systems",
#     row_number() %in% 46:48 ~ "12 : Interactive Learning",
#     row_number() %in% 49:56 ~ "13 : Language Modelling",
#     row_number() %in% 57:65 ~ "14 : Miscellanea"
#     
#   ))

# nlp_papers <- nlp_papers %>%
#   filter(!str_detect(urls, "mihail911"))
# 
# nlp_papers <- nlp_papers %>%
#   separate(topik, into = c("topik_no", "topik"), sep = ":")

abs <- nlp_papers %>%
  filter(str_detect(urls, "abs"))

abs$urls <- paste0(abs$urls, "pdf")
abs$urls <- gsub("abs", "pdf", abs$urls)

nlp_papers1 <- nlp_papers %>%
  filter(!str_detect(urls, "abs"))

nlp_papers <- bind_rows(nlp_papers1, abs)

# write_csv(nlp_papers, "nlp_papers.csv")
nomor <- seq(1:60)

for(i in seq_along(data_1$urls)){
  # download.file(nlp_papers$urls[i], paste0("papers/", nlp_papers$topik_no[i], " - ", 
  #                                          nlp_papers$judul[i], ".pdf"), mode="wb", extra = "wget")
  tryCatch(download.file(nlp_papers$urls[i], paste0("papers/", "file no - ", data_1$X1[i], " - ", data_1$topik_no[i], " - ", 
                                                    data_1$judul[i], ".pdf"), mode="wb", extra = "wget"), 
           error = function(e) print(paste(data_1$judul[i], 'did not work out'))
           )
  }

data_1 <- c("Learning language games through interaction")
data_1 <- as.data.frame(data)
colnames(data_1) <- "judul"


data_1 <- left_join(data_1, nlp_papers, by="judul")
