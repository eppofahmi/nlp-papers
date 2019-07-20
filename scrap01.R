library(rvest)
library(purrr)
library(dplyr)
library(stringr)
library(tidyr)

base_url <- "https://github.com/mihail911/nlp-library"
webpage <- read_html(base_url)

# Get the theme
tema <- html_nodes(webpage, "h2")
tema <- as.data.frame(as.character(html_text(tema)))

# get the title 
judul <- html_nodes(webpage, "#readme li a")
judul <- data.frame(judul = as.character(html_text(judul)))

# get the keterangan
keterangan <- html_nodes(webpage, "li li")
keterangan <- data.frame(keterangan = as.character(html_text(keterangan)))
keterangan <- keterangan %>%
  filter(str_detect(keterangan, "TLDR"))

# links 
links = data.frame(urls = html_nodes(webpage, "#readme li a") %>%
                     html_attr("href"))

# tahun 
tahun <- html_nodes(webpage, "h2+ ul li")
tahun <- data.frame(tahun = as.character(html_text(tahun)))

tahun <- tahun %>%
  separate(tahun, into = c("tahun", "judul"), sep = " ") %>%
  filter(tahun != "TLDR:") %>%
  select(-2)

tahun$tahun <- gsub('[[:punct:] ]+','', tahun$tahun)

nlp_papers <- bind_cols(tahun, judul, keterangan, links)
write.csv(nlp_papers, "nlp_papers.csv")
