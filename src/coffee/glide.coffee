class Glide

  stylesheetPath: '/'

  hooks:
    'before:to': []
    'after:to': []

  isTransitioning: false
  transitionAnimation: true
  speed: 0.3

  # Public: Instantiate Glide and set any options.
  #
  # options - A Hash of options for glide.
  #
  # Returns nothing.
  constructor: (options = {}) ->
    @[key] = value for key, value of options

    for key, value of @plugins
      @plugins[key] = new value this

    @detectUserAgent()
    @setupForAndroid() if @isAndroid() and @os.version < '4'

    if @isTouch()
      document.body.addEventListener 'touchstart', @handleEvents, false
    else
      document.body.addEventListener 'mousedown', @handleEvents, false

  # Private: Get a Hash of browser user agent information.
  #
  # Returns a Hash of user agent information.
  detectUserAgent: ->
    userAgent = window.navigator.userAgent
    @os = {}
    @os.android = !!userAgent.match(/(Android)\s+([\d.]+)/) or !!userAgent.match(/Silk-Accelerated/)
    @os.ios = !!userAgent.match(/(iPad).*OS\s([\d_]+)/) or !!userAgent.match(/(iPhone\sOS)\s([\d_]+)/)
    if @os.android
      result = userAgent.match(/Android (\d+(?:\.\d+)+)/)
      @os.version = result[1]

  # Public: Go to a specific page.
  #
  # targetPage - A String of the element ID or existing element.
  #
  # Returns nothing.
  to: (targetPage) =>
    hook() for hook in @hooks['before:to']

    if typeof targetPage is "string"
      @targetPage = document.querySelector targetPage
    else if targetPage
      @targetPage = targetPage

    return if @targetPage is @currentPage or @isTransitioning

    unless @currentPage?
      @targetPage.style.display = "-webkit-box"
      @pageHistory = [window.location.hash]
      @currentPage = @targetPage
      return

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

    currentPage.addEventListener "webkitTransitionEnd", @hideTransitionedPage, false

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

    hook() for hook in @hooks['after:to']

  # Private: Disables transitions and default stylesheet and replaces with android specific css
  #
  # Returns nothing.
  setupForAndroid: ->
    head = document.getElementsByTagName('head')[0]
    androidCSS = document.createElement 'link'
    androidCSS.setAttribute 'rel', 'stylesheet'
    androidCSS.setAttribute 'type', 'text/css'
    androidCSS.setAttribute 'href', "#{@stylesheetPath}glide.android.css"
    head.appendChild androidCSS

    styleSheets = document.styleSheets
    for styleSheet in styleSheets when styleSheet.href?.indexOf("glide.css") isnt -1
      styleSheet.disabled = true

    document.body.className = "old-android"
    @transitionAnimation = false

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
        @translate currentPage, "Y", screenHeight
      , 0
    else
      targetPage.style.zIndex = "1000"
      @translate targetPage, "Y", screenHeight,"0ms"
      setTimeout =>
        @translate targetPage, "Y", "0%"
      , 0

    @back = false

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

  # Private: Show the current page without transition
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
  hideTransitionedPage: (e) =>
    page = e.target
    if @hasClass(page,'page')
      page.style.display = "none" unless page.id is @targetPage.id

    if @isAndroid() and @os.version < '4'
      @currentPage.style.webkitTransform = "none"

    page.removeEventListener "webkitTransitionEnd", @hideTransitionedPage, false

  # Private: Check if element has a class
  #
  # el        - DOM element to be checked
  # cssClass  - A string of the class name
  #
  # Returns true if element has the specified class and false if not
  hasClass: (el, cssClass) ->
    if el.className isnt ''
      el.className && new RegExp("(^|\\s)#{cssClass}(\\s|$)").test(el.className)
    else
      false

  # Private: Is the device touch enabled.
  #
  # Returns True if the device is touch enabled, else False.
  isTouch: ->
    if @isAndroid()
      !!('ontouchstart' of window)
    else
      window.Touch?

  # Public: Is the device running iOS
  #
  # Returns True if the device is running iOS, else False.
  isIOS: ->
    @os.ios

  # Public: Is the device running Android
  #
  # Returns True if the device is running Android, else False.
  isAndroid: ->
    @os.android

  # Public: Get the version of the OS running on the device.
  #
  # Returns a String of the OS version.
  osVersion: ->
    @os.version.toString()

  # Private: Handle touch events to apply pressed class to anchors
  #
  # Returns nothing.
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
    if @isTouch()
      if @isAndroid()
        @theTarget = document.elementFromPoint(e.changedTouches[0].screenX, e.changedTouches[0].screenY)
      else
        @theTarget = document.elementFromPoint(e.targetTouches[0].clientX, e.targetTouches[0].clientY)
    else
      @theTarget = document.elementFromPoint e.clientX, e.clientY

    if @theTarget?.nodeName and @theTarget.nodeName.toLowerCase() isnt 'a' and (@theTarget.nodeType is 3 or @theTarget.nodeType is 1)
      @oldTarget = @theTarget
      @parents = $(@theTarget).parentsUntil('ul li')
      @theTarget = @parents[@parents.length-1] or @oldTarget

    if @theTarget is null then return

    @theTarget.className += ' pressed'
    @theTarget.addEventListener 'touchmove', @onTouchMove, false
    @theTarget.addEventListener 'mouseout', @onTouchEnd, false
    @theTarget.addEventListener 'touchend', @onTouchEnd, false
    @theTarget.addEventListener 'mouseup', @onTouchEnd, false
    @theTarget.addEventListener 'touchcancel', @onTouchcancel, false

  onTouchMove: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  onTouchEnd: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  onTouchCancel: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

window.Glide = Glide
