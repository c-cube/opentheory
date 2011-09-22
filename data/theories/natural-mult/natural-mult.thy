name: natural-mult
version: 1.11
description: Definitions and theorems about natural number multiplication
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Number.Natural"

def {
  package: natural-mult-def-1.5
}

thm {
  import: def
  package: natural-mult-thm-1.4
}

order {
  import: thm
  package: natural-mult-order-1.9
}

main {
  import: def
  import: thm
  import: order
}
