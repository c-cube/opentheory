name: list-length
version: 1.0
description: Definitions and theorems about the list length function
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Data.List"
show: "Number.Natural"
show: "Number.Numeral"

def {
  package: list-length-def-1.0
}

thm {
  import: def
  package: list-length-thm-1.0
}

main {
  import: def
  import: thm
}
