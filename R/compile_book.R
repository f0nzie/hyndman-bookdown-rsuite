# Detect proper script_path (you cannot use args yet as they are build with tools in set_env.r)
script_path <- (function() {
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- dirname(sub("--file=", "", args[grep("--file=", args)]))
  if (!length(script_path)) {
    return("R")
  }
  if (grepl("darwin", R.version$os)) {
    base <- gsub("~\\+~", " ", base) # on MacOS ~+~ in path denotes whitespace
  }
  return(normalizePath(script_path))
})()

# Setting .libPaths() to point to libs folder
source(file.path(script_path, "set_env.R"), chdir = T)

config <- load_config()
args <- args_parser()

###############################################################################


# load libraries
library(hyndman.book.pkgs)


source("R/set_folders.R")

loginfo("--> Pandoc version: %s", rmarkdown::pandoc_version())

# change to directory where RMD files are
setwd(book_src_dir)
logdebug(book_src_dir)


if (file.exists("_main.Rmd") || (file.exists("_main.md")))  {
  file.remove("_main.Rmd")
  file.remove("_main.md")
}

# remove the _bookdown_files folder to enable again building the book
# otherwise it will give error at the next notebook
if (dir.exists("_bookdown_files")) {
  loginfo("removing folder")
  unlink("_bookdown_files", recursive = TRUE, force = TRUE)
}

if (dir.exists("_book")) {
  loginfo("removing folder")
  unlink("_book", recursive = TRUE, force = TRUE)
}


# build the book as HTML
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')
# rmarkdown::render_site( encoding = 'UTF-8'
  # output_format = "bookdown::pdf_book")

# render PDF
# rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')

