name: relation
version: 1.54
description: Relation operators
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
requires: bool
requires: function
requires: natural
requires: pair
requires: set
show: "Data.Bool"
show: "Data.Pair"
show: "Function"
show: "Number.Natural"
show: "Relation"
show: "Set"

def {
  package: relation-def-1.23
}

thm {
  import: def
  package: relation-thm-1.10
}

well-founded {
  import: def
  import: thm
  package: relation-well-founded-1.50
}

natural {
  import: def
  import: thm
  import: well-founded
  package: relation-natural-1.30
}

main {
  import: def
  import: thm
  import: well-founded
  import: natural
}
