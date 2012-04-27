class Flight
  version: '0.0.1'
  isTransitioning: false
  # defaults
  transitionAnimation: true
  fadeAnimation: true

  constructor: (options) ->
    # set options
    if options?
      if options["transitionAnimation"]?
        @["transitionAnimation"] = options["transitionAnimation"]

      if options["fadeAnimation"]?
        @["fadeAnimation"] = options["fadeAnimation"]

  goToPage: (startingDiv) ->
    # get starting (current) div. Should this be passed in?
    # get transtion
    # check transition
    # use appropriate transition
    # store reference to go back in reverse

    typeOfTransition = startingDiv.getAttribute("data-transition")

    switch typeOfTransition
      when "slide" then do @slideTransition()
      when "slideUp" then
      when "slideDown" then

  fadeInnerElements: (element, opacity, speed) ->
    firstChild = element.firstChild
    # only work on top level element

    while firstChild.nextSibling
      # ignore text nodes by testing for nodeValue
      if not firstChild.nodeValue
        firstChild.style.opacity = '0';
        firstChild.style.webkitTransition = "#{speed} ease-in"
        firstChild.style.opacity = opacity;
        firstChild = firstChild.nextSibling
      else
        firstChild = firstChild.nextSibling

  slideTransition: (currDiv, targetDiv, speed, back) ->

    # TODO: look into transform origin
    # TODO: make use of data tags

    unless currDiv and targetDiv
      throw new Error "Need to set current div and target div in Slide in flight.slideTranstion"
      return

    unless speed then speed = "0.4s"

    unless back then back = false

    if @isTransitioning is true then return else @isTransitioning = true

    currDiv = document.querySelector currDiv
    targetDiv = document.querySelector targetDiv

    targetDiv.style.display = "block"
    currDiv.style.display = "block"

    if back is true

      # must perform this initial tranform to get animation working in the next step
      targetDiv.style.webkitTransition = "0ms"
      targetDiv.style.webkitTransform = "translateX(0%)"

      # use window timeout to delay transition or will not work on android device
      window.setTimeout ->
        currDiv.style.webkitTransition = "#{speed}"
        currDiv.style.webkitTransform = "translateX(100%)"
        targetDiv.className += " visible"
      , 10

    else
      #do forward transition
      targetDiv.style.webkitTransition = "0ms"
      targetDiv.style.webkitTransform = "translateX(200%)"

      window.setTimeout =>
        currDiv.style.webkitTransition = "#{speed}"
        currDiv.style.webkitTransform = "translateX(-100%)"
      , 10

    # shortern the delay here to stop a gap appearing in android
    window.setTimeout =>

      targetDiv.style.webkitTransition = "#{speed}"
      targetDiv.style.webkitTransform = "translateX(100%)"

      currDiv.addEventListener("webkitTransitionEnd", =>
        currDiv.style.display = "none"
        @isTransitioning = false
      , false);
    , 5



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

window.flight = new Flight();

backBtn = document.querySelector('.back')

#backBtn.addEventListener 'touchstart', ->
#  flight.slideTransition('#panel-1','#panel-2','0.4s',true)
backBtn.addEventListener 'click', ->
    flight.slideTransition('#panel-1','#panel-2','0.4s',true)

$('.forward').click (e) =>
  flight.slideTransition('#panel-1','#panel-2','0.4s',false)


#if 'ontouchstart' in window
#  alert 'ontouchstart'
#
#if "ontouchend" in document
#  alert 'ontouch end in doc'
#
#try document.createEvent("TouchEvent") catch e
#  alert 'not here'
#
#if typeof TouchEvent != "undefined"
#
#  alert 'type of not undefined'
#
#if 'createTouch' in document
#  alert 'create touch in document'
#
#if typeof Touch == "object"
#
#  alert 'type of touch object'