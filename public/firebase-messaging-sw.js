importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBZegwZmiUsddDY1-EcB27NYwuvxobkgx8",
  authDomain: "jodohku-61096.firebaseapp.com",
  projectId: "jodohku-61096",
  storageBucket: "jodohku-61096.firebasestorage.app",
  messagingSenderId: "982535553679",
  appId: "1:982535553679:web:b7146ace7d99475ce126fa",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/assets/icon_jdk.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
