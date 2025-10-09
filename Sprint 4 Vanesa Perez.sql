-- SPRINT 4
-- Nivell 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

-- PAS 1 - CREEM LA BASE DE DADES: 
CREATE DATABASE ventas;
USE ventas;

-- per instal·la tota la base de dades i modelar_la he seguit els pasos indicat a l'article https://www.delftstack.com/es/howto/mysql/mysql-import-csv/ 
-- que entra dintre del temari del curs que heu proporcionat.

-- PAS 2 - Crear les taules: 
	-- Al revisar els arxius que s'han de carregar hem vist que hi han dues taules de users (americans_users i european users) amb els mateixos camps. 
    -- Es pot pujar cada taula per separat i desprès fer una UNION ALL o bé crear directament la taula users i al carregar dades de les taules americans_users i european users 
    -- o farem directament a users :

CREATE TABLE IF NOT EXISTS users (
	id VARCHAR(255) NULL,
	name VARCHAR(255) NULL,
	surname VARCHAR(255) NULL,
	phone VARCHAR(255) NULL,
	email VARCHAR(255) NULL,
	birth_date VARCHAR(255) NULL,
	country VARCHAR(255) NULL,
	city VARCHAR(255) NULL,
	postal_code VARCHAR(255) NULL,
	address VARCHAR(255) NULL
);



CREATE TABLE IF NOT EXISTS companies (
	company_id VARCHAR(255) NULL,
	company_name VARCHAR(255) NULL,
	phone VARCHAR(255) NULL,
	email VARCHAR(255) NULL,
	country VARCHAR(255) NULL,
	website VARCHAR(255) NULL
);

CREATE TABLE IF NOT EXISTS credit_cards (
	id VARCHAR(255) NULL,
	user_id VARCHAR(255) NULL,
	iban VARCHAR(255) NULL,
	pan VARCHAR(255) NULL,
	pin VARCHAR(255) NULL,
	cvv VARCHAR(255) NULL,
	track1 VARCHAR(255) NULL,
    track2 VARCHAR(255) NULL,
	expiring_date VARCHAR(255) NULL
);


CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(255) NULL,
	card_id VARCHAR(255) NULL,
	business_id VARCHAR(255) NULL,
	timestamp VARCHAR(255) NULL,
	amount VARCHAR(255) NULL,
	declined VARCHAR(255) NULL,
    product_ids VARCHAR(255) NULL,
	user_id VARCHAR(255) NULL, 
    lat VARCHAR(255) NULL, 
    longitude VARCHAR(255) NULL
);


-- PAS 3 -- ES CARREGUEN LES DADES: 
-- en el moment de la càrrega de dades van haver problemes i vaig haver de fer les modificacions pertinents al fitxer my.ini sobre aquestes variables:
SHOW VARIABLES LIKE "secure_file_priv";
SHOW GLOBAL VARIABLES LIKE "local_infile";


--  fem dues càrregues a la taula users, una desde americans_users i l'altra desde europeans_users:
-- Desde american_users
LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\american_users.csv"
INTO TABLE users 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

-- Desde europeans_users:

LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

-- Taula companies: companies.csv

LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Taula credit_cards: credit_cards.csv

LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv"
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Taula transactions: 
LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv"
INTO TABLE transactions
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- PAS 4 -- DEFINICIÓ DE DADES:
--  Taula users

SELECT * 
FROM users;

SELECT  MAX(CHAR_LENGTH(name)) AS max_length_name,
        MAX(CHAR_LENGTH(surname)) AS max_length_surname,
        MAX(CHAR_LENGTH(phone)) AS max_length_phonename,
        MAX(CHAR_LENGTH(email)) AS max_length_mailname       
FROM users;


-- id
ALTER TABLE users
MODIFY id INT NOT NULL;
-- name
ALTER TABLE users
MODIFY name VARCHAR(50) NULL;
-- surname
ALTER TABLE users
MODIFY surname VARCHAR(50) NULL;
-- phone
ALTER TABLE users
MODIFY phone VARCHAR(20) NULL; 
-- email
ALTER TABLE users
MODIFY email VARCHAR(100) NULL;
-- birth_date
UPDATE users
SET birth_date = STR_TO_DATE(birth_date, '%M %d, %Y');
ALTER TABLE users
MODIFY birth_date DATE NULL;
-- country
ALTER TABLE users
MODIFY country VARCHAR(50) NOT NULL;
-- city
ALTER TABLE users
MODIFY city VARCHAR(50) NOT NULL;
-- CÓDIGO POSTAL
ALTER TABLE users
MODIFY postal_code VARCHAR(10) NULL;


-- TAULA COMPANIES
SELECT * 
FROM companies;

SELECT MAX(CHAR_LENGTH(company_id)) AS max_length_id,
		MAX(CHAR_LENGTH(company_name)) AS max_length_company_name,
        MAX(CHAR_LENGTH(phone)) AS max_length_phone,
        MAX(CHAR_LENGTH(email)) AS max_length_email,
        MAX(CHAR_LENGTH(country)) AS max_length_country,
        MAX(CHAR_LENGTH(website)) AS max_length_website
FROM companies;


-- company_id
ALTER TABLE companies
MODIFY company_id VARCHAR(6) NOT NULL;
-- company_name
ALTER TABLE companies
MODIFY company_name VARCHAR(100) NOT NULL;
-- phone
ALTER TABLE companies
MODIFY phone VARCHAR(20) NOT NULL;
-- email
ALTER TABLE companies
MODIFY email VARCHAR(100) NOT NULL;
-- country
ALTER TABLE companies
MODIFY country VARCHAR(50) NOT NULL;
-- website
ALTER TABLE companies
MODIFY website VARCHAR(100) NOT NULL;

-- TAULA credit_cards
SELECT * 
FROM credit_cards;

SELECT MAX(CHAR_LENGTH(id)) AS max_length_id,
		MAX(CHAR_LENGTH(iban)) AS max_length_iban,
        MAX(CHAR_LENGTH(pan)) AS max_length_pan,
        MAX(CHAR_LENGTH(pin)) AS max_length_pin,
        MAX(CHAR_LENGTH(track1)) AS max_length_track1, 
        MAX(CHAR_LENGTH(track2)) AS max_length_track1
FROM credit_cards;
-- id
ALTER TABLE credit_cards
MODIFY id VARCHAR(8) NOT NULL;
-- User_id: COM SERÀ CLAU FORÀNEA DIRECTAMENT LI ASIGNO EL MATEIX TIPUS DE DADA QUE id de les taules users
ALTER TABLE credit_cards
MODIFY user_id INT NOT NULL;
-- iban
ALTER TABLE credit_cards
MODIFY iban VARCHAR(40) NOT NULL;
-- pan
ALTER TABLE credit_cards
MODIFY pan VARCHAR(25) NOT NULL;
-- pin
ALTER TABLE credit_cards
MODIFY pin SMALLINT NOT NULL;
-- cvv
ALTER TABLE credit_cards
MODIFY cvv SMALLINT NOT NULL;
-- TRACK 1
ALTER TABLE credit_cards
MODIFY track1 VARCHAR(100) NOT NULL;
-- TRACK 2
ALTER TABLE credit_cards
MODIFY track2 VARCHAR(100) NOT NULL;
-- expiring_date
UPDATE credit_cards
SET expiring_date = STR_TO_DATE(expiring_date, "%m/%d/%y");
ALTER TABLE credit_cards
MODIFY expiring_date DATE NULL;

-- TAULA TRANSACTIONS
SELECT * 
FROM transactions;

SELECT MAX(CHAR_LENGTH(id)) AS max_length_id,
		MAX(CHAR_LENGTH(product_ids)) AS max_length_product_ids,
        MAX(CHAR_LENGTH(lat)) AS max_length_lat,
        MAX(CHAR_LENGTH(longitude)) AS max_length_longitude
FROM transactions;

-- id
ALTER TABLE transactions
MODIFY id VARCHAR(36);
-- card_id: al ser FK el tipus de dades serà el mateix que id a credit_cards
ALTER TABLE transactions
MODIFY card_id VARCHAR(8) NOT NULL;
-- business_id: al ser FK el tipus de dades serà el mateix que id a companies
-- timestamp
ALTER TABLE transactions
MODIFY timestamp TIMESTAMP;
-- amount
ALTER TABLE transactions
MODIFY amount FLOAT NOT NULL;
-- declined
ALTER TABLE transactions
MODIFY declined TINYINT NOT NULL;
-- product_ids: HO DEIXO COM ESTÀ PER TAL DE NO LIMITAR LES COMPRES

-- user_id: FK per tant serà el mateix tipus de dades que a les taules de users
ALTER TABLE transactions
MODIFY user_id INT NOT NULL;
-- lat
ALTER TABLE transactions
MODIFY lat FLOAT NULL;
-- longitude
ALTER TABLE transactions
MODIFY longitude FLOAT NULL;

-- PAS 4: CREEM LES PK DE LES TAULES: 

-- PK USERS
ALTER TABLE users
ADD PRIMARY KEY (id);
-- PK transactions
ALTER TABLE transactions
ADD PRIMARY KEY (id);
-- PK credit_cards
ALTER TABLE credit_cards
ADD PRIMARY KEY (id);
-- PK companies
ALTER TABLE companies
ADD PRIMARY KEY (company_id);

-- PAS 5: AFEGIM LES FK

ALTER TABLE transactions
ADD CONSTRAINT fk_card_id_credit_cards
FOREIGN KEY (card_id) REFERENCES credit_cards(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE transactions
ADD CONSTRAINT fk_business_id_companies
FOREIGN KEY (business_id) REFERENCES companies(company_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE transactions
ADD CONSTRAINT fk_user_id_users
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Exercici 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT CONCAT (name, " ", surname) AS users_over_eighty_transactions
FROM
		(SELECT u.name, u.surname, COUNT(t.id)
		FROM users u
		JOIN transactions t
		ON u.id = t.user_id
		WHERE declined = 0
		GROUP BY u.id
		HAVING COUNT(t.id) >80) AS over_eighty_transaction

;

-- Exercici 2
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT  cc.iban, ROUND(AVG(t.amount),2) as average_amount
FROM credit_cards cc
JOIN transactions t
ON cc.id = t.card_id
JOIN companies c
ON c.company_id = t.business_id
WHERE t.declined = 0 AND c.company_name = "Donec Ltd" 
GROUP BY cc.iban
ORDER BY average_amount DESC
;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Nivell 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

CREATE TABLE credit_cards_declinated AS (
	(SELECT id 
    FROM credit_cards));

ALTER TABLE credit_cards_declinated
ADD status varchar(8);

ALTER TABLE credit_cards_declinated
ADD PRIMARY KEY (id);

ALTER TABLE credit_cards_declinated
ADD CONSTRAINT fk_declinated__credit_cards
FOREIGN KEY (id) REFERENCES credit_cards(id)
ON DELETE CASCADE
ON UPDATE CASCADE;


WITH cte_rango AS (
			SELECT c.id,timestamp AS date_transaction, t.declined,
			DENSE_RANK() OVER (	PARTITION BY c.id 
							ORDER BY timestamp desc 
                            ) AS rank_date

			FROM credit_cards c
			JOIN transactions t
			ON t.card_id = c.id
			ORDER BY c.id
                ),
	 cte_listado_declinadas AS(
			SELECT id, SUM(rank_date) AS suma_rangos
			FROM cte_rango
			WHERE rank_date BETWEEN 1 AND 3  AND declined =1
			GROUP BY id
			HAVING SUM(rank_date) = 6
			ORDER BY id
				)
UPDATE credit_cards_declinated
SET status =  
		CASE
			WHEN id IN (SELECT id FROM cte_listado_declinadas) THEN "inactive"
			ELSE "active"                       
		END;
;

SELECT * FROM credit_cards_declinated WHERE status ="inactive";
  
-- Exercici 1
-- Quantes targetes estan actives?
SELECT count(id) AS active_credit_card
FROM credit_cards_declinated 
WHERE status ="active";

select * from transactions where card_id = 'CcS-4998';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Nivell 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids.
-- Primer carreguem el 
CREATE TABLE products (
id VARCHAR (10) NULL,
product_name VARCHAR (255) NULL,
price VARCHAR(255) NULL,
colour VARCHAR(255) NULL,
weight FLOAT NULL,
warehouse_id VARCHAR(255) NULL
);

LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

select * from products;

SELECT 	MAX(LENGTH(product_name)),
		MAX(LENGTH(colour)),
        MAX(LENGTH(warehouse_id))
FROM products;
-- CAMBIO TIPUS DE VALOR DE id
ALTER TABLE products
MODIFY id INT NOT NULL;
-- CAMBIO TIPUS DE VALOR DE product_name
ALTER TABLE products
MODIFY product_name VARCHAR(100) NOT NULL;
-- trec el símbol de dolar i després li dono un tipues de valor FLOAT a la columna price
UPDATE products
SET price = (SELECT REPLACE(price, "$", ""));
ALTER TABLE products
MODIFY price FLOAT NOT NULL;
-- cambio tipus de valor al camp colour
ALTER TABLE products
MODIFY colour VARCHAR(7);
-- dEIXO WEIGHT COM L'HE GRABAT
-- CAMBIO TIPUS DE VALOR warehouse_id
ALTER TABLE products
MODIFY warehouse_id VARCHAR (6);
-- CREO LA PK DE LA TAULA products
ALTER TABLE products
ADD PRIMARY KEY (id);


-- UN COP CARREGADA LA TAULA I MODELADA HEM DISPOSO A CREAR LA TAULA QUE UNIRÀ PRODUCTS AMB TRANSACTIONS. 
-- LA TAULA TRANSACTIONS AL CAMP product_ids DISPOSA DE LA LLISTA DE PRODUCTES PER TRANSACCIÓ SEPARATS PER COMA. FAREM UNA TAULA ANOMENADA products_transactions
-- EN AQUESTA TAULA APAREIXERAN UNA COLUMNA DE L'ID DE LES TRANSACCIONS I QUE APAREGUI LA COLUMNA DE product_id que identifica el producte de la transacció. M'asseguraré de que 
-- tots el productes d'una transacció aparegui a la columna i tingui associada la seva transacción.

-- Després de la correcció he decidit canviar la funció amb la que faig la taula amb les columnes, triant JSON_TABLE()
   
CREATE TABLE products_transactions AS (
		SELECT t.id, jt.product_id
        FROM transactions t
        CROSS JOIN JSON_TABLE(
					CONCAT('[', REPLACE(t.product_ids, ' ', ''), ']'),
					"$[*]" COLUMNS (product_id INT PATH "$") -- SI ES LISTA SÓLO SE PONE EL DOLAR
					) AS jt
);

SELECT * FROM products_transactions;

DESCRIBE products_transactions;
ALTER TABLE products_transactions
MODIFY product_id INT NOT NULL;

-- CAMBIEM EL NOM DE L'ID DE LA TAULA products_transactions I POSAREM transaction_id, JA QUE AQUESTA ID FA REFERÈNCIA A LA TAULA TRANSACTIONS
ALTER TABLE products_transactions
RENAME COLUMN id TO transaction_id;

-- CREEM LES FK. 
-- amb la taula transaction
ALTER TABLE products_transactions
ADD CONSTRAINT fk_id_transactions
FOREIGN KEY (transaction_id) REFERENCES transactions(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;
-- amb la taula products
ALTER TABLE products_transactions
ADD CONSTRAINT fk_product_id_products_id
FOREIGN KEY (product_id) REFERENCES products(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;


-- Genera la següent consulta: 
-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT p.id, p.product_name, COUNT(pt.product_id)
FROM products p
JOIN products_transactions pt
ON p.id = pt.product_id
JOIN transactions t
ON t.id =pt.transaction_id
WHERE t.declined = 0
GROUP BY p.id
ORDER BY p.id;

-- En veure les repeticions de nom mirem a veure per què amb els altres camps que defineixen el producte:

SELECT p.id, p.product_name, colour,weight,price, COUNT(pt.product_id)
FROM products p
JOIN products_transactions pt
ON p.id = pt.product_id
JOIN transactions t
ON t.id =pt.transaction_id
WHERE t.declined = 0
GROUP BY p.id
ORDER BY p.id;







