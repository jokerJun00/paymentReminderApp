const functions = require("firebase-functions");
const admin = require("firebase-admin");
const config = functions.config;
const stripe = require("stripe")(process.env.STRIPETESTKEY);

admin.initializeApp();

// stripe pay to 3rd parties
// https://stripe.com/docs/connect/collect-then-transfer-guide

