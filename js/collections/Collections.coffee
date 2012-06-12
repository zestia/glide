class ActivityCollection extends Backbone.Collection
  model: app.Models.Activity
  url: "js/data/activity.json"
  
  initialize: ->
  
  parse: (response) ->
    return response;
  
@app = window.app ? {}
@app.Collections.ActivityCollection = ActivityCollection