class FrontRouter extends Backbone.Router

  routes:
    '': 'startApp'
    'panel/:id': 'goToPanel'
    
  startApp: ->
    window.flight = new Flight();
    
  goToPanel: (id) ->
    @view = new app.Views.panel2View     
    @view.render(id)   

@app = window.app ? {}
@app.Routers.FrontRouter = FrontRouter
