import parseutils, strutils

proc splitArgs*(args: string): seq[string] =
  var
    parsed, tmp: string
    i, quotes: int
  
  while i < args.len:
    i += args.parseUntil(parsed, Whitespace, i) + 1
    tmp.add(parsed)
    if parsed.startsWith('"'):
      quotes.inc
    if parsed.endsWith('"'):
      quotes.dec
    elif quotes > 0:
      tmp.add(" ")
    
    if quotes == 0:
      #tmp.removePrefix('"')
      result.add(tmp)
      tmp = ""
  
  if tmp.len > 0:
    result.add(tmp[1 .. ^2])