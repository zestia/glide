class AppRouter extends Backbone.Router

  routes:
    '': 'Activity'
    'contacts': 'Contacts'
    'test': 'Test'
    'panel/:id': 'goToPanel'
    
      
  Activity: ->
    collection = new app.Collections.ActivityCollection  
    @view = new app.Views.Activity collection : collection
    flight.goTo "#activity"
    
  Contacts: ->
    @view = new app.Views.Contacts
    @view.render()
    flight.goTo '#contacts'

  Test: ->
    @view = new app.Views.Test
    @view.render()
    flight.goTo '#test'  
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
