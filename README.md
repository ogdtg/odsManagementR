
# odsManagementR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Mit odsManagementR kann die ODS Management API direkt aus R heraus bedient werden. So können Datensätze aufgeschaltet, Metadaten verwaltet oder User hinzugefügt werden, ohne das ODS Online Interface für das Backend benutzen zu müssen. 

***HINWEIS:*** *Die vorliegende Beschreibung bezieht sich auf das Datenportal des Kanton Thurgaus [data.tg.ch](https://data.tg.ch/pages/start/). Zwar können die meisten Funktionen auch auf alle anderen ODS Portale angewendet werden, die hinterlgeten API Calls sind aber auf den Kanton Thurgau ausgelegt.*

## Installation

Die Dvelopement Version des Packages kann wie folgt installiert und genutzt werden:

``` r
devtools::install_github("ogdtg/odsManagementR")
library(odsManagementR)
```

## Liste aller Datensätze erhalten

Mit der Funktion `get_dataset_info` wird der aktuelle Metdata Katalog heruntergeladen. Dieser beinhaltet die Metadaten aller Datensätze, die sich derzeit auf dem Datenportal befinden. Hierzu zählen auch unveröffentlichte Datensätze sowie Datenkataloge. Die Funktion erzeugt automatisch eine Environment Variable `metadata_catalog`, die die Daten erhält. Die Funktion wird von mehreren anderen Funktionen verwendet, um sicher zugehen, dass der Katalog immer auf dem neuesten Stand ist. Ausserdem wird der Katalog jedes mal auf dem Lokalen Pfad, der bei `path` angegeben ist gespeichert.

*Der Parameter `r path` ist standardmässig auf einen lokalen Order des Kantons gesetzt, kann aber geändert werden.*

``` r
get_dataset_info(path=path)
## creates variable "metadata_catalog" and saves it under path 
```



## Neuen Datensatz erstellen

### Wrapper Funktion

Um Datensätze zu erstellen und sie direkt mit den Metadaten aus dem Excel Schema zu befüllen kann die wrapper-Funktion `add_metadata_from_scheme` verwendet werden. Hierzu muss lediglich der Pfad zum ausgefüllten Schema als `filepath` angeggeben werden. Optional kann noch eine Liste von `zuschreibungen` angegeben werden (default ist `NULL`). Wenn der Datensatz **NICHT** geharvested werden soll, muss `harvesting=FALSE` gesetzt werden (default ist `TRUE`). Die Funktion gibt die `dataset_uid` des neu erstellten Datensatzes zurück

Die einzelnen Schritte innerhalb der Funktion werden nachfolgend kurz beschrieben.

```r
dataset_uid <- add_metadata_from_scheme(filepath="path/to/schema.xlsx", harvesting = TRUE, zuschreibungen = NULL)
```.

### Datensatzkennung erstellen
Bevor ein neuer Datensatz erstellt werden kann, muss eine passende Kennung erzeugt werden. Diese setzt sich im Kanton Thurgau wie folgt zusmamen: departement-amt-laufende Numemer (z.B. sk-stat-1). ODS erlaubt es eine Kennung für mehrere Datensätze anzulegen, da intern automatisch eine eindeutige `dataset_uid` zugewiesen wird. Daher muss darauf geachtet werden, dass die Kennungen eindeutig sind, um Verwirrungen zu vermeiden. Die `create_new_dataset_id` gewährleistet eindeutige Kennungen, indem sie einer gegebenen Teilkennung die korrekte laufende Nummer zuweist.

``` r
dataset_id <- create_new_dataset_id(part_id = "sk-stat")
## returns "sk-stat-116" 
```
### Template Datensatz duplizieren
Um gleichbleibende Metadaten nicht jedes mal neu einfügen zu müssen, lohnt es sich im ODS einen template Datensatz zu erstellen, der dann immer wieder dupliziert und neu befüllt wird. Dies kann mit der `duplicate_dataset` Funktion erreicht werden. Natürlich kann so auch jeder andere Datensatz kopiert dupliziert werden (nur Metadaten, nicht Datenquelle).
Hierbei muss die `dataset_uid` des zu kopierenden Datensatzes als `copy_id`angegeben werden. Ausserdem die neue Kennung als `new_id` sowie der neue Titel als `title`. Hier bitte auf die richtige Kennung und einen eindeutigen Titel achten. Die Funktion gibt die `dataset_uid` des neu erzeugten Datensatz zurück.

```r
dataset_uid <- duplicate_dataset(copy_id = "da_xxxxxx",new_id = dataset_id,title = new_title)
## returns dataset_uid in format da-xxxxxx
```

### Metadaten einfügen
Metadate können mithilfe der `set_metadata` Funktion eingefügt werden. Beim Parameter `dataset_id` muss die `dataset_uid` in Form `da-xxxxxx` anegeben werden. Dieser Parameter gibt an, für welchen Datensatz Metadaten gesetzt werden sollen. Die verfügbaren Werte für `template` können den Metadaten eines Datensatzes entnommen werden (Funktion `get_metadata(dataset_uid)`). Für data.tg.ch sind dies `custom`,`visualization`,`dcat`,`default`,`dcat_ap_ch` oder `internal`. Diese Werte sind als eine Art Übergruppe der einzelnen Metadaten zu verstehen und tauchen so teilweise auch im ODS Backend auf. Als `meta_name` muss der entsprechende Wert des Metadaten FelDes angegeben werden (z.B. `title`). Schliesslich muss der Wert, der gesetzt werden soll als `meta_value` angegeben werden. Für manche Metadaten Felder muss eine Liste als `meta_value` angegeben werden. Innerhalb der `add_metadata_from_scheme` Funktion wird für diesen Umstand kontrolliert und es werden automatisch listen erzeugt, wo es notwendig ist. Weitere Informatioenn können der offiziellen [Dokumentation der ODS Management API](https://betahelp.opendatasoft.com/management-api/#dataset-metadata) entnommen werden.

```r
set_metadata(dataset_id = "da-xxxxxx",
             template="default",
             meta_name="title",
             meta_value = "New Title for Dataset")

```

## Daten hinzufügen

### Wrapper Funktion

Um um CSV Dateien vom loakeln System ins ODS zu laden, den im vorherigen Schrit erstellten Metadatensatz mit der Datenresource zu verbinden und die Spaltenbeschreibungen und Datentypen zu bearbeiten kann die `add_data_to_dataset` Funktion verwendet werden. Als Parameter muss hier die `dataset_uid` anegegeben werden, die `add_metadata_from_scheme` zurück gibt. Ausserdem muss der Pfad zum ausgefüllten Schema sowie zum lokalen CSV File mit den Daten angegeben werden. Schliesslich muss ein Titel für die Resource auf ODS angegeben werden.

```r
add_data_to_dataset(
  dataset_uid = dataset_uid,
  schema = "path/to/schema.xlsx",
  ogd_file = "path/to/upload_data.csv",
  resource_title = "New Resource Title"
)
```

Die enthaltenen Schritte werden nun kurz erläutert.

### Lokale CSV Datei auf ODS hochladen

### Resource mit Metadaten verknüpfen

### Spaltennamen und -beschreibungen sowie Datentypen ergänzen







