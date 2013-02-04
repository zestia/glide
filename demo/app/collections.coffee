class Activities extends Backbone.Collection

  model: app.Models.Activity

  url: "data/activity.json"

@app = window.app ? {}
@app.Collections.Activities = new Activities

class Contacts extends Backbone.Collection

  model: app.Models.Contact

  url: "data/contacts.json"

@app = window.app ? {}
@app.Collections.Contacts = new Contacts
