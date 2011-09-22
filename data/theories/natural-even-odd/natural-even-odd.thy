name: natural-even-odd
version: 1.5
description: Definitions and theorems about natural number even and odd
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Number.Natural"

def {
  package: natural-even-odd-def-1.4
}

thm {
  import: def
  package: natural-even-odd-thm-1.4
}

main {
  import: def
  import: thm
}
