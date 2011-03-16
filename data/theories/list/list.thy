name: list
version: 1.1
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

case {
  import: def
  package: list-case-1.0
}

dest {
  import: def
  import: thm
  package: list-dest-1.0
}

append {
  import: def
  import: thm
  import: dest
  package: list-append-1.1
}

map {
  import: def
  import: thm
  import: append
  package: list-map-1.1
}

quant {
  import: def
  import: append
  import: map
  package: list-quant-1.1
}

filter {
  import: def
  import: append
  import: map
  package: list-filter-1.1
}

last {
  import: def
  import: thm
  import: append
  package: list-last-1.1
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
  package: list-length-1.1
}

nth {
  import: def
  import: thm
  import: dest
  import: append
  import: map
  import: last
  import: length
  package: list-nth-1.1
}

replicate {
  import: length
  import: nth
  package: list-replicate-1.1
}

member {
  import: def
  import: append
  import: map
  import: quant
  import: filter
  import: length
  import: nth
  package: list-member-1.1
}

concat {
  import: def
  import: dest
  import: append
  import: quant
  package: list-concat-1.0
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
  package: list-zipwith-1.0
}

main {
  import: def
  import: thm
  import: case
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
}
