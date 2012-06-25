class AppRouter extends Backbone.Router

  routes:
    '': 'activities'
    'test': 'test'

  activities: ->
    activities = app.Collections.Activities
    activities.fetch()
    view = new app.Views.Activities collection: activities
    view.render()
    flight.goto '#activity'

  test: ->
    flight.goto '#test'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
