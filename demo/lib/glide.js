// Generated by CoffeeScript 1.6.3
(function() {
  var Glide,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Glide = (function() {
    Glide.prototype.stylesheetPath = '/';

    Glide.prototype.hooks = {
      'before:to': [],
      'after:to': []
    };

    Glide.prototype.isTransitioning = false;

    Glide.prototype.transitionAnimation = true;

    Glide.prototype.speed = 0.3;

    function Glide(options) {
      var key, value, _ref;
      if (options == null) {
        options = {};
      }
      this.removePressed = __bind(this.removePressed, this);
      this.onTouchStart = __bind(this.onTouchStart, this);
      this.handleEvents = __bind(this.handleEvents, this);
      this.isTouch = __bind(this.isTouch, this);
      this.hideTransitionedPage = __bind(this.hideTransitionedPage, this);
      this.to = __bind(this.to, this);
      for (key in options) {
        value = options[key];
        this[key] = value;
      }
      this.detectUserAgent();
      if (this.isAndroid() && this.versionMatches(/2\.3/)) {
        this.setupForAndroid();
      }
      _ref = this.plugins;
      for (key in _ref) {
        value = _ref[key];
        this.plugins[key] = new value(this);
      }
      if (this.isTouch()) {
        document.body.addEventListener('touchstart', this.handleEvents, false);
      } else {
        document.body.addEventListener('mousedown', this.handleEvents, false);
      }
    }

    Glide.prototype.detectUserAgent = function() {
      var match, result, userAgent;
      userAgent = window.navigator.userAgent;
      this.os = {};
      this.os.android = !!userAgent.match(/(Android)\s+([\d.]+)/) || !!userAgent.match(/Silk-Accelerated/);
      if (match = userAgent.match(/((iPad).*OS|(iPhone\sOS))\s([\d_]+)/)) {
        this.os.ios = true;
        this.os.version = match[4].replace(/_/g, '.');
        this.os.full = "iOS " + this.os.version;
      }
      if (this.os.android) {
        result = userAgent.match(/Android (\d+(?:\.\d+)+)/);
        this.os.version = result[1];
        return this.os.full = "Android " + this.os.version;
      }
    };

    Glide.prototype.to = function(targetPage) {
      var currentPage, hook, transitionType, _i, _j, _len, _len1, _ref, _ref1, _results,
        _this = this;
      _ref = this.hooks['before:to'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hook = _ref[_i];
        hook();
      }
      if (typeof targetPage === "string") {
        this.targetPage = document.querySelector(targetPage);
      } else if (targetPage) {
        this.targetPage = targetPage;
      }
      if (this.targetPage === this.currentPage || this.isTransitioning) {
        return;
      }
      if (this.currentPage == null) {
        this.targetPage.style.display = "-webkit-box";
        this.currentPage = this.targetPage;
        return;
      }
      this.isTransitioning = true;
      if (this.back) {
        transitionType = this.currentPage.getAttribute("data-transition") || 'slide';
      } else {
        transitionType = this.targetPage.getAttribute("data-transition") || 'slide';
      }
      targetPage = this.targetPage;
      currentPage = this.currentPage;
      this.currentPage = this.targetPage;
      this.addClass(currentPage, 'previousPage');
      document.body.addEventListener("webkitTransitionEnd", this.hideTransitionedPage, false);
      setTimeout(function() {
        if (_this.transitionAnimation) {
          return _this[transitionType](targetPage, currentPage);
        } else {
          return _this.displayPage(targetPage, currentPage);
        }
      }, 10);
      _ref1 = this.hooks['after:to'];
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        hook = _ref1[_j];
        _results.push(hook());
      }
      return _results;
    };

    Glide.prototype.setupForAndroid = function() {
      var androidCSS, head, styleSheet, styleSheets, _i, _len, _ref;
      head = document.getElementsByTagName('head')[0];
      androidCSS = document.createElement('link');
      androidCSS.setAttribute('rel', 'stylesheet');
      androidCSS.setAttribute('type', 'text/css');
      androidCSS.setAttribute('href', "" + this.stylesheetPath + "glide.android.css");
      head.appendChild(androidCSS);
      styleSheets = document.styleSheets;
      for (_i = 0, _len = styleSheets.length; _i < _len; _i++) {
        styleSheet = styleSheets[_i];
        if (((_ref = styleSheet.href) != null ? _ref.indexOf("glide.css") : void 0) !== -1) {
          styleSheet.disabled = true;
        }
      }
      document.body.className = "old-android";
      return this.transitionAnimation = false;
    };

    Glide.prototype.slide = function(targetPage, currentPage) {
      var axis, screenWidth,
        _this = this;
      targetPage.style.display = "-webkit-box";
      screenWidth = window.innerWidth + 'px';
      axis = "X";
      if (this.back) {
        this.translate(currentPage, axis, "0%");
        this.translate(targetPage, axis, "-" + screenWidth, "0ms");
        setTimeout(function() {
          return _this.translate(currentPage, axis, "100%");
        }, 0);
      } else {
        this.translate(currentPage, axis, "0%");
        this.translate(targetPage, axis, screenWidth, "0ms");
        setTimeout(function() {
          return _this.translate(currentPage, axis, "-100%");
        }, 0);
      }
      return setTimeout(function() {
        _this.translate(targetPage, axis, "0%");
        return _this.back = false;
      }, 0);
    };

    Glide.prototype.slideUp = function(targetPage, currentPage) {
      var axis, screenHeight,
        _this = this;
      targetPage.style.display = "-webkit-box";
      screenHeight = window.innerHeight + 'px';
      axis = "Y";
      if (this.back) {
        setTimeout(function() {
          return _this.translate(currentPage, axis, screenHeight);
        }, 0);
      } else {
        targetPage.style.zIndex = "1000";
        this.translate(targetPage, axis, screenHeight, "0ms");
        setTimeout(function() {
          return _this.translate(targetPage, axis, "0%");
        }, 0);
      }
      return this.back = false;
    };

    Glide.prototype.translate = function(page, axis, distance, duration) {
      if (duration == null) {
        duration = this.speed + "s";
      }
      page.style.webkitTransition = "" + duration + " cubic-bezier(.10, .10, .25, .90)";
      return page.style.webkitTransform = "translate" + axis + "(" + distance + ")";
    };

    Glide.prototype.displayPage = function(targetPage, currentPage) {
      this.isTransitioning = false;
      targetPage.style.display = "-webkit-box";
      currentPage.style.display = "none";
      if (this.isAndroid() && this.versionMatches(/2\.3/) && this.back === false) {
        window.scrollTo(0, 0);
      }
      return this.back = false;
    };

    Glide.prototype.hideTransitionedPage = function(e) {
      var previousPage,
        _this = this;
      this.isTransitioning = false;
      previousPage = document.querySelector('.previousPage');
      if (previousPage) {
        setTimeout(function() {
          _this.removeClass(previousPage, 'previousPage');
          return previousPage.style.display = "none";
        }, 0);
      }
      if (this.isAndroid() && this.versionMatches(/2\.3/)) {
        this.currentPage.style.webkitTransform = "none";
      }
      return document.body.removeEventListener("webkitTransitionEnd", this.hideTransitionedPage, false);
    };

    Glide.prototype.hasClass = function(el, cssClass) {
      if ((el != null) && el.className !== '') {
        return el.className && new RegExp("(^|\\s)" + cssClass + "(\\s|$)").test(el.className);
      } else {
        return false;
      }
    };

    Glide.prototype.addClass = function(ele, cls) {
      if (!this.hasClass(ele, cls)) {
        return ele.className += " " + cls;
      }
    };

    Glide.prototype.removeClass = function(ele, cls) {
      var reg;
      if (this.hasClass(ele, cls)) {
        reg = new RegExp("(\\s|^)" + cls + "(\\s|$)");
        if (ele.className != null) {
          return ele.className = ele.className.replace(reg, " ");
        }
      }
    };

    Glide.prototype.isTouch = function() {
      if (typeof this.touch === "undefined") {
        if (!!('ontouchstart' in window)) {
          return this.touch = true;
        } else {
          return this.touch = false;
        }
      } else {
        return this.touch;
      }
    };

    Glide.prototype.isIOS = function() {
      return this.os.ios;
    };

    Glide.prototype.isAndroid = function() {
      return this.os.android;
    };

    Glide.prototype.osVersion = function() {
      return this.os.version.toString();
    };

    Glide.prototype.versionMatches = function(regex) {
      return !!this.os.version.toString().match(regex);
    };

    Glide.prototype.handleEvents = function(e) {
      if (this.isTouch()) {
        switch (e.type) {
          case 'touchstart':
            return this.onTouchStart(e);
          case 'touchmove':
            return this.removePressed;
          case 'touchend':
            return this.removePressed;
        }
      } else {
        switch (e.type) {
          case 'mousedown':
            return this.onTouchStart(e);
        }
      }
    };

    Glide.prototype.onTouchStart = function(e) {
      var _ref;
      if (this.isTouch()) {
        if (this.isAndroid()) {
          this.theTarget = document.elementFromPoint(e.changedTouches[0].screenX, e.changedTouches[0].screenY);
        } else {
          this.theTarget = document.elementFromPoint(e.targetTouches[0].clientX, e.targetTouches[0].clientY);
        }
      } else {
        this.theTarget = document.elementFromPoint(e.clientX, e.clientY);
      }
      if (((_ref = this.theTarget) != null ? _ref.nodeName : void 0) && this.theTarget.nodeName.toLowerCase() !== 'a' && (this.theTarget.nodeType === 3 || this.theTarget.nodeType === 1)) {
        this.oldTarget = this.theTarget;
        this.theTarget = $(this.theTarget).closest('a')[0];
      }
      if (this.theTarget === null || typeof this.theTarget === 'undefined') {
        return;
      }
      this.addClass(this.theTarget, 'pressed');
      this.theTarget.addEventListener('touchmove', this.removePressed, false);
      this.theTarget.addEventListener('mouseout', this.removePressed, false);
      this.theTarget.addEventListener('touchend', this.removePressed, false);
      this.theTarget.addEventListener('mouseup', this.removePressed, false);
      return this.theTarget.addEventListener('touchcancel', this.removePressed, false);
    };

    Glide.prototype.removePressed = function(e) {
      return this.removeClass(this.theTarget, 'pressed');
    };

    return Glide;

  })();

  window.Glide = Glide;

}).call(this);
