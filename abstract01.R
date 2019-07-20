library(pdftools)
library(purrr)

setwd("/papers")

file_list <- list.files(".", full.names = TRUE, pattern = '.pdf$')

s_pdf_text <- safely(pdf_text) # helps catch errors

walk(file_list, ~{                                     # iterate over the files
  
  res <- s_pdf_text(.x)                                # try to read it in
  if (!is.null(res$result)) {                          # if successful
    
    message(sprintf("Processing [%s]", .x))
    
    txt_file <- sprintf("%stxt", sub("pdf$", "", .x))  # make a new filename
    
    unlist(res$result) %>%                             # cld be > 1 pg (which makes a list)
      tolower() %>%                                    
      paste0(collapse="\n") %>%                        # make one big text block with line breaks
      cat(file=txt_file)                               # write it out
    
  } else {                                             # if not successful
    message(sprintf("Failure converting [%s]", .x))    # show a message
  }
  
})
