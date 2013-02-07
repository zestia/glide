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
    glide.goto '#index'

  gettingStarted: ->
    glide.goto '#getting-started'

  animations: ->
    glide.goto '#animations'

  slide: ->
    glide.goto '#slide'

  slideUp: ->
    glide.goto '#slideUp'

  contacts: ->
    view = new app.Views.Contacts collection: app.Collections.Contacts
    view.render()
    glide.goto '#contacts'

  showContact: (id) ->
    model = app.Collections.Contacts?.get(id)
    view = new app.Views.ContactsShow model: model
    view.render()
    glide.goto '#contact-page'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter