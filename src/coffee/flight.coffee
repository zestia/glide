class Flight

  pageHistory: []
  currentPage: ''
  targetPage: ''
  startPage: ''
  os: ''
  moved: false
  theTarget: null

  isTransitioning: false
  menuOpen: false
  back: false
  timeout: null

  transitionAnimation: true
  speed: 0.3
  mainMenu: '#main-menu'
  menuCloseButton: '#close-menu-btn'
  stylesheetPath: '/'

  # Public: Instantiate Flight and set any options.
  #
  # options - A Hash of options for flight.
  #
  # Returns nothing.
  constructor: (options = {}) ->
    for key, value of options
      @[key] = value

    @detectUserAgent()

    @mainMenu = document.querySelector @mainMenu if typeof @mainMenu is "string"

    if @isAndroid() and @os.version < '4'
      @setupForAndroid()

    @hideUrlBar() if options.hideUrlbar

    if @isTouch()
      document.body.addEventListener 'touchstart', @handleEvents, false
    else
      document.body.addEventListener 'mousedown', @handleEvents, false

    document.addEventListener "webkitTransitionEnd", (e) =>
      @hideTransitionedPage e.target

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

    return if @targetPage is @currentPage

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
      transitionType = @currentPage.getAttribute("data-transition") or 'slide'
      @pageHistory.pop()
    else
      transitionType = @targetPage.getAttribute("data-transition") or 'slide'
      @pageHistory.push window.location.hash

    targetPage = @targetPage
    currentPage = @currentPage
    @currentPage = @targetPage
    @isTransitioning = false

    setTimeout =>
      if @transitionAnimation
        switch transitionType
          when "slide"
            @slide targetPage, currentPage
          when "slideUp"
            @slideUp targetPage, currentPage
      else
        @displayPage targetPage, currentPage
    , 10

  # Private: Perform a slide transition.
  #
  # Returns nothing.
  slide: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"

    screenWidth = window.innerWidth + 'px'

    if @back
      @translate currentPage, "X", "0%"
      @translate targetPage, "X", "-" + screenWidth, "0ms"

      setTimeout =>
        @translate currentPage, "X", "100%"
      , 0
    else
      @translate currentPage, "X", "0%"
      @translate targetPage,"X", screenWidth, "0ms"

      setTimeout =>
        @translate currentPage, "X", "-100%"
      , 0

    setTimeout =>
      @translate targetPage, "X", "0%"
      @back = false
    , 0

  # Private: Perform a slide from bottom transition.
  #
  # Returns nothing.
  slideUp: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    screenHeight = window.innerHeight + 'px'

    if @back
      setTimeout =>
        @translate(currentPage, "Y", screenHeight)
      , 0
    else
      targetPage.style.zIndex = "1000"
      @translate(targetPage, "Y", screenHeight,"0ms")
      setTimeout =>
        @translate(targetPage, "Y", "0%")
      , 0

    @back = false

  # Private: Perform a slide out transition for the menu.
  #
  # Returns nothing.
  slideOutMenu: ->
    if @menuOpen
      setTimeout =>
        @translate @mainMenu, "X", "-110%", "0.3s"
      , 10

      setTimeout =>
        @mainMenu.style.display = "none"
      , 300

      @menuOpen = false
    else
      @translate @mainMenu, "X", "-110%", "0ms"

      setTimeout =>
        @translate @mainMenu, "X", "0%", "0.3s"
      , 50

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
    duration = @speed + "s" unless duration?
    page.style.webkitTransition = "#{duration} cubic-bezier(.10, .10, .25, .90)"
    page.style.webkitTransform = "translate#{axis}(#{distance})"

  # Private: Display the current page.
  #
  # Returns nothing.
  displayPage: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    currentPage.style.display = "none"

    if @isAndroid() and @os.version < '4' and @back is false
      window.scrollTo 0,0

    if @back is true then @back = false

  # Private: Hide DOM that has just been transitioned
  #
  # page    - The page element that has just been moved outside of view
  #
  # Returns nothing
  hideTransitionedPage: (page) =>
    if @hasClass(page,'page')
      page.style.display = "none" unless page.id is @targetPage.id

    if @isAndroid() and @os.version < '4'
      @currentPage.style.webkitTransform = "none"

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

  setupForAndroid: =>
    head = document.getElementsByTagName('head')[0]
    androidCSS = document.createElement "link"
    androidCSS.setAttribute "rel", "stylesheet"
    androidCSS.setAttribute "type", "text/css"
    androidCSS.setAttribute "href", "#{@stylesheetPath}flight.android.css"
    head.appendChild androidCSS

    styleSheets = document.styleSheets
    styleSheet.disabled = true for styleSheet in styleSheets when styleSheet.href?.indexOf("flight.css") isnt -1

    document.body.className = "old-android"
    @transitionAnimation = false

  # Private: Hide the URL bar in mobile browsers.
  #
  # Returns nothing.
  hideUrlBar: ->
    setTimeout ->
        window.scrollTo 0, 1
    , 50

  # Private: Check if element has a class
  #
  # el        - DOM element to be checked
  # cssClass  - A string of the class name
  #
  # Returns true if element has the specified class and false if not
  hasClass: (el, cssClass) ->
    if el.className isnt ''
      el.className && new RegExp("(^|\\s)" + cssClass + "(\\s|$)").test(el.className)
    else
      false

  # Private: Is the device touch enabled.
  #
  # Returns True if the device is touch enabled, else False.
  isTouch: =>
    if @os.android
      !!('ontouchstart' of window)
    else
      window.Touch?

  # Public: Is the device running Android
  #
  # Returns True if the device is running Android, else False.
  isAndroid: =>
    @os.android

  # Public: Is the device running iOS
  #
  # Returns True if the device is running iOS, else False.
  isIOS: =>
    @os.ios

  # Public: Get the version of the OS running on the device.
  #
  # Returns a String of the OS version.
  osVersion: =>
    @os.version.toString()

  handleEvents: (e) =>
    if @isTouch()
      switch e.type
        when 'touchstart'
          @onTouchStart e
        when 'touchmove'
          @onTouchMove e
        when 'touchend'
          @onTouchEnd e
    else
      switch e.type
        when 'mousedown'
          @onTouchStart e

  onTouchStart: (e) =>
    @moved = false

    if @isTouch()
      if @os.android
        @theTarget = document.elementFromPoint(e.changedTouches[0].screenX, e.changedTouches[0].screenY)
      else
        @theTarget = document.elementFromPoint(e.targetTouches[0].clientX, e.targetTouches[0].clientY)
    else
      @theTarget = document.elementFromPoint e.clientX, e.clientY

    if @theTarget.nodeName and @theTarget.nodeName.toLowerCase() isnt 'a' and (@theTarget.nodeType is 3 or @theTarget.nodeType is 1)
      @oldTarget = @theTarget
      @parents = $(@theTarget).parentsUntil('ul li')
      @theTarget = @parents[@parents.length-1] or @oldTarget

    @theTarget.className+= ' pressed'
    @theTarget.addEventListener 'touchmove', @onTouchMove, false
    @theTarget.addEventListener 'mouseout', @onTouchEnd, false
    @theTarget.addEventListener 'touchend', @onTouchEnd, false
    @theTarget.addEventListener 'mouseup', @onTouchEnd, false
    @theTarget.addEventListener 'touchcancel', @onTouchcancel, false

  onTouchMove: (e) =>
    @moved = true
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  onTouchEnd: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  onTouchCancel: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

window.Flight = Flight
