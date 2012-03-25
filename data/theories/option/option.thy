name: option
version: 1.45
description: Option types
author: Joe Hurd <joe@gilith.com>
license: MIT
requires: bool
requires: natural
show: "Data.Bool"
show: "Data.Option"
show: "Number.Natural"

def {
  package: option-def-1.41
}

thm {
  import: def
  package: option-thm-1.32
}

dest {
  import: def
  import: thm
  package: option-dest-1.34
}

main {
  import: def
  import: thm
  import: dest
}
