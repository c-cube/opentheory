name: list
version: 1.2
description: Basic theory of list types
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Data.List"
show: "Function"
show: "Number.Natural"
show: "Number.Numeral"

def {
  package: list-def-1.0
}

thm {
  import: def
  package: list-thm-1.0
}

dest {
  import: def
  import: thm
  package: list-dest-1.2
}

append {
  import: def
  import: thm
  import: dest
  package: list-append-1.0
}

map {
  import: def
  import: thm
  import: append
  package: list-map-1.0
}

quant {
  import: def
  import: append
  import: map
  package: list-quant-1.0
}

filter {
  import: def
  import: append
  import: map
  package: list-filter-1.0
}

last {
  import: def
  import: thm
  import: append
  package: list-last-1.0
}

reverse {
  import: def
  import: append
  package: list-reverse-1.0
}

length {
  import: def
  import: thm
  import: dest
  import: append
  import: map
  package: list-length-1.0
}

nth {
  import: def
  import: thm
  import: dest
  import: append
  import: map
  import: last
  import: length
  package: list-nth-1.0
}

replicate {
  import: length
  import: nth
  package: list-replicate-1.0
}

member {
  import: def
  import: append
  import: map
  import: quant
  import: filter
  import: length
  import: nth
  package: list-member-1.0
}

concat {
  import: def
  import: dest
  import: append
  import: quant
  package: list-concat-1.1
}

take-drop {
  import: def
  import: thm
  import: dest
  import: append
  import: length
  import: nth
  package: list-take-drop-1.1
}

interval {
  import: length
  import: nth
  package: list-interval-1.1
}

zipwith {
  import: def
  import: dest
  import: length
  package: list-zipwith-1.1
}

nub {
  import: def
  import: length
  import: member
  package: list-nub-1.0
}

main {
  import: def
  import: thm
  import: dest
  import: append
  import: map
  import: quant
  import: filter
  import: last
  import: reverse
  import: length
  import: nth
  import: replicate
  import: member
  import: concat
  import: take-drop
  import: interval
  import: zipwith
  import: nub
}
