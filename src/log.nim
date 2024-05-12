import std/logging

var logger = newConsoleLogger(fmtStr="mkfstab: $levelname: ", useStderr=true)
addHandler logger

export debug, error, fatal, info, log, notice, warn
