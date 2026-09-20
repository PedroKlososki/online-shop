CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    pass TEXT NOT NULL
);

CREATE TABLE seller (
    id_seller SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    pass TEXT NOT NULL
);

CREATE TABLE products (
    id_product SERIAL PRIMARY KEY,
    id_seller INT NOT NULL,
    product_name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    number_sales INT DEFAULT 0,
    stock INT DEFAULT 0,

    CONSTRAINT fk_product_seller
        FOREIGN KEY (id_seller)
        REFERENCES seller(id_seller)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_stock
        CHECK (stock >= 0),

    CONSTRAINT chk_number_sales
        CHECK (number_sales >= 0)
);

CREATE TABLE cart_products (
    id_cart SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    id_product INT NOT NULL,

    CONSTRAINT fk_cart_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_cart_product
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE orders (
    id_order SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT fk_order_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE order_items (
    id_order_item SERIAL PRIMARY KEY,
    id_order INT NOT NULL,
    id_product INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (id_order)
        REFERENCES orders(id_order)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_order_item_product
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT uq_order_product
        UNIQUE (id_order, id_product)
);

CREATE TABLE account_statement (
    id_acc_stat SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    id_product INT NOT NULL,
    purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT fk_account_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_account_product
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE product_images (
    id_img SERIAL PRIMARY KEY,
    id_product INT NOT NULL,
    img BYTEA NOT NULL,

    CONSTRAINT fk_product_image
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE stars_product (
    id_star_product SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    id_product INT NOT NULL,
    star_value INT NOT NULL,

    CONSTRAINT chk_product_stars
        CHECK (star_value BETWEEN 1 AND 5),

    CONSTRAINT fk_product_star_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_product_star_product
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_user_product_star
        UNIQUE (id_user, id_product)
);

CREATE TABLE stars_seller (
    id_star_seller SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    id_seller INT NOT NULL,
    star_value INT NOT NULL,

    CONSTRAINT chk_seller_stars
        CHECK (star_value BETWEEN 1 AND 5),

    CONSTRAINT fk_seller_star_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_seller_star_seller
        FOREIGN KEY (id_seller)
        REFERENCES seller(id_seller)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_user_seller_star
        UNIQUE (id_user, id_seller)
);

CREATE TABLE review (
    id_review SERIAL PRIMARY KEY,
    id_star_product INT NOT NULL,
    id_user INT,
    id_product INT NOT NULL,
    review_content TEXT NOT NULL,

    CONSTRAINT fk_review_star
        FOREIGN KEY (id_star_product)
        REFERENCES stars_product(id_star_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_review_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_review_product
        FOREIGN KEY (id_product)
        REFERENCES products(id_product)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);