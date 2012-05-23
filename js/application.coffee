class App

  Routers: {}
  Models: {}
  Collections: {}
  Views: {}

  url: ''

  trace: (message) ->
    console.log message

  init: ->
    new @Routers.AppRouter
    
    window.flight = new Flight();
    Backbone.history.start()

window.app = new App