const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// stripe
const functions = require("firebase-functions");
const stripe = require("stripe")(firebase.config().stripe.testkey);

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
