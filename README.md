# mkfstab

An alternative to [`genfstab` from Arch Linux](https://wiki.archlinux.org/title/Genfstab).
This is a dead simple but faster implementation of `genfstab`.

## ❓ Usage

(Last update: version 0.1.0)
```sh
$ mkfstab -h
Usage:
  mkfstab [optional-params] [System root for detecting mountpoints]
An alternative to genfstab: generate output suitable for addition to /etc/fstab
Options:
  -h, --help                              print this cligen-erated help
  --help-syntax                           advanced: prepend,plurals,..
  -o=, --output=       string  ""         Path for output file (default is stdout)
  -P, --includepseudo  bool    false      Include pseudofs mounts
  -v=, --verbosity=    Level   lvlNotice  set the logging verbosity: {lvlAll, lvlDebug, lvlInfo, lvlNotice, lvlWarn, lvlError, lvlFatal, lvlNone}
```

## 🏗️ Building

1. Install [Nim](https://nim-lang.org)
  - if you are on [Terra](https://terra.fyralabs.com) / Ultramarine Linux: `sudo dnf in nim`
2. `nimble build`

## 🗒️ Todos
- [ ] Make it compatible with genfstab: https://man.archlinux.org/man/genfstab.8
