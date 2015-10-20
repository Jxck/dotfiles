if ('ServiceWorkerGlobalScope' in self && self instanceof ServiceWorkerGlobalScope) {
  ['install', 'activate', 'beforeevicted', 'evicted', 'fetch', 'message', 'push'].forEach((e) => {
    self.addEventListener(e, (ev) => {
      console.log(e, ev);
    });
  });

  self.addEventListener('install', (ev) => {
    ev.waitUntil(self.skipWaiting());
  });

  self.addEventListener('activate', (ev) => {
    ev.waitUntil(self.clients.claim());
    console.log('claimed');
  });
}

if (typeof window !== 'undefined') {
  if (!('serviceWorker' in navigator)) {
    alert('service worker not supported');
  }

  navigator.serviceWorker.getRegistration().then((worker) => {
    console.log('getRegistration', worker);
  }).catch(console.error.bind(console));

  navigator.serviceWorker.register('worker.js', { scope: '.' }).then((worker) => {
    console.log('register success', worker);

    // return navigator.serviceWorker.ready;
    return new Promise((resolve) => {
      // controllerchange after claimed
      navigator.serviceWorker.addEventListener('controllerchange', resolve);
    });
  }).then(() => {
    console.log('controlled?', navigator.serviceWorker.controller);
  }).catch(console.error.bind(console));
}
