class AppRouter extends Backbone.Router

  routes:
    '': 'homePage'
    'panel/:id': 'goToPanel'
      
  homePage: ->
    collection = new app.Collections.ActivityCollection    
    @view = new app.Views.Home collection: collection    
    collection.fetch()
        
    flight.goTo "#panel-1"
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    page = @view.render(id).el
    flight.goTo page
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
