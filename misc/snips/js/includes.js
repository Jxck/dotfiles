Object.defineProperty(Array.prototype, 'includes', {
  enumerable: false,
  configurable: true,
  writable: true,
  value: function(x) {
    return this.indexOf(x) !== -1;
  },
});
