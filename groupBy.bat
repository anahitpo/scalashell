::#!
@echo off
for /f "tokens=*" %%a in ('where %0') do @set loc=%%a 
call scala -savecompiled %loc% %*
goto :eof
::!#
"""

Group and count/sum/avg/min/max lines based on a given regex.
Grouping is done by the first group of the regex, summing etc by the second group.

Usage:
  groupBy "<regex>"
  groupBy "<regex>" sum
  groupBy "<regex>" avg
  groupBy "<regex>" min
  groupBy "<regex>" max

Examples:
  (echo a1 && echo b2 && echo a3) | groupBy "([a-z])\d"
    'a' 2
    'b' 1

  (echo a1 && echo b2 && echo a3) | groupBy "([a-z])(\d).*" sum
    'a' 4.0
    'b' 2.0

  (echo a1 && echo b2 && echo a3) | groupBy "([a-z])(\d).*" avg
    'a' 2.0
    'b' 2.0

  (echo a1 && echo b2 && echo a3) | groupBy "([a-z])(\d).*" min
    'a' 1.0
    'b' 2.0

  (echo a1 && echo b2 && echo a3) | groupBy "([a-z])(\d).*" max
    'a' 3.0
    'b' 2.0

"""

import scala.io._

val lines = Source.stdin.getLines.toSeq

val GroupByPattern = args(0).r
val method = if (args.length == 1) None else Some(args(1))

lines groupBy { x => (for (m <- GroupByPattern.findFirstMatchIn(x)) yield m.group(1)).mkString } foreach { case (key, values) => println("'" + key + "' " + (method match {
	case Some("sum") => values.map { case GroupByPattern(a,b) => b.toDouble }.sum
  case Some("avg") => values.map { case GroupByPattern(a,b) => b.toDouble }.sum / values.size
  case Some("min") => values.map { case GroupByPattern(a,b) => b.toDouble }.min
  case Some("max") => values.map { case GroupByPattern(a,b) => b.toDouble }.max
	case None => values.size
}))}