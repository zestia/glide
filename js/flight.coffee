class Flight
  # Private
  version: '0.0.1'
  isTransitioning: false
  currentPage: ''
  targetPage: ''
  pageHistory: [""]
  os: {}
  hideUrlBar: false
  noClickDelay: true
  # options
  mainMenu: '#slide-out-menu'
  menuOpen: false
  transitionAnimation: true
  speed: '0.4s'
  back: false

  # Public:
  #
  # Returns nothing.
  constructor: (options = {}) ->
    if options.transitionAnimation?
      @transitionAnimation = options.transitionAnimation

    if options.speed?
      @speed = options.speed

    @mainMenu = options.mainMenu if options.mainMenu?
    @mainMenu = document.querySelector @mainMenu if typeof @mainMenu is "string"

    os = @detectUserAgent()
    @transitionAnimation = false if os.android and os.version <= '2.1'

    if @hideUrlBar is true then @hideUrlBar()

  # Public: Go to a specific page.
  #
  # targetPage - A String of the element ID or existing element.
  #
  # Returns nothing.
  goto: (targetPage) =>
    if typeof targetPage is "string"
      @targetPage = document.querySelector targetPage
    else if targetPage
      @targetPage = targetPage
    
    unless @currentPage
      @targetPage.style.display = "-webkit-box"
      @pageHistory = [window.location.hash]
      @currentPage = @targetPage
      return

    return if @isTransitioning

    @isTransitioning = true
    @menuOpen = false
    
    if @pageHistory.length > 1 and window.location.hash is @pageHistory[@pageHistory.length - 2]
      @back = true
      
    if @back and @pageHistory.length != 1
      transitionType = @currentPage.getAttribute("data-transition")
      @pageHistory.pop()
    else
      transitionType = @targetPage.getAttribute("data-transition")
      @pageHistory.push(window.location.hash)
    
    window.setTimeout =>
      if @transitionAnimation
        switch transitionType
          when "slide" then @slideTransition()
          when "slideFromBottom" then @slideFromBottom()
          when "slideDown" then @slideDown()
      else
        @displayPage()
        
    , 10

  # performs slide animation transition
  slideTransition: () ->
    @targetPage.style.display = "-webkit-box"

    if @back is true
      # must perform this initial tranform to get animation working in the next step
      @translate(@targetPage, "X", "-100%", "0ms")
      window.setTimeout =>
        @translate(@currentPage, "X", "100%")
      , 10

    else
      #do forward transition      
      @translate(@targetPage,"X","100%", "0ms")
      
      window.setTimeout =>
        @translate(@currentPage, "X", "-100%")
      , 10
    
    # shortern the delay here to stop a gap appearing in android
    window.setTimeout =>
      @translate(@targetPage, "X", "0%")
      @currentPage.addEventListener "webkitTransitionEnd", @finishTransition, false
      @resetState()
    , 5

  # slides panel from bottom to top and top to bottom 
  slideFromBottom: () ->
     @targetPage.style.display = "-webkit-box"
    
     if @back is true
       # do reverse
       window.setTimeout =>
          @translate(@currentPage, "Y", "100%")
       , 10
       
     else
       #do forward transition
       @targetPage.style.display = "-webkit-box"
       @translate(@targetPage, "Y", "100%","0ms")
                      
       window.setTimeout =>
         @translate(@targetPage, "Y", "0%")
       , 10
       
     window.setTimeout =>
       @targetPage.addEventListener "webkitTransitionEnd", @finishTransition, false
     , 20
     @resetState()
  
  slideOutMenu: () =>
    if @menuOpen is false
      @mainMenu.style.display = "block"
      @translate(@currentPage,"X", "250px","0.3s")

      @menuOpen = true
    else
      @translate(@currentPage,"X", "0%","0.3s")
      @menuOpen = false
      
  # call on transition end
  finishTransition: =>
    @currentPage.style.display = "none"
    @currentPage.removeEventListener "webkitTransitionEnd", @finishTransition, false
    # swap pages
    @currentPage = @targetPage
    
   resetState: =>
    @back = false
    @isTransitioning = false

   # translate page on secified axis. Duration defaults to speed property when not passed. Delay defaults to 0.
   translate: (page, axis, distance, duration) =>
    if not duration? then duration = @speed
    page.style.webkitTransition = "#{duration} ease"
    page.style.webkitTransform = "translate#{axis}(#{distance})"
    
   # displays pages when transiton is false, back animations do not matter here.
   displayPage: =>
    @targetPage.style.display = "-webkit-box"
    @currentPage.style.display = "-webkit-box"
    @targetPage.style.left = "0%"
    @currentPage.style.left = "100%"
    @isTransitioning = false

  # Public: Get a Hash of browser user agent information.
  #
  # Returns a Hash of user agent information.
  detectUserAgent: ->
    userAgent = window.navigator.userAgent
    os = {}
    os.webkit = (if userAgent.match(/WebKit\/([\d.]+)/) then true else false)
    os.android = (if userAgent.match(/(Android)\s+([\d.]+)/) or userAgent.match(/Silk-Accelerated/) then true else false)
    if os.android
      result = userAgent.match(/Android (\d+(?:\.\d+)+)/)
      os.version = result[1]
    os.ipad = (if userAgent.match(/(iPad).*OS\s([\d_]+)/) then true else false)
    os.iphone = (if not os.ipad and userAgent.match(/(iPhone\sOS)\s([\d_]+)/) then true else false)
    os.webos = (if userAgent.match(/(webOS|hpwOS)[\s\/]([\d.]+)/) then true else false)
    os.touchpad = (if os.webos and userAgent.match(/TouchPad/) then true else false)
    os.ios = os.ipad or os.iphone
    os.blackberry = (if userAgent.match(/BlackBerry/) or userAgent.match(/PlayBook/) then true else false)
    os.opera = (if userAgent.match(/Opera Mobi/) then true else false)
    os.fennec = (if userAgent.match(/fennec/i) then true else false)
    os.desktop = not (os.ios or os.android or os.blackberry or os.opera or os.fennec)
    os

  hideUrlBar: ->
    setTimeout ->
        window.scrollTo 0, 1
    , 50

window.Flight = Flight
