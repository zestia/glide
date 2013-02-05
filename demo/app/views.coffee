class Contacts extends Backbone.View

  el: '#contacts-list'

  initialize: (options) ->
    @collection.on 'reset', @render, this

  template: _.template($('#contact-list-item').html())

  render: ->
    @$el.html ''
    console.log @collection
    for model in @collection.models
      if not model.attributes.image? then model.attributes.image = ''
      @$el.append @template(model.toJSON())
    this

@app = window.app ? {}
@app.Views.Contacts = Contacts