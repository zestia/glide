class AppRouter extends Backbone.Router

  routes:
    '': 'index'
    'getting-started': 'gettingStarted'
    'fixed-header-footer': 'fixedHeaderFooter'
    'transitions': 'transitions'
    'slide': 'slide'
    'slideUp': 'slideUp'
    'contacts': 'contacts'
    'contacts/:id': 'showContact'
    'created-by': 'createdBy'
    'contribute': 'contribute'

  index: ->
    glide.goto '#index'

  gettingStarted: ->
    glide.goto '#getting-started'

  fixedHeaderFooter: ->
    glide.goto '#fixed-header-footer'

  transitions: ->
    glide.goto '#transitions'

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

  createdBy: ->
    glide.goto '#created-by'

  contribute: ->
    glide.goto '#contribute'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter