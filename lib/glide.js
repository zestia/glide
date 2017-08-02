/* global $, document, window */

class Glide {
  static init() {
    this.prototype.hooks = {
      'before:to': [],
      'after:to': [],
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
  constructor(options = {}) {
    this.to = this.to.bind(this);
    this.hideTransitionedPage = this.hideTransitionedPage.bind(this);
    this.isTouch = this.isTouch.bind(this);
    this.handleEvents = this.handleEvents.bind(this);
    this.onTouchStart = this.onTouchStart.bind(this);
    this.removePressed = this.removePressed.bind(this);

    Object.keys(options).forEach((key) => {
      const value = options[key];
      this[key] = value;
    });

    this.detectUserAgent();

    Object.keys(this.plugins).forEach((key) => {
      const Plugin = this.plugins[key];
      this.plugins[key] = new Plugin(this);
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
  detectUserAgent() {
    const { userAgent } = window.navigator;

    this.os = {
      android: !!userAgent.match(/(Android)\s+([\d.]+)/) || !!userAgent.match(/Silk-Accelerated/),
    };

    const match = userAgent.match(/((iPad).*OS|(iPhone\sOS))\s([\d_]+)/);

    if (match) {
      this.os.ios = true;
      this.os.version = match[4].replace(/_/g, '.');
      this.os.full = `iOS ${this.os.version}`;
    }

    if (this.os.android) {
      const result = userAgent.match(/Android (\d+(?:\.\d+)+)/);
      this.os.version = result[1];
      this.os.full = `Android ${this.os.version}`;
    }
  }

  // Public: Go to a specific page.
  //
  // targetPage - A String of the element ID or existing element.
  // animate    - A Boolean of whether to animate the transition.
  //
  // Returns nothing.
  to(target, animate = true) {
    let targetPage = target;
    let transitionType;

    const oldAnimate = this.transitionAnimation;

    this.transitionAnimation = animate;

    this.hooks['before:to'].forEach(hook => hook());

    if (typeof targetPage === 'string') {
      this.targetPage = document.querySelector(targetPage);
    } else if (targetPage) {
      this.targetPage = targetPage;
    }

    if ((this.targetPage === this.currentPage) || this.isTransitioning) {
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
    const { currentPage } = this;

    this.currentPage = this.targetPage;

    currentPage.classList.add('previousPage');
    document.body.addEventListener('webkitTransitionEnd', this.hideTransitionedPage, false);

    setTimeout(() => {
      if (transitionType !== 'none') {
        this[transitionType](targetPage, currentPage);
      } else {
        this.displayPage(targetPage, currentPage);
      }

      this.transitionAnimation = oldAnimate;
    }, 10);

    this.hooks['after:to'].forEach(hook => hook());
  }

  // Private: Perform a slide transition.
  //
  // Returns nothing.
  slide(targetPage, currentPage) {
    targetPage.style.display = '-webkit-box';

    const screenWidth = `${window.innerWidth}px`;
    const axis = 'X';

    if (this.back) {
      this.translate(currentPage, axis, '0%');
      this.translate(targetPage, axis, `-${screenWidth}`, '0ms');

      setTimeout(() => {
        this.translate(currentPage, axis, '100%');
      }, 0);
    } else {
      this.translate(currentPage, axis, '0%');
      this.translate(targetPage, axis, screenWidth, '0ms');

      setTimeout(() => {
        this.translate(currentPage, axis, '-100%');
      }, 0);
    }

    setTimeout(() => {
      this.translate(targetPage, axis, '0%');
      this.back = false;
    }, 0);
  }

  // Private: Perform a slide from bottom transition.
  //
  // Returns nothing.
  slideUp(targetPage, currentPage) {
    targetPage.style.display = '-webkit-box';
    const screenHeight = `${window.innerHeight}px`;
    const axis = 'Y';

    if (this.back) {
      setTimeout(() => {
        this.translate(currentPage, axis, screenHeight);
      }, 0);
    } else {
      targetPage.style.zIndex = '1000';

      this.translate(targetPage, axis, screenHeight, '0ms');

      setTimeout(() => {
        this.translate(targetPage, axis, '0%');
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
  translate(page, axis, distance, duration = '0.3s') {
    page.style.webkitTransition = `${duration} cubic-bezier(.10, .10, .25, .90)`;
    page.style.webkitTransform = `translate${axis}(${distance})`;
  }

  // Private: Show the current page without transition
  //
  // Returns nothing.
  displayPage(targetPage, currentPage) {
    this.isTransitioning = false;
    targetPage.style.display = '-webkit-box';
    currentPage.classList.add('previousPage');
    this.back = false;
    this.hideTransitionedPage();
  }

  // Private: Hide DOM that has just been transitioned
  //
  // Returns nothing
  hideTransitionedPage() {
    this.isTransitioning = false;
    const previousPage = document.querySelector('.previousPage');

    if (previousPage) {
      setTimeout(() => {
        previousPage.classList.remove('previousPage');
        previousPage.style.display = 'none';
        this.translate(previousPage, 'X', '0%', '0ms');
      }, 0);
    }

    document.body.removeEventListener('webkitTransitionEnd', this.hideTransitionedPage, false);
  }

  // Private: Is the device touch enabled.
  //
  // Returns True if the device is touch enabled, else False.
  isTouch() {
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
  isIOS() {
    return this.os.ios;
  }

  // Public: Is the device running Android
  //
  // Returns True if the device is running Android, else False.
  isAndroid() {
    return this.os.android;
  }

  // Public: Get the version of the OS running on the device.
  //
  // Returns a String of the OS version.
  osVersion() {
    return this.os.version.toString();
  }

  // Public: Test whether the OS version matches the specified version.
  //
  // Returns: True if the version matches, else False.
  versionMatches(regex) {
    return !!this.os.version.toString().match(regex);
  }

  // Private: Handle touch events to apply pressed class to anchors
  //
  // Returns nothing.
  handleEvents(e) {
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

  onTouchStart(e) {
    if (this.isTouch()) {
      if (this.isAndroid()) {
        this.theTarget = document.elementFromPoint(
          e.changedTouches[0].screenX,
          e.changedTouches[0].screenY,
        );
      } else {
        this.theTarget = document.elementFromPoint(
          e.targetTouches[0].clientX,
          e.targetTouches[0].clientY,
        );
      }
    } else {
      this.theTarget = document.elementFromPoint(e.clientX, e.clientY);
    }

    if ((this.theTarget && this.theTarget.nodeName) && (this.theTarget.nodeName.toLowerCase() !== 'a') && ((this.theTarget.nodeType === 3) || (this.theTarget.nodeType === 1))) {
      this.oldTarget = this.theTarget;
      this.theTarget = $(this.theTarget).closest('a')[0];
    }

    if ((this.theTarget === null) || (typeof this.theTarget === 'undefined')) { return; }

    this.theTarget.classList.add('pressed');

    this.theTarget.addEventListener('touchmove', this.removePressed, false);
    this.theTarget.addEventListener('mouseout', this.removePressed, false);
    this.theTarget.addEventListener('touchend', this.removePressed, false);
    this.theTarget.addEventListener('mouseup', this.removePressed, false);
    this.theTarget.addEventListener('touchcancel', this.removePressed, false);
  }

  removePressed() {
    const elements = document.getElementsByClassName('pressed');
    [].slice.call(elements).forEach(element => element.classList.remove('pressed'));
  }
}

Glide.init();
window.Glide = Glide;
