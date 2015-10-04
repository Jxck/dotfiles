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

  emit(name, message) {
    let data = JSON.stringify({ name, message });
    this.ws.send(data);
  }
}
