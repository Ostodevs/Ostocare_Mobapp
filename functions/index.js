const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");
const serviceAccount = require("./serviceAccountKeyAdminSDK.json");

// Initialize Firebase Admin
try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} catch (e) {
  console.error("Error initializing Firebase Admin SDK", e);
}

// Set SendGrid API Key
sgMail.setApiKey(functions.config().sendgrid.key);

// Firestore trigger: When a password reset doc is created, send email
exports.sendResetCode = functions.firestore
  .document("password_resets/{userId}")
  .onCreate(async (snap, context) => {
    const resetRequest = snap.data();
    const email = resetRequest.email;
    const code = resetRequest.code;

    const msg = {
      to: email,
      from: "your_email@example.com", // <- Replace with your verified sender
      subject: "Password Reset Code",
      text: `Your password reset code is: ${code}`,
      html: `<strong>Your password reset code is: ${code}</strong>`,
    };

    try {
      await sgMail.send(msg);
      console.log("Email sent to", email);
    } catch (error) {
      console.error("Failed to send email:", error.toString());
    }
  });
