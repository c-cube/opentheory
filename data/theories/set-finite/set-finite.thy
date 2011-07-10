name: set-finite
version: 1.2
description: Finite set theory
author: Joe Hurd <joe@gilith.com>
license: MIT
show: "Data.Bool"
show: "Set"

def {
  package: set-finite-def-1.6
}

thm {
  import: def
  package: set-finite-thm-1.6
}

main {
  import: def
  import: thm
}
