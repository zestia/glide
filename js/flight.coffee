class Flight
  version: '0.0.1'
  isTransitioning: false
  currentPanel: ''
  targetPanel: ''

  # options
  transitionAnimation: true
  fadeAnimation: true
  speed: '0.4s'

  constructor: (options) ->

    if options?

      if options.transitionAnimation?
        @transitionAnimation = options.transitionAnimation

      if options.fadeAnimation?
        @fadeAnimation = options.fadeAnimation

      if options.speed?
        @speed = options.speed

    @currentPanel = document.getElementsByClassName('visible')[0]

    if @currentPanel is undefined
      throw new Error "Current panel not set"
    else
      @currentPanel.style.left = "0%"

  goToPage: (targetPanel) ->

    @targetPanel = document.querySelector(targetPanel)
    transtionType = @currentPanel.getAttribute("data-transition")

    if @transitionAnimation is true

      switch transtionType
        when "slide" then @slideTransition()
        when "slideUp" then @slideUp()
        when "slideDown" then @slideDown()

  slideTransition: (speed, back) ->

    unless @targetPanel
      throw new Error "Need to set current div and target div in Slide in flight.slideTranstion"
      return

    if speed
      @speed = speed

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
        @currentPanel.style.webkitTransition = "#{@speed} ease"
        @currentPanel.style.webkitTransform = "translateX(100%)"
        @targetPanel.className += " visible"
      , 10

    else
      #do forward transition
      @targetPanel.style.webkitTransition = "0ms"
      @targetPanel.style.webkitTransform = "translateX(200%)"

      window.setTimeout =>
        @currentPanel.style.webkitTransition = "#{@speed} ease"
        @currentPanel.style.webkitTransform = "translateX(-100%)"
      , 10

    # shortern the delay here to stop a gap appearing in android
    window.setTimeout =>

      @targetPanel.style.webkitTransition = "#{@speed} ease"
      @targetPanel.style.webkitTransform = "translateX(100%)"

      @currentPanel.addEventListener("webkitTransitionEnd", =>
        @finishTransition()
      , false);
    , 5

  finishTransition: ->
    @currentPanel.style.display = "none"
    @removeClass(@currentPanel, 'visible')
    @addClass(@targetPanel, 'visible')

    @isTransitioning = false

  hasClass: (ele, cls) ->
    ele.className.match new RegExp("(\\s|^)" + cls + "(\\s|$)")

  addClass: (ele, cls) ->
    ele.className += " " + cls  unless @hasClass(ele, cls)

  removeClass: (ele, cls) ->
    if @hasClass(ele, cls)
      reg = new RegExp("(\\s|^)" + cls + "(\\s|$)")
      ele.className = ele.className.replace(reg, " ")

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

#backBtn.addEventListener 'touchstart', ->
#  flight.slideTransition('#panel-1','#panel-2','0.4s',true)
$('.back').click (e) =>
    flight.goToPage('#panel-1')

$('.forward').click (e) =>
  flight.goToPage('#panel-2')


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