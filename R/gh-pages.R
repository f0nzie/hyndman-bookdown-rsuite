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

###################################

# system("ls -F")
git_cmd <- "git subtree push --prefix "
output_folder <- "work/book/public"
repository <- "https://github.com/f0nzie/hyndman-bookdown-rsuite.git"
gh_pages <- "gh-pages"

send_cmd <- paste(git_cmd, output_folder, repository, gh_pages, sep = " ")
system(send_cmd)
