
# odsManagementR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Mit odsManagementR kann die ODS Management API direkt aus R heraus bedient werden. So können Datensätze aufgeschaltet, Metadaten verwaltet oder User hinzugefügt werden, ohne das ODS Online Interface für das Backend benutzen zu müssen. 

***HINWEIS:*** *Die vorliegende Beschreibung bezieht sich auf das Datenportal des Kanton Thurgaus (data.tg.ch). Zwar können die meisten Funktionen auch auf alle anderen ODS Portale angewendet werden, die hinterlgeten API Calls sind aber auf den Kanton Thurgau ausgelegt.*

## Installation

Die developement Version des Packages kann wie folgt installiert und genutzt werden:

``` r
devtools::install_github("ogdtg/odsManagementR")
library(odsManagementR)
```

## Liste aller Datensätze erhalten

Mit der Funktion `r get_dataset_info` wird der aktuelle Metdata katalog heruntergeladen. Dieser beinhaltet die Metadaten aller Datensätze, die sich derzeit auf dem Datenportal befinden. Hierzu zählen auch unveröffentlichte Datensätze sowie Datenkataloge. Die Funktion erzeugt automatisch eine Environment Variable "metadata_catalog", die die Daten erhält. Die Funktion wird von mehreren anderen Funktionen verwendet, um sicher zugehen, dass der Katalog immer auf dem neuesten Stand ist. 

*Der Parameter `r path` ist standardmässig auf einen lokalen Order des Kantons gesetzt, kann aber geändert werden.*

``` r
get_dataset_info(path=path)
## creates variable "metadata_catalog" and saves it under path 
```



## Neuen Datensatz erstellen

### Datensatzkennung erstellen
Bevor ein neuer Datensatz erstellt werden kann muss eine passende Kennung erzeugt werden. Diese setzt sich im Kanton Thurgau wie folgt zusmamen: departement-amt-laufende Numemer (z.B. sk-stat-1). ODS erlaubt es eine Kennung für mehrere Datensätze anzulegen, da intern automatisch eine eindeutige `r dataset_uid` zugewiesen wird. Daher muss darauf geachtet werden, dass die Kennungen eindeutig sind, um Verwirrungen zu vermeiden. Die `r create_new_dataset_id` gewährleistet eindeutige Kennungen, indem sie für eine gegebene kennung die korrekte laufende Nummer zuweist.

``` r
create_new_dataset_id("sk-stat")
## returns "sk-stat-116" 
```



