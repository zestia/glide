class Contacts extends Backbone.Collection

  model: app.Models.Contact

  url: "data/contacts.json"

@app = window.app ? {}
@app.Collections.Contacts = new Contacts
