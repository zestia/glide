class Activity extends Backbone.Model  
  name: "Activity"
  initialize: ->
    console.log "Activity created"
    
@app = window.app ? {}
@app.Models.Activity = Activity
