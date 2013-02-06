class AppRouter extends Backbone.Router

  routes:
    '': 'index'
    'getting-started': 'gettingStarted'
    'animations': 'animations'
    'slide': 'slide'
    'slideUp': 'slideUp'
    'contacts': 'contacts'
    'contacts/:id': 'showContact'
    'contact/add': 'addContact'

  index: ->
    flight.goto '#index'

  gettingStarted: ->
    flight.goto '#getting-started'

  animations: ->
    flight.goto '#animations'

  slide: ->
    flight.goto '#slide'

  slideUp: ->
    flight.goto '#slideUp'

  addContact: ->
    flight.goto '#add-contact-form'

  contacts: ->
    view = new app.Views.Contacts collection: app.Collections.Contacts
    view.render()
    flight.goto '#contacts'

  showContact: (id) ->
    model = app.Collections.Contacts?.get(id)
    view = new app.Views.ContactsShow model: model
    view.render()
    flight.goto '#contact-page'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter