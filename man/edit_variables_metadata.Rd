% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/edit_variables_metadata.R
\name{edit_variables_metadata}
\alias{edit_variables_metadata}
\title{edit_variables_metadata}
\usage{
edit_variables_metadata(
  dataset_uid,
  schema,
  lgr_mod = FALSE,
  save_names = FALSE,
  dataset_info = NULL
)
}
\arguments{
\item{dataset_uid}{kann metadta_catalog entnommen werden}

\item{schema}{ausgefülltes Schema excel}

\item{lgr_mod}{boolean ob logger modul vorhanden ist}

\item{save_names}{boolean der angibt ob die Variablennamen aus dem Excel gespeichert werden sollen (nur bei Automatischem Ablauf benötigt)}

\item{dataset_info}{dataset_info Element (nur bei Automatischem Ablauf benötigt)}
}
\description{
Funktion um Namen, Spaltenbeschreibungen und Datentypen zu ändern
}
