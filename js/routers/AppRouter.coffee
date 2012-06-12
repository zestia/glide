class AppRouter extends Backbone.Router

  routes:
    '': 'Activity'
    'panel/:id': 'goToPanel'
      
  Activity: ->
    collection = new app.Collections.ActivityCollection  
    @view = new app.Views.Activity collection : collection
    flight.goTo "#panel-1"
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    @view.render().el
    flight.goTo "#panel-" + id
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
