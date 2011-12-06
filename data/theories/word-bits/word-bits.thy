name: word-bits
version: 1.30
description: Word to bit-list conversions
author: Joe Hurd <joe@gilith.com>
license: MIT
requires: bool
requires: natural
requires: list
requires: word-def
show: "Data.Bool"
show: "Data.List"
show: "Data.Word"
show: "Data.Word.Bits"
show: "Number.Natural"

def {
  package: word-bits-def-1.30
}

thm {
  import: def
  package: word-bits-thm-1.33
}

main {
  import: def
  import: thm
}
