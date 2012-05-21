class App

  Routers: {}
  Models: {}
  Collections: {}
  Views: {}

  url: ''

  trace: (message) ->
    console.log message

  init: ->
    new @Routers.FrontRouter

    Backbone.history.start()

window.app = new App