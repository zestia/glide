class AppRouter extends Backbone.Router

  routes:
    '': 'homePage'
    'panel/:id': 'goToPanel'
    
  initialize: ->
    flight.launch("#panel-1")
    
  homePage: ->
    @view = new app.Views.Home   
    @view.render()
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    @view.render(id)    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
