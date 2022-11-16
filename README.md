
# odsManagementR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Mit odsManagementR kann die ODS Management API direkt aus R heraus bedient werden. So können Datensätze aufgeschaltet, Metadaten verwaltet oder User hinzugefügt werden, ohne das ODS Online Interface für das Backend benutzen zu müssen. 

**HINWEIS:** Die Vorliegende Beschreibung bezieht sich auf das Datenportal des Kanton Thurgaus (data.tg.ch). Zwar können die meisten Funktionen auch auf alle anderen ODS Portale angewendet werden, die hinterlgeten API Calls sind aber auf den Kanton Thurgau ausgelegt.

## Installation

Deie developement Version des Packages kann wie folgt installiert werden:

``` r
devtools::install_github("ogdtg/odsManagementR")
```

## Neuen Datensatz erstellen

Bevor ein neuer Datensatz erstellt werden kann muss eine passende Kennung erzeugt werden. Diese setzt
`r create_new_dataset_id`
``` r
library(odsManagementR)
## basic example code
```

