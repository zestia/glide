class AppRouter extends Backbone.Router

  routes:
    '': 'activities'
    'test': 'test'

  activities: ->
    view = new app.Views.Activities collection: app.Collections.Activities
    view.render()
    flight.goto '#activity'

  test: ->
    flight.goto '#test'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
