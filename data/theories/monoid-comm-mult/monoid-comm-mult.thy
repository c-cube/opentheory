name: monoid-comm-mult
version: 1.5
description: Commutative monoid multiplication
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
requires: base
requires: monoid-mult-add
requires: monoid-mult-def
requires: monoid-mult-thm
show: "Algebra.Monoid"
show: "Data.Bool"
show: "Data.List"
show: "Number.Natural"

def {
  package: monoid-comm-mult-def-1.1
}

thm {
  package: monoid-comm-mult-thm-1.2
}

add {
  package: monoid-comm-mult-add-1.3
}

main {
  import: def
  import: thm
  import: add
}
