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
    glide.to '#index'

  gettingStarted: ->
    glide.to '#getting-started'

  fixedHeaderFooter: ->
    glide.to '#fixed-header-footer'

  transitions: ->
    glide.to '#transitions'

  slide: ->
    glide.to '#slide'

  slideUp: ->
    glide.to '#slideUp'

  contacts: ->
    view = new app.Views.Contacts collection: app.Collections.Contacts
    view.render()
    glide.to '#contacts'

  showContact: (id) ->
    model = app.Collections.Contacts?.get(id)
    view = new app.Views.ContactsShow model: model
    view.render()
    glide.to '#contact-page'

  createdBy: ->
    glide.to '#created-by'

  contribute: ->
    glide.to '#contribute'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
