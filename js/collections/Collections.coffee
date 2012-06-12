class ActivityCollection extends Backbone.Collection
  model: app.Models.Activity
  url: "js/data/activity.json"
  
  initialize: ->
    console.log "made colleciton"
  
  parse: (response) ->
    return response;
  
@app = window.app ? {}
@app.Collections.ActivityCollection = ActivityCollection