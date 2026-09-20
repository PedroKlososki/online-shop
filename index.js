import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import bcrypt from "bcrypt";
import passport from "passport";
import { Strategy } from "passport-local";
import session from "express-session";
import env from "dotenv";

env.config({ quiet: true });

const app = express();
const port = process.env.PORT;
const saltRounds = 10;

app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: true,
    cookie: {
        maxAge: 1000 * 60 * 30,
    }
  })
);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

app.use(passport.initialize());
app.use(passport.session());

const db = new pg.Client({
    user: process.env.PG_USER,
    host: process.env.PG_HOST,
    database: process.env.PG_DATABASE,
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT,
});

db.connect();

app.get("/", async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const limit = 18;
    const range = ( page - 1 ) * limit;

    if (!req.session.random) {
        req.session.random = Math.random().toString(36).substring(2, 8);
    }

    if (page == 1 && req.session.random){
        req.session.random = Math.random().toString(36).substring(2, 8);
    }

    try {
        
        const products = await db.query(
            "SELECT * FROM products ORDER BY hashtext(id_product::text || $1) LIMIT $2 OFFSET $3",
            [req.session.random, limit, range]
        );

        for (const item of products.rows){
            const image = await db.query("SELECT img FROM product_images WHERE id_product = $1", [item.id_product]);
            const imageBase64 = image.rows[0].img.toString('base64');
            const url = `data:image/jpeg;base64,${imageBase64}`;
            item.img = url;
        }

        const productsLength = await db.query("SELECT COUNT(*) FROM products");
        

        res.render("index.ejs", {
            data: products.rows,
            length: productsLength,
            pages: Math.ceil(productsLength.rows[0].count/limit),
            currentPage: page,
            user: req.user || {
                logged: false
            }
        })
    } catch (error) {
        console.log(error);
    }
});

app.get("/login", (req, res) => {
    res.render("login.ejs", { method: "login"});
});

app.get("/signin", (req, res) => {
    res.render("login.ejs", { method: "signin"});
});

// login verification
passport.use( new Strategy(async function verify(username, password, cb) {
    try {
        const result = await db.query("SELECT * FROM users WHERE email = $1", [username]);

        if (result.rows.length > 0){
            const user = result.rows[0]; 
            const hashedPassword = user.password;
            bcrypt.compare(password, hashedPassword, (err, valid) => {
                if (err){
                    return cb(err, false);
                } else {
                    if (valid) {
                        user.logged = true;
                        return cb(null, user);
                    } else {
                        return cb("Incorrect credentials");
                    }
                }
            });
        } else {
            return cb("Incorrect credentials");
        }
    } catch (error) {
        console.log(error);
    }
}))

passport.serializeUser((user, cb) => {
    cb(null, user);
});

passport.deserializeUser((user, cb) => {
    cb(null, user);
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});