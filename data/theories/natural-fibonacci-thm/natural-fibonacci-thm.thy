name: natural-fibonacci-thm
version: 1.44
description: Properties of Fibonacci numbers
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
provenance: HOL Light theory extracted on 2014-01-15
requires: base
requires: natural-fibonacci-def
requires: natural-fibonacci-exists
requires: probability
requires: stream
show: "Data.Bool"
show: "Data.List"
show: "Data.Pair"
show: "Data.Stream"
show: "Number.Natural"
show: "Number.Natural.Fibonacci"
show: "Probability.Random"

main {
  article: "natural-fibonacci-thm.art"
}
