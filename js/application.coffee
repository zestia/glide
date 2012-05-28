class App

  Routers: {}
  Models: {}
  Collections: {}
  Views: {}

  url: ''

  trace: (message) ->
    console.log message

  init: ->
    window.flight = new Flight();
    flight.launch "#panel-1"
    
    new @Routers.AppRouter
    
    Backbone.history.start()

window.app = new App