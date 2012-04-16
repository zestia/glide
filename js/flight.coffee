class Flight

  version: '0.0.1'

root           = this
previousFlight = root.Flight

$ = window?.jQuery or window?.Zepto or (el) -> el

Flight.setDomLibrary = (library) ->
  $ = library

Flight.noConflict = ->
  root.Flight = previousFlight
  this

if exports?
  module?.exports = exports = Flight
else
  root.Flight = Flight
