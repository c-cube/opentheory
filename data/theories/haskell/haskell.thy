name: haskell
version: 1.35
description: The Haskell base
author: Joe Hurd <joe@gilith.com>
license: MIT
provenance: HOL Light theory extracted on 2012-02-26
show: "Data.Bool"
requires: base
requires: natural-fibonacci
requires: probability
show: "Data.Bool"
show: "Data.List"
show: "Data.Option"
show: "Data.Pair"
show: "Haskell"
show: "Number.Natural"
show: "Probability.Random"

def {
  package: haskell-def-1.31
}

thm {
  import: def
  package: haskell-thm-1.29
}

src {
  import: def
  package: haskell-src-1.15
}

test {
  import: def
  package: haskell-test-1.12
}

main {
  import: def
  import: thm
  import: src
  import: test
}
