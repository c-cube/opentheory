name: list-reverse
version: 1.0
description: Definitions and theorems about the list reverse function
author: Joe Hurd <joe@gilith.com>
license: OpenTheory
show: "Data.Bool"
show: "Data.List"

def {
  package: list-reverse-def-1.0
}

thm {
  import: def
  package: list-reverse-thm-1.0
}

main {
  import: def
  import: thm
}