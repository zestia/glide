class AppRouter extends Backbone.Router

  routes:
    '': 'Activity'
    'contacts': 'Contacts'
    'panel/:id': 'goToPanel'
    
      
  Activity: ->
    collection = new app.Collections.ActivityCollection  
    @view = new app.Views.Activity collection : collection
    flight.goTo "#activity"
    $('#main-menu').click ->
      alert('clicked')
    
  goToPanel: (id) ->
    @view = new app.Views["Panel_" + id]
    @view.render()
    flight.goTo "#panel-" + id
  
  Contacts: ->
    @view = new app.Views.Contacts
    @view.render()
    flight.goTo '#contacts' 
    
            
@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
