class AppRouter extends Backbone.Router

  routes:
    '': 'Activity'
    'contacts': 'Contacts'
    'test': 'Test'
    'panel/:id': 'goToPanel'
    
      
  Activity: ->
    collection = new app.Collections.ActivityCollection  
    @view = new app.Views.Activity collection : collection
    flight.goto "#activity"
    
  Contacts: ->
    @view = new app.Views.Contacts
    @view.render()
    flight.goto '#contacts'

  Test: ->
    @view = new app.Views.Test
    @view.render()
    flight.goto '#test'  
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
