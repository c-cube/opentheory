name: h
version: 1.91
description: Memory safety for the H API
author: Joe Hurd <joe@gilith.com>
license: MIT
requires: base
requires: byte
requires: word10
requires: word12
show: "Data.Bool"
show: "Data.Byte"
show: "Data.List"
show: "Data.Option"
show: "Data.Pair"
show: "Data.Word10"
show: "Data.Word12"
show: "Function"
show: "Number.Natural"
show: "Set"
show: "System.H"

def {
  package: h-def-1.93
}

thm {
  import: def
  package: h-thm-1.95
}

main {
  import: def
  import: thm
}
