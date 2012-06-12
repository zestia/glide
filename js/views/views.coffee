
# First panel to be displayed
class Home extends Backbone.View

  el: $('#panel-1 ul')

  initialize: (options) ->
    template = $('#panel-1')
    @collection.on "reset", @render    
    
    # check to see if template has already been rendered

    $('#main-menu-btn').click ->
      flight.slideOutMenu()
    
  render: () =>
    @collection.each (model) =>
      console.log model.toJSON()
      compiledTemplate = _.template( $('#panel-1-li').html(), model.toJSON())
      @$el.append( compiledTemplate )
    
    this

@app = window.app ? {}
@app.Views.Home = Home

# second panel
class Panel_2 extends Backbone.View

  el: $('#panel-2')
  
  initialize: (options) ->
    
    template = $('#panel-2')
    # check to see if template has already been rendered
    compiledTemplate = _.template( $('#panel-2').html() )
    @$el.html( compiledTemplate ) 
               
  render: (id) =>  
    
    $('.back').on 'click', ->
      window.history.back()
      
    this
  
@app = window.app ? {}
@app.Views.Panel_2 = Panel_2

# third panel
class Panel_3 extends Backbone.View

  el: $('#panel-3')

  initialize: (options) ->
    
    template = $('#panel-3')
    # check to see if template has already been rendered
    compiledTemplate = _.template( $('#panel-3').html() )
    @$el.html( compiledTemplate )

  render: (id) ->     
    
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
    compiledTemplate = _.template( $('#panel-4').html() )    
    @$el.html( compiledTemplate )
        
    $('.back').on 'click', ->
      window.history.back()
    
    this
  
@app = window.app ? {}
@app.Views.Panel_4 = Panel_4

