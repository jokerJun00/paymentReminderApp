const functions = require("firebase-functions");
const admin = require("firebase-admin");
const config = functions.config;
const stripe = require("stripe")(process.env.STRIPETESTKEY);

admin.initializeApp();

// push notification functions
exports.setPaymentReminder = functions.firestore
  .document("Payments/{paymentId}")
  .onCreate((snapshot, context) =>  {
    // TODO:: set the payment reminder notification period

    return admin.messaging().sendToTopic("setPaymentReminder", {
      notification: {
        title: snapshot.data()["name"] + "reminder set",
        body: "We will remind your payment " + snapshot.data()["notification_period"] + " days before every " + snapshot.data()["payment_date"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK"
      },
    });
  });

exports.resetPaymentReminder = functions.firestore
  .document("Payments/{paymentId}")
  .onUpdate((snapshot, context) =>  {
    const newData = snapshot.after.data();
    const oldData = snapshot.before.data();

    // check if the notification period has change or not
    if (newData.notification_period !== oldData.notification_period) {
      // TODO:: change the payment reminder notification period

      // notify user notification period has change
      return admin.messaging().sendToTopic("resetPaymentReminder", {
        notification: {
          title: snapshot.data()["name"] + "reminder set",
          body: "We will remind your payment " + snapshot.data()["notification_period"] + " days before every " + snapshot.data()["payment_date"],
          clickAction: "FLUTTER_NOTIFICATION_CLICK"
        },
      });
    }
    return null;
  });

// schedule functions
// https://firebase.google.com/docs/functions/schedule-functions?gen=1st
// https://stackoverflow.com/questions/66680239/flutter-how-can-i-create-repeating-push-notifications

// stripe pay to 3rd parties
// https://stripe.com/docs/connect/collect-then-transfer-guide

