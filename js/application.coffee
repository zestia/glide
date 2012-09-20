class App

  Routers: {}

  Models: {}

  Collections: {}

  Views: {}

  init: ->
    window.flight = new Flight()
    new @Routers.AppRouter
    Backbone.history.start()

    @Collections.Activities.fetch()

window.app = new App

`
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
};
String.prototype.truncate = function(n,useWordBoundary) {
     var toLong = this.length>n,
         s_ = toLong ? this.substr(0,n-1) : this;
     s_ = useWordBoundary && toLong ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
     return  toLong ? s_ +'...' : s_;
};
String.prototype.escapeHTML = function () {
    return(this.replace(/&/g,'&amp;').replace(/>/g,'&gt;').replace(/</g,'&lt;').replace(/"/g,'&quot;'));
};
String.prototype.ellipse = function(len) {
  return (this.length > len) ? this.substr(0, len) + "..." : this;
}
`
