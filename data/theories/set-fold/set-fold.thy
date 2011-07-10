name: set-fold
version: 1.2
description: A fold operation on finite sets
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Set"

def {
  package: set-fold-def-1.6
}

thm {
  import: def
  package: set-fold-thm-1.6
}

main {
  import: def
  import: thm
}
