name: list-dest
version: 1.0
description: Definitions and theorems about list destructors
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Data.List"

def {
  package: list-dest-def-1.0
}

thm {
  import: def
  package: list-dest-thm-1.0
}

main {
  import: def
  import: thm
}
