
# First panel to be displayed
class Home extends Backbone.View

  el: $('#panel-1')

  initialize: (options) ->
    template = $('#panel-1-template')
    # check to see if template has already been rendered
    if not template.length <1      
      compiledTemplate = _.template( $('#panel-1-template').html(), {header:"Home"}  )
      @$el.html( compiledTemplate )
    
  render: () ->
    # $('#panel-1').show();
    # flight.displayPage({targetPanel:'#panel-1'})
    this

@app = window.app ? {}
@app.Views.Home = Home

# second panel
class Panel_2 extends Backbone.View

  el: $('#panel-2')
  
  initialize: (options) ->
    
    template = $('#panel-2-template')
    # check to see if template has already been rendered
    if not template.length <1      
      compiledTemplate = _.template( $('#panel-2-template').html(), {header:"panel 2"}  )
      @$el.html( compiledTemplate ) 
               
  render: (id) =>  
    # use flight for page load.
    flight.goToPage({targetPanel:'#panel-' + id})
    
    $('.back').on 'click', ->
      window.history.back()
      
    this
  
@app = window.app ? {}
@app.Views.Panel_2 = Panel_2

# third panel
class Panel_3 extends Backbone.View

  el: $('#panel-3')

  initialize: (options) ->
    
    template = $('#panel-3-template')
    # check to see if template has already been rendered
    if not template.length <1      
      compiledTemplate = _.template( $('#panel-3-template').html(), {header:"panel 3"}  )
      @$el.html( compiledTemplate )

  render: (id) ->     
    # use flight for page load.
    flight.goToPage({targetPanel:'#panel-' + id})
    
    $('.back').on 'click', ->
      window.history.back()
    
    this
  
@app = window.app ? {}
@app.Views.Panel_3 = Panel_3

# third panel
class Panel_4 extends Backbone.View

  el: $('#panel-4')

  initialize: (options) ->

  render: (id) ->
    compiledTemplate = _.template( $('#panel-4-template').html(), {header:"panel " + id}  )    
    @$el.html( compiledTemplate )
    
    # use flight for page load.
    flight.goToPage({targetPanel:'#panel-' + id})
    
    $('.back').on 'click', ->
      window.history.back()
    
    this
  
@app = window.app ? {}
@app.Views.Panel_4 = Panel_4

