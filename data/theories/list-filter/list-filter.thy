name: list-filter
version: 1.0
description: Definitions and theorems about the list filter function
author: Joe Hurd <joe@gilith.com>
license: OpenTheory
show: "Data.Bool"
show: "Data.List"

def {
  package: list-filter-def-1.0
}

thm {
  import: def
  package: list-filter-thm-1.0
}

main {
  import: def
  import: thm
}
