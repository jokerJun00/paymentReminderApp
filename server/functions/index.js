// stripe
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const stripe = require("stripe")(firebase.config().stripe.testkey);

admin.initializeApp();

const generateResponse function (intent) {
  switch (intent.status) {
    case "required_action":
      return {
        clientSecret: intent.clientSecret,
        requiresAction: true,
        status: intent.status,
      };
    case "required_payment_method":
      return {
        error: "Your card was denied, please provide a payment method"
      };
    case "succeeded":
      console.log("Payment succeeded");
      return {
        clientSecret: intent.clientSecret,
        status: intent.status,
      };
  }
  return { error: "Failed" };
};

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
// exports.myFunction = functions.firestore
//   .document("payment/{userId}")
//   .onCreate((snapshot, context) => {
//     // Return this function's promise, so this ensures the firebase function
//     // will keep running, until the notification is scheduled.
//     return admin.messaging().sendToTopic("chat", {
//       // Sending a notification message.
//       notification: {
//         title: snapshot.data()["username"],
//         body: snapshot.data()["text"],
//         clickAction: "FLUTTER_NOTIFICATION_CLICK",
//       },
//     });
//   });

exports.StripePayEndpointMethodId = 
onRequest(async (req, res) => { 
  const { paymentMethodId, amount, currency, useStripeSdk, } = req.body;
  const paymentAmount = amount;

  try {
    if (paymentMethodId) {
      // Create new payment Intent
      const params = {
        amount: paymentAmount,
        confirm: true,
        confirmation_method: "manual",
        currency: currency,
        payment_method: paymentMethodId,
        user_stripe_sdk: useStripeSdk,
      };

      const intent = await stripe.paymentIntents.create(params);
      console.log(`Intent: ${intent}`);
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  } catch (e) {
    return res.send({ error: e.message });
  }
});

exports.StripePayEndpointIntentId = 
onRequest(async (req, res) => {
  const { paymentIntentId } = req.body;

  try {
    if (paymentIntentId) {
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      return res.send(generateResponse(intent));
    }
  } catch (e) {
    return res.send({ error: e.message });
  }
});
