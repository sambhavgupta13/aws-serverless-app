const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const app = express();
const staticPath = path.join(`${__dirname}`, "../frontend/dist");
app.use(bodyParser.json({ limit: "1mb" }));
app.use(express.json());
app.use(express.static(staticPath));

app.use(function (req, res) {
    res.sendFile(path.join(`${__dirname}`, `../frontend/dist/mosaic/index.html`));
  });



  app.listen(7000, () => {
    console.log(`Listening to port ${7000}....`);
  });
  