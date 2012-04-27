class Flight
  version: '0.0.1'
  isTransitioning: false
  # defaults
  transitionAnimation: true
  fadeAnimation: true
  currentPanel: ''
  targetPanel: ''
  speed: '0.4s'

  constructor: (options) ->
    # set options
    if options?
      if options["transitionAnimation"]?
        @transitionAnimation = options["transitionAnimation"]

      if options["fadeAnimation"]?
        @fadeAnimation = options["fadeAnimation"]

      if options["speed"]?
        @speed = options["speed"]

    @currentPanel = document.getElementsByClassName('visible')[0]

    if @currentPanel is ''
      throw new Error "Current panel not set"

  goToPage: (targetPanel) ->

    @targetPanel = document.querySelector(targetPanel)
    transtionType = @currentPanel.getAttribute("data-transition")

    switch transtionType
      when "slide" then @slideTransition('0.4s',true)
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

  slideTransition: (speed, back) ->

    # TODO: look into transform origin
    # TODO: make use of data tags

    unless @targetPanel
      throw new Error "Need to set current div and target div in Slide in flight.slideTranstion"
      return

    unless speed then speed = "0.4s"

    unless back then back = false

    if @isTransitioning is true then return else @isTransitioning = true

    @targetPanel.style.display = "block"
    @currentPanel.style.display = "block"

    if back is true

      # must perform this initial tranform to get animation working in the next step
      @targetPanel.style.webkitTransition = "0ms"
      @targetPanel.style.webkitTransform = "translateX(0%)"

      # use window timeout to delay transition or will not work on android device
      window.setTimeout =>
        @currentPanel.style.webkitTransition = "#{speed}"
        @currentPanel.style.webkitTransform = "translateX(100%)"
        @targetPanel.className += " visible"
      , 10

    else
      #do forward transition
      @targetPanel.style.webkitTransition = "0ms"
      @targetPanel.style.webkitTransform = "translateX(200%)"

      window.setTimeout =>
        @currentPanel.style.webkitTransition = "#{speed}"
        @currentPanel.style.webkitTransform = "translateX(-100%)"
      , 10

    # shortern the delay here to stop a gap appearing in android
    window.setTimeout =>

      @targetPanel.style.webkitTransition = "#{speed}"
      @targetPanel.style.webkitTransform = "translateX(100%)"

      @currentPanel.addEventListener("webkitTransitionEnd", =>
        @currentPanel.style.display = "none"
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
    flight.goToPage('#panel-2')

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