// Generated by CoffeeScript 1.12.7
(function() {
  var GlideMenu,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  GlideMenu = (function() {
    function GlideMenu(glide) {
      var base;
      this.glide = glide;
      this.toggle = bind(this.toggle, this);
      this.close = bind(this.close, this);
      this.menu = document.querySelector('#main-menu');
      (base = this.glide.hooks)['before:to'] || (base['before:to'] = []);
      this.glide.hooks['before:to'].push((function(_this) {
        return function() {
          return _this.close();
        };
      })(this));
      if (this.glide.isAndroid() && this.glide.versionMatches(/2\.3/g)) {
        this.animate = false;
      } else {
        this.animate = true;
      }
    }

    GlideMenu.prototype.close = function() {
      if (this.menuOpen === true) {
        this.menu.style.display = 'none';
        return this.menuOpen = false;
      }
    };

    GlideMenu.prototype.toggle = function() {
      if (this.menuOpen) {
        if (this.animate) {
          setTimeout((function(_this) {
            return function() {
              return _this.glide.translate(_this.menu, 'X', '-110%', '0.3s');
            };
          })(this), 10);
          setTimeout((function(_this) {
            return function() {
              return _this.menu.style.display = 'none';
            };
          })(this), 300);
        } else {
          this.menu.style.display = 'none';
        }
        return this.menuOpen = false;
      } else {
        if (this.animate) {
          this.glide.translate(this.menu, 'X', '-110%', '0ms');
          setTimeout((function(_this) {
            return function() {
              return _this.glide.translate(_this.menu, 'X', '0%', '0.3s');
            };
          })(this), 50);
          this.menu.style.display = "block";
        } else {
          this.menu.style.display = "block";
        }
        return this.menuOpen = true;
      }
    };

    return GlideMenu;

  })();

  window.GlideMenu = GlideMenu;

}).call(this);
