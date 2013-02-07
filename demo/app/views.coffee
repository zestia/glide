class Contacts extends Backbone.View

  el: '#contacts-list'

  initialize: (options) ->
    @collection.on 'reset', @render, this

  template: _.template($('#contact-list-item').html())

  render: ->
    @$el.html ''
    for model in @collection.models
      if not model.attributes.image? then model.attributes.image = 'tyrion.jpg'
      @$el.append @template(model.toJSON())
    this

@app = window.app ? {}
@app.Views.Contacts = Contacts

class ContactsShow extends Backbone.View

  el: '#contact-page'
  template: _.template($('#contact-item').html())

  events:
    'click .back': 'goBack'
    'click .do-something': 'doSomething'

  render: ->
    @$el.html ''
    @$el.append @template(@model.toJSON())
    this

  doSomething: (e) ->
    e.preventDefault()

  goBack: ->
    app.goBack()

@app = window.app ? {}
@app.Views.ContactsShow = ContactsShow