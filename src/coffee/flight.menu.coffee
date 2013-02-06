class GlideMenu

  constructor: (@glide) ->
    @menu = document.querySelector '.menu'
    @glide.hooks['before:goto'] or= []
    @glide.hooks['before:goto'].push => @close()

  close: =>
    @menu.style.display = 'none'
    @menuOpen = false

  toggle: =>
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
