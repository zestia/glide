/* global document, window */

class GlideMenu {
  constructor(glide) {
    this.close = this.close.bind(this);
    this.toggle = this.toggle.bind(this);

    this.glide = glide;
    this.animate = true;
    this.menu = document.querySelector('#main-menu');

    if (!this.glide.hooks['before:to']) {
      this.glide.hooks['before:to'] = [];
    }

    this.glide.hooks['before:to'].push(() => this.close());
  }

  close() {
    if (this.menuOpen === true) {
      this.menu.style.display = 'none';
      this.menuOpen = false;
    }
  }

  toggle() {
    if (this.menuOpen) {
      if (this.animate) {
        setTimeout(() => {
          this.glide.translate(this.menu, 'X', '-110%', '0.3s');
        }, 10);

        setTimeout(() => {
          this.menu.style.display = 'none';
        }, 300);
      } else {
        this.menu.style.display = 'none';
      }

      this.menuOpen = false;
    } else {
      if (this.animate) {
        this.glide.translate(this.menu, 'X', '-110%', '0ms');

        setTimeout(() => {
          this.glide.translate(this.menu, 'X', '0%', '0.3s');
        }, 50);

        this.menu.style.display = 'block';
      } else {
        this.menu.style.display = 'block';
      }

      this.menuOpen = true;
    }
  }
}

window.GlideMenu = GlideMenu;
