class Contacts extends Backbone.View

  el: '#contacts-list'

  initialize: (options) ->
    @collection.on 'reset', @render, this

  template: _.template($('#contact-list-item').html())

  render: ->
    @$el.html ''
    console.log @collection
    for model in @collection.models
      @$el.append @template(model.toJSON())
    this

@app = window.app ? {}
@app.Views.Contacts = Contacts