% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-scope.R
\name{scope_run_print}
\alias{scope_run_print}
\title{Runs and prints from string, in parent environment}
\usage{
scope_run_print(.code_string)
}
\arguments{
\item{.code_string}{A string containing runnable R code.}
}
\value{
Nothing; side effects from \code{print()} only.
}
\description{
Shortcut function to rescope a code string and then run and print output.  Looks for object assignments of the form \code{foo <-} and rescopes to \code{foo <<-}, then evaluates code string.
}
