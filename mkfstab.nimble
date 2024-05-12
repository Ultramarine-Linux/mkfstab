# Package

version       = "0.1.0"
author        = "madomado"
description   = "An alternative to genfstab: generate output suitable for addition to /etc/fstab"
license       = "MIT"
srcDir        = "src"
bin           = @["mkfstab"]


# Dependencies

requires "nim >= 2.1.1"
requires "cligen"
requires "sweet"
