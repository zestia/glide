class AppRouter extends Backbone.Router

  routes:
    '': 'activities'

  activities: ->
    activities = app.Collections.Activities
    activities.fetch()
    view = new app.Views.Activities collection: activities
    view.render()
    flight.goto "#activity"

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
