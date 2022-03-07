const functions = require('firebase-functions');
const express = require('express');
const cors = require('cors');

const app = express();
const port = 4242;
const stripeRouter = require('./router/stripe');
const stripe = require('stripe');
const bodyParser = require('body-parser');

app.use(cors());
app.use(express.json());

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.get('/', function (req, res) {
    return res.send("OK!!!");
});


stripeRouter.handleRouter(app);

exports.api = functions.https.onRequest(app);