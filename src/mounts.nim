import std/[streams, strformat, strscans]
import log

type Mount* = tuple[device: string, mountpoint: string, fstype: string, mountopts: string]

proc notSpace(input: string, match: var string, start: int): int =
  result = 0
  while input[start+result] != ' ': inc result
  match = input[start..start+result-1]


proc getMounts*(): seq[Mount] =
  var fdmounts = newFileStream("/proc/mounts")
  if fdmounts == nil:
    # cannot open file
    return @[]
  defer: fdmounts.close()
  var linenum = 0
  var line, dev, mp, fstype, mountopts: string
  while fdmounts.readLine line:
    inc linenum
    if scanf(line, "${notSpace} ${notSpace} ${notSpace} ${notSpace} 0 0$.", dev, mp, fstype, mountopts):
      result.add (device: dev, mountpoint: mp, fstype: fstype, mountopts: mountopts)
    else:
      error fmt"Fail to parse /proc/mounts:{linenum} : {line}"
