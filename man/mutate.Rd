% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mutate.R
\name{mutate}
\alias{mutate}
\alias{mutate,SoilProfileCollection-method}
\title{Transform a SPC with expressions based on site or horizon level attributes}
\arguments{
\item{object}{A SoilProfileCollection}

\item{...}{Comma-separated set of R expressions e.g. \code{thickness = hzdepb - hzdept, hzdepm = hzdept + round(thk / 2)}}
}
\value{
A SoilProfileCollection.
}
\description{
\code{mutate()} is a function used for transforming SoilProfileCollections. It allows the user to specify an arbitrary number of expressions that resolve to the (re-)calculation of one or more site or horizon level attributes. For instance: \code{mutate(spc, thickness = hzdepb - hzdept)}. The expressions may depend on one another, and are evaluated from left to right.
}
\author{
Andrew G. Brown.
}
