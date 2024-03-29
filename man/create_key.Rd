% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_key.R
\name{create_key}
\alias{create_key}
\title{create_key}
\usage{
create_key(
  key_name,
  username,
  password,
  domain,
  permissions = list("edit_dataset", "publish_dataset", "explore_restricted_dataset",
    "manage_dataset", "create_dataset", "create_page", "edit_domain", "edit_page",
    "manage_page", "explore_restricted_dataset", "edit_reuse", "manage_subdomains",
    "explore_monitoring", "edit_theme")
)
}
\arguments{
\item{key_name}{Name des Schlüssels}

\item{username}{ODS-Username}

\item{password}{ODS-Password}

\item{domain}{Domain (z.b. data.tg.ch)}

\item{permissions}{Liste von Berechtigungen, die der Key bekommen soll. Standardmässig werden alle Berechtigungen zugeteilt}
}
\value{
API-Key
}
\description{
Funktion um API-Key zu erstellen, den es später für die Nutzung des Packages braucht.
}
