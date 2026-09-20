CREATE TABLE users (
	id_user SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	email TEXT NOT NULL UNIQUE,
	pass TEXT NOT NULL
);

CREATE TABLE products (
	id_product SERIAL PRIMARY KEY,
	product_name TEXT NOT NULL,
	description TEXT,
	price MONEY NOT NULL,
	number_sales INT,
	stock INT
);

CREATE TABLE car_products (
	id_car SERIAL PRIMARY KEY,
	id_user INT NOT NULL,
	id_product INT NOT NULL,
	
	CONSTRAINT fk_users
		FOREIGN KEY (id_user)
		REFERENCES users(id_user)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT fk_product
		FOREIGN KEY (id_product)
		REFERENCES products(id_product)
		ON DELETE CASCADE
		ON UPDATE CASCADE
		
);

CREATE TABLE account_statement (
	id_AccStat SERIAL PRIMARY KEY,
	id_user INT NOT NULL,
	id_product INT NOT NULL,
	purchase_date DATE,

	CONSTRAINT fk_users
		FOREIGN KEY (id_user)
		REFERENCES users(id_user)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT fk_product
		FOREIGN KEY (id_product)
		REFERENCES products(id_product)
		ON DELETE CASCADE
		ON UPDATE CASCADE

);

CREATE TABLE product_images (
	id_img SERIAL PRIMARY KEY,
	id_product INT NOT NULL,
	img BYTEA,

	CONSTRAINT fk_product
		FOREIGN KEY (id_product)
		REFERENCES products(id_product)
		ON DELETE CASCADE
		ON UPDATE CASCADE
		
);

CREATE TABLE stars (
	id_star SERIAL PRIMARY KEY,
	id_user INT,
	id_product INT NOT NULL,
	star_value INT NOT NULL
		CONSTRAINT numOfStars 
		CHECK (star_value between 0 AND 5),
	
	CONSTRAINT fk_users
		FOREIGN KEY (id_user)
		REFERENCES users(id_user)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT fk_product
		FOREIGN KEY (id_product)
		REFERENCES products(id_product)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE review (
	id_review SERIAL PRIMARY KEY,
	id_star INT NOT NULL,
	id_user INT,
	id_product INT NOT NULL,
	review_content TEXT NOT NULL,

	CONSTRAINT fk_star
		FOREIGN KEY (id_star)
		REFERENCES stars(id_star),
		
	CONSTRAINT fk_users
		FOREIGN KEY (id_user)
		REFERENCES users(id_user)
		ON DELETE SET NULL
		ON UPDATE CASCADE,

	CONSTRAINT fk_product
		FOREIGN KEY (id_product)
		REFERENCES products(id_product)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);