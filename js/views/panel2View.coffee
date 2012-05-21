
class panel2View extends Backbone.View

  el: $('#panel-2')

  initialize: (options) ->

  render: (id) ->
    compiledTemplate = _.template( $('#panel-2-template').html() )    
    @$el.html( compiledTemplate )
    console.log id
    flight.goToPage({targetPanel:'#panel-' + id})

    this


@app = window.app ? {}
@app.Views.panel2View = panel2View
