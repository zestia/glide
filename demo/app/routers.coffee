class AppRouter extends Backbone.Router

  routes:
    '': 'activities'
    'entry': 'entry'
    'contact/add': 'addContact'

  activities: ->
    view = new app.Views.Activities collection: app.Collections.Activities
    view.render()
    glide.goto '#activity'

  entry: ->
    glide.goto '#entry'

  addContact: ->
    glide.goto '#add-contact-form'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
