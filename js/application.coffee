class App

  Routers: {}
  Models: {}
  Collections: {}
  Views: {}

  url: ''

  trace: (message) ->
    console.log message

  init: ->
    # window.flight = new Flight();
    
    new @Routers.AppRouter
    
    Backbone.history.start()

window.app = new App