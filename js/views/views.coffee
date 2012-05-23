
class Panel_2 extends Backbone.View

  el: $('#panel-2')

  initialize: (options) ->

  render: (id) ->
    compiledTemplate = _.template( $('#panel-2-template').html(), {header:"panel " + id}  )    
    @$el.html( compiledTemplate )
    flight.goToPage({targetPanel:'#panel-' + id})
    
    this
  

@app = window.app ? {}
@app.Views.Panel_2 = Panel_2
