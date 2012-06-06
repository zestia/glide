class Flight
  version: '0.0.1'
  isTransitioning: false
  startPage: ''
  currentPage: ''
  targetPage: ''
  pageHistory: [""]
  os: {}
  hideUrlBar: false
  useScroller: false
  iScrollInstance: null
  # options
  transitionAnimation: true
  speed: '0.4s'
  back: false

  constructor: (options) ->
    if options?
      if options.transitionAnimation?
        @transitionAnimation = options.transitionAnimation
      if options.speed?
        @speed = options.speed
      if options.useScroller?
        @useScroller = options.useScroller             
        
    # see what device we're using
    @detectUserAgent()
    
    # don't bother using transition animation on older android devices as they look terrible
    if @os.android and @os.version <= "2.1" then @transitionAnimation = false

    if @hideUrlBar is true then @hideUrlBar()
         
  # Goes to page, transitionAnimation defines if transition happens or not
  goTo: (targetPage, options) =>
    
    if typeof targetPage is "string"
      @targetPage = document.querySelector targetPage
    else if targetPage
      @targetPage = targetPage
    
    if not @currentPage
      # No current panel set, app just started, make start panel visible
      targetPage.style.display = "block"
      @pageHistory = [window.location.hash];
      @startPage = [window.location.hash];
      @currentPage = targetPage
      @addClass @currentPage, 'visible'

      if @useScroller is true
        @setScroller @currentPage
             
      return
        
    # if already transitioning then return    
    if @isTransitioning is true then return else @isTransitioning = true
    
    # set curent panel
    @currentPage = document.getElementsByClassName('visible')[0]
    if @currentPage is undefined then throw new Error "Current panel not set"    
    
    if @targetPage is @startPage
      @back = true
    if @pageHistory.length > 1 and window.location.hash is @pageHistory[@pageHistory.length - 2]
      @back = true
      
    if @back is true and @pageHistory.length != 1
      transitionType = @currentPage.getAttribute("data-transition")
      @pageHistory.pop() 
    else
      transitionType = @targetPage.getAttribute("data-transition")
      @pageHistory.push(window.location.hash)   
                     
    window.scrollTo 0, 1
    
    # Delay transition to prevent flickering
    window.setTimeout =>
      if @transitionAnimation is true
        switch transitionType
          when "slide" then @slideTransition()
          when "slideFromBottom" then @slideFromBottom()
          when "slideDown" then @slideDown()

      if @transitionAnimation isnt true
        @displayPage()
    ,10
                  
  # performs slide animation transition
  slideTransition: () ->
    @targetPage.style.display = "block"
    @currentPage.style.display = "block"

    if @back is true
      # must perform this initial tranform to get animation working in the next step
      @targetPage.style.webkitTransition = "0ms"
      @targetPage.style.webkitTransform = "translateX(-100%)"

      # use window timeout to delay transition or will not work on android device
      window.setTimeout =>
        @currentPage.style.webkitTransition = "#{@speed} ease"
        @currentPage.style.webkitTransform = "translateX(100%)"
      , 10

    else
      #do forward transition
      @targetPage.style.webkitTransition = "0ms"
      @targetPage.style.webkitTransform = "translateX(100%)"

      window.setTimeout =>
        @currentPage.style.webkitTransition = "#{@speed} ease"
        @currentPage.style.webkitTransform = "translateX(-100%)"
      , 10

    # shortern the delay here to stop a gap appearing in android
    window.setTimeout =>
      @targetPage.style.webkitTransition = "#{@speed} ease"
      @targetPage.style.webkitTransform = "translateX(0%)"
      @currentPage.addEventListener "webkitTransitionEnd", @finishSlide, false
      @resetState()
    , 5
      
  # slides panel from bottom to top and top to bottom 
  slideFromBottom: () ->
     if @back is true
       # do reverse
       window.setTimeout =>
          @currentPage.style.webkitTransition = "#{@speed} ease"
          @currentPage.style.webkitTransform = "translateY(100%)"
       , 10
       
     else
       #do forward transition
       @targetPage.style.display = "block"
       @targetPage.style.webkitTransition = "0ms"
       @targetPage.style.webkitTransform = "translateY(100%)"
                      
       window.setTimeout =>
          @targetPage.style.webkitTransition = "#{@speed} ease"
          @targetPage.style.webkitTransform = "translateY(0%)"
       , 10
       
     window.setTimeout =>
       @targetPage.addEventListener "webkitTransitionEnd", @finishSlideFromBottom, false
       @resetState()
     , 15
     
  # call on transition end
  finishSlide: =>
    @removeClass @currentPage, 'visible'
    @currentPage.style.display = "none"
    @addClass @targetPage, 'visible'
    @currentPage.removeEventListener "webkitTransitionEnd", @finishTransition, false
    
    if @useScroller is true
      @setScroller(@targetPage)
   
   finishSlideFromBottom: =>
    @removeClass @currentPage, 'visible'
    @addClass @targetPage, 'visible'
    @targetPage.removeEventListener "webkitTransitionEnd", @finishTransition, false
    
   resetState: =>
    @back = false
    @isTransitioning = false   
    
   # displays pages when transiton is false, back animations do not matter here.
   displayPage: =>
    @targetPage.style.display = "block"
    @currentPage.style.display = "block"
    @targetPage.style.left = "0%"
    @currentPage.style.left = "100%"

    @removeClass(@currentPage, 'visible')
    @addClass(@targetPage, 'visible')
    @isTransitioning = false
      
  # fits viewport to content height
  fitHeightToContent: ->
    flightViewport = document.getElementById 'flight'
    content = document.getElementsByClassName('visible')[0].getElementsByClassName('content')[0]
    if flightViewport? and content?
      flightViewport.style.height = content.offsetHeight + "px"
    else
      throw new Error "#flight or .content not found."
  
  setScroller: (wrapper) =>
    
      if @iScrollInstance? then @iScrollInstance.destroy(); @iScrollInstance = null
    
      window.setTimeout =>
        @iScrollInstance = new iScroll(wrapper.getElementsByClassName('wrapper')[0].id)        
      , 0
  # detects user agent being used
  detectUserAgent: ->
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

  hideUrlBar: ->
    setTimeout (->
        window.scrollTo 0, 1
      ), 50

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
    
