/**
class EE {
  constructor() {
    this.events = {};
  }

  on(name, callback) {
    let callbacks = this.events[name] || [];
    callbacks.push(callback);
    this.events[name] = callbacks;
  }

  emit(name, ...params) {
    setTimeout(() => {
      let callbacks = this.events[name] || [];
      callbacks.forEach((callback) => {
        callback.apply(null, params);
      });

      let wildcards = this.events['*'] || [];
      wildcards.forEach((callback) => {
        callback.call(null, { name, params });
      });
    }, 0);
  }
}

class Socket extends EE {
  static defaultURL() {
    return `${location.protocol.replace('http', 'ws')}//${location.host}`;
  }

  constructor(url = Socket.defaultURL()) {
    super();

    this.ws = new WebSocket(url);

    this.ws.onopen = (e) => {
      setTimeout(() => {
        super.emit.call(this, e.type, e);
      }, 100);
    }

    this.ws.onclose = (e) => {
      super.emit.call(this, e.type, e);
    }

    this.ws.onerror = (e) => {
      super.emit.call(this, e.type, e);
    }

    this.ws.onmessage = (e) => {
      let { name, message } = JSON.parse(e.data);
      super.emit.call(this, name, message);
    }
  }

  send(name, message) {
    let data = JSON.stringify({ name, message });
    this.ws.send(data);
  }
}
**/
'use strict';

var _get = function get(_x2, _x3, _x4) { var _again = true; _function: while (_again) { var object = _x2, property = _x3, receiver = _x4; desc = parent = getter = undefined; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x2 = parent; _x3 = property; _x4 = receiver; _again = true; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var EE = (function () {
  function EE() {
    _classCallCheck(this, EE);

    this.events = {};
  }

  _createClass(EE, [{
    key: 'on',
    value: function on(name, callback) {
      var callbacks = this.events[name] || [];
      callbacks.push(callback);
      this.events[name] = callbacks;
    }
  }, {
    key: 'emit',
    value: function emit(name) {
      var _this = this;

      for (var _len = arguments.length, params = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        params[_key - 1] = arguments[_key];
      }

      setTimeout(function () {
        var callbacks = _this.events[name] || [];
        callbacks.forEach(function (callback) {
          callback.apply(null, params);
        });

        var wildcards = _this.events['*'] || [];
        wildcards.forEach(function (callback) {
          callback.call(null, { name: name, params: params });
        });
      }, 0);
    }
  }]);

  return EE;
})();

var Socket = (function (_EE) {
  _inherits(Socket, _EE);

  _createClass(Socket, null, [{
    key: 'defaultURL',
    value: function defaultURL() {
      return location.protocol.replace('http', 'ws') + '//' + location.host;
    }
  }]);

  function Socket() {
    var _this2 = this;

    var url = arguments.length <= 0 || arguments[0] === undefined ? Socket.defaultURL() : arguments[0];

    _classCallCheck(this, Socket);

    _get(Object.getPrototypeOf(Socket.prototype), 'constructor', this).call(this);

    this.ws = new WebSocket(url);

    this.ws.onopen = function (e) {
      setTimeout(function () {
        _get(Object.getPrototypeOf(Socket.prototype), 'emit', _this2).call(_this2, e.type, e);
      }, 100);
    };

    this.ws.onclose = function (e) {
      _get(Object.getPrototypeOf(Socket.prototype), 'emit', _this2).call(_this2, e.type, e);
    };

    this.ws.onerror = function (e) {
      _get(Object.getPrototypeOf(Socket.prototype), 'emit', _this2).call(_this2, e.type, e);
    };

    this.ws.onmessage = function (e) {
      var _JSON$parse = JSON.parse(e.data);

      var name = _JSON$parse.name;
      var message = _JSON$parse.message;

      _get(Object.getPrototypeOf(Socket.prototype), 'emit', _this2).call(_this2, name, message);
    };
  }

  _createClass(Socket, [{
    key: 'send',
    value: function send(name, message) {
      var data = JSON.stringify({ name: name, message: message });
      this.ws.send(data);
    }
  }]);

  return Socket;
})(EE);

