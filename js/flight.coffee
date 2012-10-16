class Flight

  pageHistory: []
  currentPage: ''
  targetPage: ''
  startPage: ''
  os: ''

  isTransitioning: false
  menuOpen: false
  back: false

  transitionAnimation: true
  speed: '0.4s'
  mainMenu: '#main-menu'
  menuCloseButton: '#close-menu-btn'

  # Public: Instantiate Flight and set any options.
  #
  # options - A Hash of options for flight.
  #
  # Returns nothing.
  constructor: (options = {}) ->
    if options.transitionAnimation?
      @transitionAnimation = options.transitionAnimation

    @speed = options.speed if options.speed?

    @mainMenu = options.mainMenu if options.mainMenu?
    @mainMenu = document.querySelector @mainMenu if typeof @mainMenu is "string"

    @detectUserAgent()
    @transitionAnimation = false if @os.android and @os.version <= '2.1'

    @hideUrlBar() if options.hideUrlbar

    @noClickDelay(document.body)

  # Public: Go to a specific page.
  #
  # targetPage - A String of the element ID or existing element.
  #
  # Returns nothing.
  goto: (targetPage) =>
    if @menuOpen is true 
      @closeMenu()

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

    if @pageHistory.length is 1 and window.location.hash is @startPage
      @back = true
      @pageHistory.pop()

    if @pageHistory.length > 1 and window.location.hash is @pageHistory[@pageHistory.length - 2]
      @back = true
      
    if @back and @pageHistory.length != 1
      transitionType = @currentPage.getAttribute("data-transition")
      @pageHistory.pop()
    else
      transitionType = @targetPage.getAttribute("data-transition")
      @pageHistory.push(window.location.hash)
    
    targetPage = @targetPage
    currentPage = @currentPage
    @currentPage = @targetPage
    @isTransitioning = false

    window.setTimeout =>
      if @transitionAnimation
        switch transitionType
          when "slide" then @slide(targetPage, currentPage)
          when "slideUp" then @slideUp(targetPage, currentPage)
      else
        @displayPage(targetPage, currentPage)
        
    , 10

  # Private: Perform a slide transition.
  #
  # Returns nothing.
  slide: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    screenWidth = window.innerWidth + 'px'

    if @back
      @translate(targetPage, "X", "-" + screenWidth, "0ms")
      window.setTimeout =>
        @translate(currentPage, "X", "100%")
      , 0
    else
      @translate(targetPage,"X", screenWidth, "0ms")
      window.setTimeout =>
        @translate(currentPage, "X", "-100%")
      , 0

    window.setTimeout =>
      @translate(targetPage, "X", "0%" )
      targetPage.querySelector('header').style.opacity = "1"
      @back = false
    , 0

  # Private: Perform a slide from bottom transition.
  #
  # Returns nothing.
  slideUp: (targetPage, currentPage) ->
    @targetPage.style.display = "-webkit-box"

    if @back
      window.setTimeout =>
        @translate(currentPage, "Y", "100%")
      , 10
    else
      targetPage.style.display = "-webkit-box"
      @translate(targetPage, "Y", "100%","0ms")
      window.setTimeout =>
        @translate(targetPage, "Y", "0%")
      , 10

    @back = false

  # Private: Perform a slide out transition for the menu.
  #
  # Returns nothing.
  slideOutMenu: ->
    if @menuOpen
      window.setTimeout =>
        @translate(@mainMenu, "X", "-110%", "0.3s")
      ,10
      window.setTimeout =>
        @mainMenu.style.display = "none"  
      ,300
      @menuOpen = false
    else
      @translate(@mainMenu, "X", "-110%", "0ms")
      window.setTimeout =>
        @translate(@mainMenu, "X", "0%", "0.3s")
      ,10
      @mainMenu.style.display = "block"
      @menuOpen = true

  # Private: Close menu without transition
  #
  # Returns nothing.
  closeMenu: ->
    @mainMenu.style.display = "none"  
    @menuOpen = false

  # Private: Translate page on a specified axis.
  #
  # page     - An Element of the page.
  # axis     - A String of the axis.
  # distance - A String of the distance.
  # duration - A String of the duration, defaults to speed.
  #
  # Returns nothing.
  translate: (page, axis, distance, duration) ->
    duration = @speed unless duration?
    page.style.webkitTransition = "#{duration} cubic-bezier(.10, .10, .25, .90)"
    page.style.webkitTransform = "translate#{axis}(#{distance})"

  # Private: Display the current page.
  #
  # Returns nothing.
  displayPage: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    currentPage.style.display = "-webkit-box"
    targetPage.style.left = "0%"
    currentPage.style.left = "100%"

  # Private: Get a Hash of browser user agent information.
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
    @os = os

  # Private: Hide the URL bar in mobile browsers.
  # 
  # Returns nothing.
  hideUrlBar: ->
    setTimeout ->
        window.scrollTo 0, 1
    , 50

  noClickDelay: (el) ->
    if typeof (el) is "string"
      el = document.getElementById(el)
    el.addEventListener('touchstart', @handleEvents, false)

window.Flight = Flight
