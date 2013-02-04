class AppRouter extends Backbone.Router

  routes:
    '': 'index'
    'animations': 'animations'
    'contacts': 'contacts'
    'contact/add': 'addContact'

  index: ->
    flight.goto '#index'

  animations: ->
    flight.goto '#animations'

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