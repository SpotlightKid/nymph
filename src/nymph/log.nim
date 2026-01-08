## Copyright 2012-2016 David Robillard <d@drobilla.net>
## Copyright 2012-2016 Christopher Arndt <info@chrisarndt.de>
## SPDX-License-Identifier: ISC
##
## Interface for plugins to log via the host.
##
## See <http://lv2plug.in/ns/ext/log> for details.
##

import urid


const
    lv2LogBaseUri* = "http://lv2plug.in/ns/ext/log"
    lv2LogPrefix = lv2LogBaseUri & "#"
    lv2LogEntry* = lv2LogPrefix & "Entry"
    lv2LogError* = lv2LogPrefix & "Error"
    lv2LogNote* = lv2LogPrefix & "Note"
    lv2LogTrace* = lv2LogPrefix & "Trace"
    lv2LogWarning* = lv2LogPrefix & "Warning"
    lv2LogLog* = lv2LogPrefix & "log"

type
    LogHandle = distinct pointer

    Log* = object
        handle: LogHandle 
        printf*: proc(handle: LogHandle, `type`: Urid, fmt: cstring) {.cdecl, varargs.}

    Logger* = object
        pLog: ptr Log
        Error, Note, Trace, Warning: Urid


proc setup*(logger: var Logger, log: ptr Log, map: ptr UridMap): bool =
  logger.pLog = log

  if not map.isNil:
    logger.Error = map.map(map.handle, lv2LogError)
    logger.Note = map.map(map.handle, lv2LogNote)
    logger.Trace = map.map(map.handle, lv2LogTrace)
    logger.Warning = map.map(map.handle, lv2LogWarning)
  else:
    logger.Error = Urid(0)
    logger.Note =  Urid(0)
    logger.Trace =  Urid(0)
    logger.Warning =  Urid(0)

  return not (log.isNil or map.isNil)

proc log*(logger: Logger, `type`: Urid, msg: string, nl: string = "\n") =
    let mmsg = msg & nl
    if logger.pLog.isNil:
        echo(mmsg)
    else:
        logger.pLog.printf(logger.pLog.handle, `type`, mmsg.cstring)
        

proc error*(logger: Logger, msg: string, nl: string = "\n") =
    log(logger, logger.Error, msg, nl)


proc note*(logger: Logger, msg: string, nl: string = "\n") =
    log(logger, logger.Note, msg, nl)


proc trace*(logger: Logger, msg: string, nl: string = "\n") =
    log(logger, logger.Trace, msg, nl)


proc warning*(logger: Logger, msg: string, nl: string = "\n") =
    log(logger, logger.Warning, msg, nl)
