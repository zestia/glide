class GlideMenu

  constructor: (@glide) ->
    @menu = document.querySelector '#main-menu'
    @glide.hooks['before:to'] or= []
    @glide.hooks['before:to'].push => @close()

    if @glide.isAndroid() and @glide.versionMatches(/2\.3/g)
      @animate = false
    else
      @animate = true

  close: =>
    if @menuOpen is true
      @menu.style.display = 'none'
      @menuOpen = false

  toggle: =>
    # if @animate is false just show/hide no animation

    if @menuOpen
      setTimeout =>
        @glide.translate @menu, 'X', '-110%', '0.3s'
      , 10

      setTimeout =>
        @menu.style.display = 'none'
      , 300

      @menuOpen = false
    else
      @glide.translate @menu, 'X', '-110%', '0ms'

      setTimeout =>
        @glide.translate @menu, 'X', '0%', '0.3s'
      , 50

      @menu.style.display = "block"
      @menuOpen = true

window.GlideMenu = GlideMenu
