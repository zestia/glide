# Glide.js

Glide.js is as a simple lightweight mobile framework built with Backbone in mind. Take a look at the demo on your device:

[View Demo](http://glide.zestia.com)

## Getting Started

### Using Glide.js

This guide will take you through some steps to get started. Further down we cover how to use Glide.js with backbone.js. Feedback welcome [@hallodom](https://twitter.com/hallodom)

### Features

- <code>glide.css</code> gives scructure to your app making it easy to create fixed top or bottom positioned elements with native
- <code>glide.js</code> handles forwards and backwards page transitions.
- We use <code>fastclick.js</code> to speed up clicks.
- Extend Glide wih your own plugins.

### Device Support

- iPhone 9.3+
- Android 4.4+
* Glide only works in Webkit based browsers at this time

## Markup

### Anatomy of a page

Include glide.js and css files. Make sure to include a theme.

```html
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="css/glide.css">
    <link rel="stylesheet" href="css/glide.theme.css">
  </head>
  <body>

    <!-- pages here -->

    <script src="js/glide.js"></script>
    <script>
      window.glide = new Glide
    </script>
  </body>
</html>
```
Organise your app into pages. Make sure each page has the class .page and .hidden:

```html
<div id="page-1" class="page hidden">
  <!-- page content -->
</div>

<div id="page-2" class="page hidden">
  <!-- page content -->
</div>
```

Glide will use the unique ID's to target the pages. Once you have some pages marked tell Glide to open the first page by passing the page id as a string to the to() function:

```html
<script>
  window.glide = new Glide
  glide.to('#page-1')
</script>
```
That's all you need to get started.

### Scrolling

Glide makes use of native scrolling [reference](https://github.com/joelambert/ScrollFix/issues/2). This solution does away with rubber banding on iOS without the need of a javscript solution. The solution requires three divs. Anything outside div.scrollview becomes a fixed positioned element:

```html
<div id="page-1" class="page hidden">
  <!-- fixed header here -->
  <div class="scrollview">
    <div class="scrollview-inner">
      <div class="scrollview-content">
        <!-- scrollable content here -->
      </div>
    </div>
  </div>
  <!-- fixed footer here -->
</div>
```
## Transitioning pages

Transitioning pages can be done in a router or using simple click events binding the glide.to() function. Glide does not watch for hash change events.

```html
<a href="#page-2" id="#page-2-link" class="button">
  <button>Go to page 2</button>
</a>
```
In your javascript assign a click event to the anchor.

```javascript
$('#page-2-link').on('click',function(){
  glide.to("#page-2");
});
```
Glide will perform the default slide transition to #page-2. You can make a back button with:

```html
<div id="page-2">
  <a href="#page-1" class="back">
    <button>Back</button>
  </a>
</div>
```
We wrap a button within an anchor so we can pad the hit target to make it easier to tap. Then have some javascript to go back. You must explicitly state back as true for a reverse transition:

```js
$('#page-2 a.back').on('click',function(){
  glide.back = true
  glide.to('#page-1')
});

or 

$('#page-2 a.back').on('click',function(){
  glide.back = true
  window.history.back()
});
```

### Slide Up

To transition to a page using a slideUp transtion use `data-transition="slideUp"` on the target page:

```
  <div id="page-1" class="page hidden" data-transition="slideUp"> </div>
 ``` 
 
Glide will know when to reverse the transitions when navigating back to a page. 
 
### No transition

To display a page without a transition use `data-transition="none"` on the target page:

```
  <div id="page-1" class="page hidden" data-transition="none"> </div>
 ``` 
 
## Using the menu plugin

To use the menu plugin include the js and pass in a plugins has as options when instantiating Glide. We wrote the menu as a plugin so it's easier to build your own custom implmentations.

```html
<script src="js/glide.menu.js"></script>
```
```js
window.glide = new Glide({
  plugins: {
    menu: GlideMenu
  }
});
```
GlideMenu will look for the id #main-menu, make sure that is the ID for your menu markup. Now bind glide.plugins.menu.toggle() to your menu button:

```js
$('#main-menu-button').on('click',function(e){
  e.preventDefault();
  glide.plugins.menu.toggle()
});
```
Hiding the menu can be calling toggle() again while the menu is open:

```js
$('#close-menu-btn').on('click',function(e){
  e.preventDefault();
  glide.plugins.menu.toggle()
});
```
## Using Glide with Backbone.js

We built Glide because we needed a flexible mobile framework that would work well with backbones router implementation. See the example below:

```js
var AppRouter = Backbone.Router.extend({
    routes: {
      '': 'index',
      'getting-started': 'gettingStarted'
      'animations': 'animations'
      'slide': 'slide'
      'slideUp': 'slideUp'
      'contacts': 'contacts'
      'contacts/:id': 'showContact'
    },
    index: function() {
      glide.to('#index')
    },
    gettingStarted: function() {
      glide.to('#getting-started')
    },
    animations: function() {
      glide.to('#animations')
    },
    slide: function() {
      glide.to('#slide')
    },
    slideUp: function() {
      glide.to('#slideUp')
    },
    contacts: function() {
      view = new app.Views.Contacts collection: app.Collections.Contacts
      view.render()
      glide.to('#contacts')
    },
    showContact: function(id) {
      model = app.Collections.Contacts?.get(id)
      view = new app.Views.ContactsShow model: model
      view.render()
      glide.to('#contact-page')
    }
});
```
Example below in coffescript:

```coffee
class AppRouter extends Backbone.Router

  routes:
    '': 'index'
    'getting-started': 'gettingStarted'
    'animations': 'animations'
    'slide': 'slide'
    'slideUp': 'slideUp'
    'contacts': 'contacts'
    'contacts/:id': 'showContact'

  index: ->
    glide.to '#index'

  gettingStarted: ->
    glide.to '#getting-started'

  animations: ->
    glide.to '#animations'

  slide: ->
    glide.to '#slide'

  slideUp: ->
    glide.to '#slideUp'

  contacts: ->
    view = new app.Views.Contacts collection: app.Collections.Contacts
    view.render()
    glide.to '#contacts'

  showContact: (id) ->
    model = app.Collections.Contacts?.get(id)
    view = new app.Views.ContactsShow model: model
    view.render()
    glide.to '#contact-page'

@app = window.app ? {}
@app.Routers.AppRouter = AppRouter
```

Above you can see how clean using Glide is when coupled with backbone routing. No need to worry about forward and back transitions, using glide.to() on each route has that all worked out for you.

## View example app

To see Glide in full use view our example contacts app and take time to download and look [through the source](https://github.com/zestia/glide/tree/master/demo).

## Contribute

Here's the most direct way to get your work merged into the project.

1. Fork the project
2. Clone down your fork
3. Create a feature branch
4. Hack away
5. If necessary, rebase your commits into logical chunks without errors
6. Push the branch up to your fork
7. Send a pull request for your branch

## Copyright

Copyright &copy; Zestia, Ltd. See LICENSE for details.
