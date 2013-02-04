class AppRouter extends Backbone.Router

  routes:
    '': 'index'
    'animations': 'animations'
    'slide': 'slide'
    'slideUp': 'slideUp'
    'contacts': 'contacts'
    'contact/add': 'addContact'

  index: ->
    flight.goto '#index'

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

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter