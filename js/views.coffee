class Activities extends Backbone.View

  el: '#activity-list'

  initialize: (options) ->
    @collection.on 'reset', @render, this

  template: _.template($('#activity-list-item').html())

  render: ->
    @$el.html ''
    for model in @collection.models
      @$el.append @template(model.toJSON())
    this

@app = window.app ? {}
@app.Views.Activities = Activities
