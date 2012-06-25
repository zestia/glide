class Activities extends Backbone.Collection

  model: app.Models.Activity

  url: "data/activity.json"

@app = window.app ? {}
@app.Collections.Activities = new Activities
