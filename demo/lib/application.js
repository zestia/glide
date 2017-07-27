// Generated by CoffeeScript 1.12.7
(function() {
  var App;

  App = (function() {
    function App() {}

    App.prototype.Routers = {};

    App.prototype.Models = {};

    App.prototype.Collections = {};

    App.prototype.Views = {};

    App.prototype.init = function() {
      window.glide = new Glide({
        stylesheetPath: '../lib/',
        plugins: {
          menu: GlideMenu
        }
      });
      new this.Routers.AppRouter;
      this.Collections.Contacts.fetch();
      return Backbone.history.start();
    };

    App.prototype.goBack = function() {
      return window.history.back();
    };

    return App;

  })();

  window.app = new App;

}).call(this);
