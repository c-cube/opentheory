name: word16
version: 1.131
description: 16-bit words
author: Joe Leslie-Hurd <joe@gilith.com>
license: MIT
requires: base
requires: byte
requires: natural-bits
requires: natural-divides
requires: probability
show: "Data.Bool"
show: "Data.Byte"
show: "Data.Byte.Bits"
show: "Data.List"
show: "Data.Pair"
show: "Data.Word16"
show: "Data.Word16.Bits"
show: "Number.Natural"
show: "Probability.Random"
hol-light-int-file: hol-light.int
hol-light-thm-file: hol-light.art

def {
  package: word16-def-1.98
}

bits {
  import: def
  package: word16-bits-1.80
}

bytes {
  import: def
  import: bits
  package: word16-bytes-1.87
}

main {
  import: def
  import: bits
  import: bytes
}
