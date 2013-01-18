class AppRouter extends Backbone.Router

  routes:
    '': 'activities'
    'entry': 'entry'
    'contact/add': 'addContact'

  activities: ->
    view = new app.Views.Activities collection: app.Collections.Activities
    view.render()
    flight.goto '#activity'

  entry: ->
    flight.goto '#entry'

  addContact: ->
    flight.goto '#add-contact-form'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
