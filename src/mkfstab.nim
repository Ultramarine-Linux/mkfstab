import std/[strutils, strformat, sequtils, sugar, symlinks, paths, dirs, enumerate, logging]
import cligen, sweet
import log, mounts


proc get_mps(root: string, includepseudo: bool): seq[Mount] =
  let mps = getMounts()
  if !mps.len:
    fatal "Fail to get mountpoints from /proc/mounts"
    fatal "The file either does not exist, is empty or unparseable"
    fatal "You should run mkfstab on a system with /proc/mounts"
    fatal "If you are inside a chroot, exit the chroot"
    quit 1
  mps.filter(mp => includepseudo || (mp.device.startsWith('/') && mp.mountpoint.startsWith(root)))

func pad(s: string, max: int): string =
  if max > s.len:
    s & ' '.repeat(max - s.len)
  else:
    s

template `:<`(s: string, max: int): string =
  s.pad max

proc mkfstab(root: seq[string], output = "", includepseudo = false, verbosity = lvlNotice) =
  ## An alternative to genfstab: generate output suitable for addition to /etc/fstab
  setLogFilter verbosity
  if root.len > 1:
    fatal "Specifying multiple roots makes no sense"
    fatal "You are supposed to specify 1 root or default to `/`"
    quit 1
  let root =
    if !root.len:
      warn "Defaulting to `/` as root is not specified"
      "/"
    elif root[0].endsWith '/': root[0] 
    else: root[0] & '/'
  debug fmt"root={root}"
  var mps = get_mps(root, includepseudo)
  var lengths: array[0..3, int] = [0, 0, 0, 0] # uuid, mp, fstype, fsopts
  # turn into UUID=
  for (_, uuid) in walkDir(Path("/dev/disk/by-uuid"), checkDir=true):
    var dev = absolutePath(expandSymlink(uuid), "/dev/disk/by-uuid".Path)
    debug &"Found {uuid.string:<54} → {dev.string}"
    for i, mp in enumerate(mps):
      if mp.device.Path == dev:
        mps[i].device = fmt"UUID={uuid.string}"
  # check lengths for pretty fstab
  for mp in mps:
    lengths = [
      max(mp.device.len, lengths[0]),
      max(mp.mountpoint.len, lengths[1]),
      max(mp.fstype.len, lengths[2]),
      max(mp.mountopts.len, lengths[3]),
    ]
  let outfd = if output == "": stdout else: open(output, fmWrite)
  for mp in mps:
    let dev = mp.device:<lengths[0]
    let mountpoint = mp.mountpoint:<lengths[1]
    let fstype = mp.fstype:<lengths[2]
    let opts = mp.mountopts:<lengths[3]
    outfd.writeLine fmt"{dev} {mountpoint} {fstype} {opts} 0 0"

dispatch mkfstab, help = {
  "root": "[System root for detecting mountpoints]",
  "output": "Path for output file (default is stdout)",
  "includepseudo": "Include pseudofs mounts",
  "verbosity": "set the logging verbosity: {lvlAll, lvlDebug, lvlInfo, lvlNotice, lvlWarn, lvlError, lvlFatal, lvlNone}",
}, short = {"includepseudo": 'P'}
