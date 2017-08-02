'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/* global $, document, window */

var Glide = function () {
  _createClass(Glide, null, [{
    key: 'init',
    value: function init() {
      this.prototype.hooks = {
        'before:to': [],
        'after:to': []
      };

      this.prototype.stylesheetPath = '/';
      this.prototype.isTransitioning = false;
      this.prototype.transitionAnimation = true;
    }

    // Public: Instantiate Glide and set any options.
    //
    // options - A Hash of options for glide.
    //
    // Returns nothing.

  }]);

  function Glide() {
    var _this = this;

    var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, Glide);

    this.to = this.to.bind(this);
    this.hideTransitionedPage = this.hideTransitionedPage.bind(this);
    this.isTouch = this.isTouch.bind(this);
    this.handleEvents = this.handleEvents.bind(this);
    this.onTouchStart = this.onTouchStart.bind(this);
    this.removePressed = this.removePressed.bind(this);

    Object.keys(options).forEach(function (key) {
      var value = options[key];
      _this[key] = value;
    });

    this.detectUserAgent();

    Object.keys(this.plugins).forEach(function (key) {
      var Plugin = _this.plugins[key];
      _this.plugins[key] = new Plugin(_this);
    });

    if (this.isTouch()) {
      document.body.addEventListener('touchstart', this.handleEvents, false);
    } else {
      document.body.addEventListener('mousedown', this.handleEvents, false);
    }
  }

  // Private: Get a Hash of browser user agent information.
  //
  // Returns a Hash of user agent information.


  _createClass(Glide, [{
    key: 'detectUserAgent',
    value: function detectUserAgent() {
      var userAgent = window.navigator.userAgent;


      this.os = {
        android: !!userAgent.match(/(Android)\s+([\d.]+)/) || !!userAgent.match(/Silk-Accelerated/)
      };

      var match = userAgent.match(/((iPad).*OS|(iPhone\sOS))\s([\d_]+)/);

      if (match) {
        this.os.ios = true;
        this.os.version = match[4].replace(/_/g, '.');
        this.os.full = 'iOS ' + this.os.version;
      }

      if (this.os.android) {
        var result = userAgent.match(/Android (\d+(?:\.\d+)+)/);
        this.os.version = result[1];
        this.os.full = 'Android ' + this.os.version;
      }
    }

    // Public: Go to a specific page.
    //
    // targetPage - A String of the element ID or existing element.
    // animate    - A Boolean of whether to animate the transition.
    //
    // Returns nothing.

  }, {
    key: 'to',
    value: function to(target) {
      var _this2 = this;

      var animate = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;

      var targetPage = target;
      var transitionType = void 0;

      var oldAnimate = this.transitionAnimation;

      this.transitionAnimation = animate;

      this.hooks['before:to'].forEach(function (hook) {
        return hook();
      });

      if (typeof targetPage === 'string') {
        this.targetPage = document.querySelector(targetPage);
      } else if (targetPage) {
        this.targetPage = targetPage;
      }

      if (this.targetPage === this.currentPage || this.isTransitioning) {
        return;
      }

      if (this.currentPage == null) {
        this.targetPage.style.display = '-webkit-box';
        this.currentPage = this.targetPage;
        return;
      }

      this.isTransitioning = true;

      if (this.back) {
        transitionType = this.currentPage.getAttribute('data-transition') || 'slide';
      } else {
        transitionType = this.targetPage.getAttribute('data-transition') || 'slide';
      }

      targetPage = this.targetPage;
      var currentPage = this.currentPage;


      this.currentPage = this.targetPage;

      currentPage.classList.add('previousPage');
      document.body.addEventListener('webkitTransitionEnd', this.hideTransitionedPage, false);

      setTimeout(function () {
        if (transitionType !== 'none') {
          _this2[transitionType](targetPage, currentPage);
        } else {
          _this2.displayPage(targetPage, currentPage);
        }

        _this2.transitionAnimation = oldAnimate;
      }, 10);

      this.hooks['after:to'].forEach(function (hook) {
        return hook();
      });
    }

    // Private: Perform a slide transition.
    //
    // Returns nothing.

  }, {
    key: 'slide',
    value: function slide(targetPage, currentPage) {
      var _this3 = this;

      targetPage.style.display = '-webkit-box';

      var screenWidth = window.innerWidth + 'px';
      var axis = 'X';

      if (this.back) {
        this.translate(currentPage, axis, '0%');
        this.translate(targetPage, axis, '-' + screenWidth, '0ms');

        setTimeout(function () {
          _this3.translate(currentPage, axis, '100%');
        }, 0);
      } else {
        this.translate(currentPage, axis, '0%');
        this.translate(targetPage, axis, screenWidth, '0ms');

        setTimeout(function () {
          _this3.translate(currentPage, axis, '-100%');
        }, 0);
      }

      setTimeout(function () {
        _this3.translate(targetPage, axis, '0%');
        _this3.back = false;
      }, 0);
    }

    // Private: Perform a slide from bottom transition.
    //
    // Returns nothing.

  }, {
    key: 'slideUp',
    value: function slideUp(targetPage, currentPage) {
      var _this4 = this;

      targetPage.style.display = '-webkit-box';
      var screenHeight = window.innerHeight + 'px';
      var axis = 'Y';

      if (this.back) {
        setTimeout(function () {
          _this4.translate(currentPage, axis, screenHeight);
        }, 0);
      } else {
        targetPage.style.zIndex = '1000';

        this.translate(targetPage, axis, screenHeight, '0ms');

        setTimeout(function () {
          _this4.translate(targetPage, axis, '0%');
        }, 0);
      }

      this.back = false;
    }

    // Private: Translate page on a specified axis.
    //
    // page     - An Element of the page.
    // axis     - A String of the axis.
    // distance - A String of the distance.
    // duration - A String of the duration, defaults to 0.3s.
    //
    // Returns nothing.

  }, {
    key: 'translate',
    value: function translate(page, axis, distance) {
      var duration = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '0.3s';

      page.style.webkitTransition = duration + ' cubic-bezier(.10, .10, .25, .90)';
      page.style.webkitTransform = 'translate' + axis + '(' + distance + ')';
    }

    // Private: Show the current page without transition
    //
    // Returns nothing.

  }, {
    key: 'displayPage',
    value: function displayPage(targetPage, currentPage) {
      this.isTransitioning = false;
      targetPage.style.display = '-webkit-box';
      currentPage.classList.add('previousPage');
      this.back = false;
      this.hideTransitionedPage();
    }

    // Private: Hide DOM that has just been transitioned
    //
    // Returns nothing

  }, {
    key: 'hideTransitionedPage',
    value: function hideTransitionedPage() {
      var _this5 = this;

      this.isTransitioning = false;
      var previousPage = document.querySelector('.previousPage');

      if (previousPage) {
        setTimeout(function () {
          previousPage.classList.remove('previousPage');
          previousPage.style.display = 'none';
          _this5.translate(previousPage, 'X', '0%', '0ms');
        }, 0);
      }

      document.body.removeEventListener('webkitTransitionEnd', this.hideTransitionedPage, false);
    }

    // Private: Is the device touch enabled.
    //
    // Returns True if the device is touch enabled, else False.

  }, {
    key: 'isTouch',
    value: function isTouch() {
      if (typeof this.touch === 'undefined') {
        if ('ontouchstart' in window) {
          this.touch = true;
        } else {
          this.touch = false;
        }
      }

      return this.touch;
    }

    // Public: Is the device running iOS
    //
    // Returns True if the device is running iOS, else False.

  }, {
    key: 'isIOS',
    value: function isIOS() {
      return this.os.ios;
    }

    // Public: Is the device running Android
    //
    // Returns True if the device is running Android, else False.

  }, {
    key: 'isAndroid',
    value: function isAndroid() {
      return this.os.android;
    }

    // Public: Get the version of the OS running on the device.
    //
    // Returns a String of the OS version.

  }, {
    key: 'osVersion',
    value: function osVersion() {
      return this.os.version.toString();
    }

    // Public: Test whether the OS version matches the specified version.
    //
    // Returns: True if the version matches, else False.

  }, {
    key: 'versionMatches',
    value: function versionMatches(regex) {
      return !!this.os.version.toString().match(regex);
    }

    // Private: Handle touch events to apply pressed class to anchors
    //
    // Returns nothing.

  }, {
    key: 'handleEvents',
    value: function handleEvents(e) {
      if (this.isTouch()) {
        switch (e.type) {
          case 'touchstart':
            this.onTouchStart(e);
            break;
          case 'touchmove':
            this.removePressed();
            break;
          case 'touchend':
            this.removePressed();
            break;
          default:
            break;
        }
      } else {
        switch (e.type) {
          case 'mousedown':
            this.onTouchStart(e);
            break;
          default:
            break;
        }
      }
    }
  }, {
    key: 'onTouchStart',
    value: function onTouchStart(e) {
      if (this.isTouch()) {
        if (this.isAndroid()) {
          this.theTarget = document.elementFromPoint(e.changedTouches[0].screenX, e.changedTouches[0].screenY);
        } else {
          this.theTarget = document.elementFromPoint(e.targetTouches[0].clientX, e.targetTouches[0].clientY);
        }
      } else {
        this.theTarget = document.elementFromPoint(e.clientX, e.clientY);
      }

      if (this.theTarget && this.theTarget.nodeName && this.theTarget.nodeName.toLowerCase() !== 'a' && (this.theTarget.nodeType === 3 || this.theTarget.nodeType === 1)) {
        this.oldTarget = this.theTarget;
        this.theTarget = $(this.theTarget).closest('a')[0];
      }

      if (this.theTarget === null || typeof this.theTarget === 'undefined') {
        return;
      }

      this.theTarget.classList.add('pressed');

      this.theTarget.addEventListener('touchmove', this.removePressed, false);
      this.theTarget.addEventListener('mouseout', this.removePressed, false);
      this.theTarget.addEventListener('touchend', this.removePressed, false);
      this.theTarget.addEventListener('mouseup', this.removePressed, false);
      this.theTarget.addEventListener('touchcancel', this.removePressed, false);
    }
  }, {
    key: 'removePressed',
    value: function removePressed() {
      var elements = document.getElementsByClassName('pressed');
      [].slice.call(elements).forEach(function (element) {
        return element.classList.remove('pressed');
      });
    }
  }]);

  return Glide;
}();

Glide.init();
window.Glide = Glide;