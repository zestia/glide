class Glide

  hooks:
    'before:to': []
    'after:to': []

  plugins: {}

  isTransitioning: false
  transitionAnimation: true

  # Public: Instantiate Glide and set any options.
  #
  # options - A Hash of options for glide.
  #
  # Returns nothing.
  constructor: (options = {}) ->
    (@[key] = value) for key, value of options

    @detectUserAgent()

    (@plugins[key] = new value this) for key, value of @plugins

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
    @os.android = !!userAgent.match(/(Android)\s+([\d.]+)|Silk-Accelerated/)

    if match = userAgent.match(/((iPad).*OS|(iPhone\sOS))\s([\d_]+)/)
      @os.ios = true
      @os.version = match[4].replace /_/g, '.'
      @os.full = "iOS #{@os.version}"

    if @os.android
      result = userAgent.match(/Android (\d+(?:\.\d+)+)/)
      @os.version = result[1]
      @os.full = "Android #{@os.version}"

  # Public: Go to a specific page.
  #
  # targetPage - A String of the element ID or existing element.
  # animate    - A Boolean of whether to animate the transition.
  #
  # Returns nothing.
  to: (targetPage, animate = true) =>
    oldAnimate = @transitionAnimation
    @transitionAnimation = animate

    hook() for hook in @hooks['before:to']

    if typeof targetPage is 'string'
      @targetPage = document.querySelector targetPage
    else if targetPage
      @targetPage = targetPage

    if @targetPage is @currentPage or @isTransitioning
      return

    unless @currentPage?
      @targetPage.style.display = '-webkit-box'
      @currentPage = @targetPage
      return

    @isTransitioning = true

    page = if @back then @currentPage else @targetPage
    transitionType = page.getAttribute('data-transition') or 'slide'

    targetPage = @targetPage
    currentPage = @currentPage
    @currentPage = @targetPage

    @addClass currentPage, 'previousPage'

    document.body.addEventListener(
      'webkitTransitionEnd',
      @hideTransitionedPage,
      false
    )

    setTimeout =>
      if @transitionAnimation
        @[transitionType](targetPage, currentPage)
      else
        @displayPage targetPage, currentPage
      @transitionAnimation = oldAnimate
    , 10

    hook() for hook in @hooks['after:to']

  # Private: Perform a slide transition.
  #
  # Returns nothing.
  slide: (targetPage, currentPage) ->
    targetPage.style.display = '-webkit-box'
    screenWidth = window.innerWidth + 'px'
    axis = 'X'

    if @back
      @translate currentPage, axis, '0%'
      @translate targetPage, axis, '-' + screenWidth, '0ms'

      setTimeout =>
        @translate currentPage, axis, '100%'
      , 0
    else
      @translate currentPage, axis, '0%'
      @translate targetPage, axis, screenWidth, '0ms'

      setTimeout =>
        @translate currentPage, axis, '-100%'
      , 0

    setTimeout =>
      @translate targetPage, axis, '0%'
      @back = false
    , 0

  # Private: Perform a slide from bottom transition.
  #
  # Returns nothing.
  slideUp: (targetPage, currentPage) ->
    targetPage.style.display = '-webkit-box'
    screenHeight = window.innerHeight + 'px'
    axis = 'Y'

    if @back
      setTimeout =>
        @translate currentPage, axis, screenHeight
      , 0
    else
      targetPage.style.zIndex = '1000'
      @translate targetPage, axis, screenHeight,'0ms'
      setTimeout =>
        @translate targetPage, axis, '0%'
      , 0

    @back = false

  # Private: Translate page on a specified axis.
  #
  # page     - An Element of the page.
  # axis     - A String of the axis.
  # distance - A String of the distance.
  # duration - A String of the duration, defaults to 0.3s.
  #
  # Returns nothing.
  translate: (page, axis, distance, duration = '0.3s') ->
    page.style.webkitTransition = "#{duration} cubic-bezier(.10, .10, .25, .90)"
    page.style.webkitTransform = "translate#{axis}(#{distance})"

  # Private: Show the current page without transition
  #
  # Returns nothing.
  displayPage: (targetPage, currentPage) ->
    @isTransitioning = false
    targetPage.style.display = '-webkit-box'
    currentPage.style.display = 'none'
    @back = false

  # Private: Hide DOM that has just been transitioned
  #
  # page - The page element that has just been moved outside of view
  #
  # Returns nothing
  hideTransitionedPage: (e) =>
    @isTransitioning = false
    previousPage = document.querySelector('.previousPage')
    if previousPage
      setTimeout =>
        @removeClass previousPage, 'previousPage'
        previousPage.style.display = 'none'
      , 0

    document.body.removeEventListener(
      'webkitTransitionEnd',
      @hideTransitionedPage,
      false
    )

  # Private: Check if element has a class
  #
  # el        - DOM element to be checked
  # cssClass  - A string of the class name
  #
  # Returns true if element has the specified class and false if not
  hasClass: (el, cssClass) ->
    if el? and el.className isnt ''
      el.className && new RegExp("(^|\\s)#{cssClass}(\\s|$)").test(el.className)
    else
      false

  # NOTE: drop with android 2.3
  # Using our own addClass and removeClass:
  # Can use ClassList API if we decide not to support Android 2.3
  addClass: (ele, cls) ->
    ele.className += ' ' + cls unless @hasClass(ele, cls)

  removeClass: (ele, cls) ->
    if @hasClass(ele, cls)
      reg = new RegExp('(\\s|^)' + cls + '(\\s|$)')
      if ele.className?
        ele.className = ele.className.replace(reg, ' ')

  # Private: Is the device touch enabled.
  #
  # Returns True if the device is touch enabled, else False.
  isTouch: =>
    if typeof @touch is 'undefined'
      if !!('ontouchstart' of window)
        @touch = true
      else
        @touch = false
    else
      @touch

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

  # Public: Test whether the OS version matches the specified version.
  #
  # Returns: True if the version matches, else False.
  versionMatches: (regex) ->
    !!@os.version.toString().match regex

  # Private: Handle touch events to apply pressed class to anchors
  #
  # Returns nothing.
  handleEvents: (e) =>
    if @isTouch()
      switch e.type
        when 'touchstart'
          @onTouchStart(e)
        when 'touchmove'
          @removePressed()
        when 'touchend'
          @removePressed()
    else
      switch e.type
        when 'mousedown'
          @onTouchStart(e)

  onTouchStart: (e) =>
    if @isTouch()
      if @isAndroid()
        @theTarget = document.elementFromPoint(
          e.changedTouches[0].screenX,
          e.changedTouches[0].screenY
        )
      else
        @theTarget = document.elementFromPoint(
          e.targetTouches[0].clientX,
          e.targetTouches[0].clientY
        )
    else
      @theTarget = document.elementFromPoint e.clientX, e.clientY

    if @theTarget?.nodeName and
        @theTarget.nodeName.toLowerCase() isnt 'a' and
        (@theTarget.nodeType is 3 or @theTarget.nodeType is 1)

      @oldTarget = @theTarget
      @theTarget = $(@theTarget).closest('a')[0]

    if @theTarget is null or typeof @theTarget is 'undefined' then return

    @addClass @theTarget, 'pressed'
    @theTarget.addEventListener 'touchmove', @removePressed, false
    @theTarget.addEventListener 'mouseout', @removePressed, false
    @theTarget.addEventListener 'touchend', @removePressed, false
    @theTarget.addEventListener 'mouseup', @removePressed, false
    @theTarget.addEventListener 'touchcancel', @removePressed, false

  removePressed: (e) =>
    elements = document.getElementsByClassName('pressed')

    for element in elements
      element.classList.remove('pressed')

window.Glide = Glide
