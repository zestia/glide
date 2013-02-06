class Glide

  stylesheetPath: '/'

  hooks:
    'before:goto': []
    'after:goto': []

  isTransitioning: false
  transitionAnimation: true
  speed: 0.3

  #
  #
  #
  constructor: (options = {}) ->
    @[key] = value for key, value of options

    for key, value of @plugins
      @plugins[key] = new value this

    @detectUserAgent()
    @setupForAndroid() if @isAndroid() and @os.version < '4'

    @hideUrlBar() if options.hideUrlbar

    if @isTouch()
      document.body.addEventListener 'touchstart', @handleEvents, false
    else
      document.body.addEventListener 'mousedown', @handleEvents, false

    document.addEventListener "webkitTransitionEnd", (e) =>
      @hideTransitionedPage e.target

  #
  #
  #
  detectUserAgent: ->
    userAgent = window.navigator.userAgent
    @os = {}
    @os.android = !!userAgent.match(/(Android)\s+([\d.]+)/) or !!userAgent.match(/Silk-Accelerated/)
    @os.ios = !!userAgent.match(/(iPad).*OS\s([\d_]+)/) or !!userAgent.match(/(iPhone\sOS)\s([\d_]+)/)
    if @os.android
      result = userAgent.match(/Android (\d+(?:\.\d+)+)/)
      @os.version = result[1]

  #
  #
  #
  setupForAndroid: ->
    head = document.getElementsByTagName('head')[0]
    androidCSS = document.createElement 'link'
    androidCSS.setAttribute 'rel', 'stylesheet'
    androidCSS.setAttribute 'type', 'text/css'
    androidCSS.setAttribute 'href', "#{@stylesheetPath}flight.android.css"
    head.appendChild androidCSS

    styleSheets = document.styleSheets
    for styleSheet in styleSheets when styleSheet.href?.indexOf("flight.css") isnt -1
      styleSheet.disabled = true

    document.body.className = "old-android"
    @transitionAnimation = false

  #
  #
  #
  hideUrlBar: ->
    setTimeout ->
      window.scrollTo 0, 1
    , 50

  #
  #
  #
  goto: (targetPage) =>
    hook() for hook in @hooks['before:goto']

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

    if @back? and @pageHistory.length != 1
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

    hook() for hook in @hooks['after:goto']

  #
  #
  #
  slide: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"

    screenWidth = window.innerWidth + 'px'

    if @back?
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

  #
  #
  #
  slideUp: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    screenHeight = window.innerHeight + 'px'

    if @back?
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

  #
  #
  #
  translate: (page, axis, distance, duration) ->
    duration = @speed + "s" unless duration?
    page.style.webkitTransition = "#{duration} cubic-bezier(.10, .10, .25, .90)"
    page.style.webkitTransform = "translate#{axis}(#{distance})"

  #
  #
  #
  displayPage: (targetPage, currentPage) ->
    targetPage.style.display = "-webkit-box"
    currentPage.style.display = "none"

    if @isAndroid() and @os.version < '4' and @back is false
      window.scrollTo 0,0

    if @back is true then @back = false

  #
  #
  #
  hideTransitionedPage: (page) =>
    if @hasClass(page,'page')
      page.style.display = "none" unless page.id is @targetPage.id

    if @isAndroid() and @os.version < '4'
      @currentPage.style.webkitTransform = "none"

  #
  #
  #
  hasClass: (el, cssClass) ->
    if el.className isnt ''
      el.className && new RegExp("(^|\\s)#{cssClass}(\\s|$)").test(el.className)
    else
      false

  #
  #
  #
  isTouch: ->
    if @isAndroid()
      !!('ontouchstart' of window)
    else
      window.Touch?

  #
  #
  #
  isIOS: ->
    @os.ios

  #
  #
  #
  isAndroid: ->
    @os.android

  #
  #
  #
  osVersion: ->
    @os.version.toString()

  #
  #
  #
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

  #
  #
  #
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

  #
  #
  #
  onTouchMove: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  #
  #
  #
  onTouchEnd: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

  #
  #
  #
  onTouchCancel: (e) =>
    @theTarget.className = @theTarget.className.replace(/( )? pressed/gi, '')

window.Glide = Glide
