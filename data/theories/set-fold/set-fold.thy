name: set-fold
version: 1.40
description: A fold operation on finite sets
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
requires: bool
requires: natural
requires: set-finite
requires: set-thm
show: "Data.Bool"
show: "Number.Natural"
show: "Set"

def {
  package: set-fold-def-1.47
}

thm {
  import: def
  package: set-fold-thm-1.37
}

main {
  import: def
  import: thm
}
