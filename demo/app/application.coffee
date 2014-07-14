class App

  Routers: {}

  Models: {}

  Collections: {}

  Views: {}

  init: ->
    window.glide = new Glide
      stylesheetPath: '../lib/'
      plugins:
        menu: GlideMenu

    new @Routers.AppRouter

    @Collections.Contacts.fetch()

    Backbone.history.start()

  goBack: ->
    window.history.back()

window.app = new App