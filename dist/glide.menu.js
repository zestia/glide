'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/* global document, window */

var GlideMenu = function () {
  function GlideMenu(glide) {
    var _this = this;

    _classCallCheck(this, GlideMenu);

    this.close = this.close.bind(this);
    this.toggle = this.toggle.bind(this);

    this.glide = glide;
    this.animate = true;
    this.menu = document.querySelector('#main-menu');

    if (!this.glide.hooks['before:to']) {
      this.glide.hooks['before:to'] = [];
    }

    this.glide.hooks['before:to'].push(function () {
      return _this.close();
    });
  }

  _createClass(GlideMenu, [{
    key: 'close',
    value: function close() {
      if (this.menuOpen === true) {
        this.menu.style.display = 'none';
        this.menuOpen = false;
      }
    }
  }, {
    key: 'toggle',
    value: function toggle() {
      var _this2 = this;

      if (this.menuOpen) {
        if (this.animate) {
          setTimeout(function () {
            _this2.glide.translate(_this2.menu, 'X', '-110%', '0.3s');
          }, 10);

          setTimeout(function () {
            _this2.menu.style.display = 'none';
          }, 300);
        } else {
          this.menu.style.display = 'none';
        }

        this.menuOpen = false;
      } else {
        if (this.animate) {
          this.glide.translate(this.menu, 'X', '-110%', '0ms');

          setTimeout(function () {
            _this2.glide.translate(_this2.menu, 'X', '0%', '0.3s');
          }, 50);

          this.menu.style.display = 'block';
        } else {
          this.menu.style.display = 'block';
        }

        this.menuOpen = true;
      }
    }
  }]);

  return GlideMenu;
}();

window.GlideMenu = GlideMenu;