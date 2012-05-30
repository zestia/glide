class AppRouter extends Backbone.Router

  routes:
    '': 'homePage'
    'panel/:id': 'goToPanel'
      
  homePage: ->
    @view = new app.Views.Home   
    targetPanel = @view.render().el
    flight.goTo targetPanel
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    targetPanel = @view.render(id).el
    flight.goTo targetPanel
    
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
