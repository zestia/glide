
# First panel to be displayed
class Home extends Backbone.View

  el: $('#panel-1 ul')

  initialize: (options) ->
    template = $('#panel-1')
    @collection.on "reset", @render    
    
    $('#main-menu-btn').click (e) ->
      e.preventDefault()
      flight.slideOutMenu()
    
  render: () =>
    toolbar = $('.toolbar')  
    toolbar.find('h1').html 'Activity'
    toolbar.find('.right').attr 'href','#/panel/2'
    toolbar.find('.right').html 'Page 2'
    
    html =  $('#panel-1-li').html()
    htmlFragment = ''
    
    @collection.each (model) ->
      compiledTemplate = _.template( html, model.toJSON())
      htmlFragment += compiledTemplate
    
    @$el.append( htmlFragment )
    
    
    
    this

@app = window.app ? {}
@app.Views.Home = Home

# second panel
class Panel_2 extends Backbone.View

  el: $('#panel-2')
  
  initialize: (options) ->
    

               
  render: () =>
    
    template = $('#panel-2')
    # check to see if template has already been rendered
    compiledTemplate = _.template( $('#panel-2').html() )
    @$el.html( compiledTemplate )
    $('#main-menu-btn').remove()
    
    toolbar = $('.toolbar')  
    toolbar.find('h1').html 'Panel 2'
    toolbar.find('.right').attr 'href','#/panel/3'
    toolbar.find('.right').html 'Page 3'
    
    toolbar.prepend('<a class="left btn back">Back</a>')
      
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

  render: () ->     
    
    toolbar = $('.toolbar')  
    toolbar.find('h1').html 'Panel 3'
    toolbar.find('.right').attr 'href','#/panel/4'
    toolbar.find('.right').html 'Form'
    
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
    
    toolbar = $('.toolbar')  
    toolbar.find('h1').html 'Form'
    toolbar.find('a').removeAttr 'href'
    toolbar.find('.right').html 'Save'
    toolbar.find('.right').die 'click'
    toolbar.find('.right').on 'click', (e) ->
      window.history.back()
        
    $('.back').on 'click', ->
      window.history.back()
    
    this
  
@app = window.app ? {}
@app.Views.Panel_4 = Panel_4

