class AppRouter extends Backbone.Router

  routes:
    '': 'activities'
    'entry': 'entry'
    'contacts': 'contacts'
    'contact/add': 'addContact'

  activities: ->
    view = new app.Views.Activities collection: app.Collections.Activities
    view.render()
    flight.goto '#activity'

  entry: ->
    flight.goto '#entry'

  addContact: ->
    flight.goto '#add-contact-form'

  contacts: ->
    view = new app.Views.Contacts collection: app.Collections.Contacts
    view.render()
    flight.goto '#contacts'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter