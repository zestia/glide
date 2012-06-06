class AppRouter extends Backbone.Router

  routes:
    '': 'homePage'
    'panel/:id': 'goToPanel'
      
  homePage: ->
    @view = new app.Views.Home   
    page = @view.render().el
    flight.goTo page
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    page = @view.render(id).el
    flight.goTo page
    
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
