const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.sendNotification = functions.database.ref("/message/{userId}/{pushId}").onWrite(event => {
      const snapshot = event.data;
      const userId = event.params.userId;
      if (snapshot.previous.val()) {
        return;
      }
      if (snapshot.val().name != "ADMIN") {
        return;
      }
      const text = snapshot.val().text;
      const payload = {
        notification: {
          title: `New message by ${snapshot.val().name}`,
          body: text
            ? text.length <= 100 ? text : text.substring(0, 97) + "..."
            : ""
        }
      };
      return admin
        .database()
        .ref(`data/${userId}/customerData`)
        .once('value')
        .then(data => {
          console.log('inside', data.val().notificationKey);
          if (data.val().notificationKey) {
            return admin.messaging().sendToDevice(data.val().notificationKey, payload);
          }
        });
    });
