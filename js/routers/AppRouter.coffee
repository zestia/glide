class AppRouter extends Backbone.Router

  routes:
    '': 'homePage'
    'panel/:id': 'goToPanel'
      
  homePage: ->
    collection = new app.Collections.ActivityCollection  
    @view = new app.Views.Home collection : collection
    flight.goTo "#panel-1"
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    @view.render().el
    flight.goTo "#panel-" + id
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
