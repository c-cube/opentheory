name: gfp-div
version: 1.78
description: GF(p) field division
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
requires: base
requires: gfp-def
requires: gfp-thm
requires: gfp-witness
requires: natural-divides
requires: natural-fibonacci
requires: natural-prime
show: "Data.Bool"
show: "Data.List"
show: "Data.Pair"
show: "Number.GF(p)"
show: "Number.Natural"
show: "Number.Natural.Fibonacci"

def {
  package: gfp-div-def-1.67
}

thm {
  import: def
  package: gfp-div-thm-1.65
}

gcd {
  import: def
  import: thm
  package: gfp-div-gcd-1.66
}

exp {
  import: def
  import: thm
  package: gfp-div-exp-1.44
}

main {
  import: def
  import: thm
  import: gcd
  import: exp
}
