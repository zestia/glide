class Flight
  version: '0.0.1'
  isTransitioning: false
  currentPanel: ''
  targetPanel: ''
  pageHistory: [window.location.hash]
  os: {}

  # options
  transitionAnimation: true
  fadeAnimation: true
  speed: '0.4s'
  back: false

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

    @fitHeightToContent()

    @detectUA()

    if @os.android and @os.version <= "2.1"
      @transitionAnimation = false

  goToPage: (targetPanel,options) ->

    if options?
      if options.back
        @back = options.back

    @targetPanel = document.querySelector(targetPanel)
    transtionType = @currentPanel.getAttribute("data-transition")

    @currentPanel = document.getElementsByClassName('visible')[0]

    if @transitionAnimation isnt true
      @speed = "0s"

    switch transtionType
      when "slide" then @slideTransition()
      when "slideUp" then @slideUp()
      when "slideDown" then @slideDown()

  slideTransition: (speed) ->

    unless @targetPanel
      throw new Error "Need to set current div and target div in Slide in flight.slideTranstion"
      return

    if speed
      @speed = speed

    if @isTransitioning is true then return else @isTransitioning = true

    @targetPanel.style.display = "block"
    @currentPanel.style.display = "block"

    if @back is true

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

  fitHeightToContent: ->

    flightViewport = document.getElementById('flight')
    content = document.getElementsByClassName('content')[0]

    if flightViewport? and content?
      flightViewport.style.height = content.offsetHeight + "px"
    else
      throw new Error "#flight or .content not found."

  detectUA: ->
    userAgent = window.navigator.userAgent
    @os.webkit = (if userAgent.match(/WebKit\/([\d.]+)/) then true else false)
    @os.android = (if userAgent.match(/(Android)\s+([\d.]+)/) or userAgent.match(/Silk-Accelerated/) then true else false)
    if @os.android
      result = userAgent.match(/Android (\d+(?:\.\d+)+)/)
      @os.version = result[1]
    @os.ipad = (if userAgent.match(/(iPad).*OS\s([\d_]+)/) then true else false)
    @os.iphone = (if not @os.ipad and userAgent.match(/(iPhone\sOS)\s([\d_]+)/) then true else false)
    @os.webos = (if userAgent.match(/(webOS|hpwOS)[\s\/]([\d.]+)/) then true else false)
    @os.touchpad = (if @os.webos and userAgent.match(/TouchPad/) then true else false)
    @os.ios = @os.ipad or @os.iphone
    @os.blackberry = (if userAgent.match(/BlackBerry/) or userAgent.match(/PlayBook/) then true else false)
    @os.opera = (if userAgent.match(/Opera Mobi/) then true else false)
    @os.fennec = (if userAgent.match(/fennec/i) then true else false)
    @os.desktop = not (@os.ios or @os.android or @os.blackberry or @os.opera or @os.fennec)

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

  $ ->

    window.flight = new Flight();

    $('.back').on 'click', =>
        flight.goToPage('#panel-2',{back:true})

    $('.forward').on 'click', =>
      flight.goToPage('#panel-2');




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