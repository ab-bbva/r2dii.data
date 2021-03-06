library(purrr)
library(usethis)
library(tibble)

source(file.path("data-raw", "utils.R"))

# Setup -------------------------------------------------------------------

#' A view of available sector classification datasets
#'
#' @return A [data.frame] (subclass 'tbl'). The column `code_system` names one
#'   of the classification systems that 2dii uses. All other columns are defined
#'   at [data_dictionary].
#' @noRd
sector_classification_df <- function() {
  out <- enlist_datasets("r2dii.data", pattern = "_classification$")
  out <- purrr::imap(out, ~ transform(.x, code_system = toupper(.y)))
  out <- purrr::map(out, ~ .x[c("sector", "borderline", "code", "code_system")])
  # Coerce every column to character for more robust reduce() and join()
  out <- purrr::map(out, ~ purrr::modify(.x, as.character))
  # Collapse the list of dataframes to a single, row-bind dataframe
  out <- purrr::reduce(out, rbind)
  out <- unique(purrr::modify_at(out, "borderline", as.logical))

  tibble::as_tibble(
    # Reformat code_system
    transform(out, code_system = gsub("_CLASSIFICATION", "", out$code_system))
  )
}

# Use data ----------------------------------------------------------------

library(r2dii.data)
sector_classifications <- sector_classification_df()
check_no_spec(sector_classifications)
use_data(sector_classifications, overwrite = TRUE)
