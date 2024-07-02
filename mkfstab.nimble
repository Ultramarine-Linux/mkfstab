# Package

version       = "0.1.2"
author        = "madomado"
description   = "An alternative to genfstab: generate output suitable for addition to /etc/fstab"
license       = "MIT"
srcDir        = "src"
bin           = @["mkfstab"]


# Dependencies

requires "nim >= 2.0.0"
requires "cligen"
requires "sweet"
