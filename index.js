import express from "express";
import bodyParser from "body-parser";
import env from "dotenv";

env.config({ quiet: true });

const app = express();
const port = process.env.PORT;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});