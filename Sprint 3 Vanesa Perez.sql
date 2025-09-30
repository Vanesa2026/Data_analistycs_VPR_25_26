#NIVELL 1
#EXERCICI1
# a)	La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
# La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
#Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
#Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

#Se selecciona bases de datos donde se va a añadir la nueva tabla
USE transactions;
# Se crea la nueva tabla con las columnas, las columnas se conocen abriendo el archivo con los datos a pegar en la nueva tabla, en él se hace referencia a las columnas
# en los que se van a insertar los datos. Las columnas son: id, iban, pan, pin, cvv, expiring_date
# Leyendo el código que se va a ejecutar vemos que los datos que se van a insertar son: ('CcU-4233', 'GI10TNGB218311472843723', '349284173298327', '7910', '380', '12/03/23')
# el primero  es un código de número letras y simbolo de una longitud de 8 pondré VARCHAR(10) y corresponde a la columna id que es la que utilizaremos como PK de la tabla
# El segundo valor es el número IBAN de la targeta que dispone de letras y números y la longitud es variable con lo que le asignaré un tipo de variable VARCHAR (100)
# La tercera columna (PAN) tiene valores numéricos y espacios con lo que el tipo de variable la determinaré VARCHAR (100).
# La cuarta columna(PIN) son números de 4 dígitos con lo que le asignaré SMALLINT (4) como especificación de tipo de variable.
# La quinta columna (cvv) es un número de 3 dígitos con lo que le asignaré SAMLLINT (3)
# La sexta columna (expiring_date) es una fecha. 

CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) NOT NULL PRIMARY KEY,
    iban VARCHAR(100) NOT NULL,
    pan VARCHAR (18) NOT NULL,
    pin SMALLINT(4) NOT NULL,
    cvv SMALLINT (3) NOT NULL, 
    expiring_date VARCHAR(8) NOT NULL
);

#Se revisa el contenido de la tabla creada
describe credit_card;

#COMPROBAMOS LOS DATOS DE LA TABLA
SELECT * FROM credit_card;
# Para crear la relación con el resto de tablas miramos las columnas que hay en cada una de las otras dos tablas. Vemos que las otras dos tablas están relacionadas 
#entre ellas y podemos observar que la única relación que se puede realizar es con la tabla transaction que dispone de la columna credit_card_id. Con lo que realizaremos una modificación 
#de la tabla transaction para que la columna credit_card_id sea la Foreing Key que la relaciona con la tabla credit_card
SHOW COLUMNS FROM transaction;
SHOW COLUMNS FROM company;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card_id FOREIGN KEY  (credit_card_id )
REFERENCES credit_card (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Exercici 2
-- a)	El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET IBAN = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

-- Exercici 3
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
INSERT INTO transaction (id,  credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.9999, -117.999, 111.11, 0);

 -- Comprovem l'error, mirant si la id de la credit card existeix a credit_card. 
 -- Durant la correcció s'ha dit que sí que s'ha d'afegir els id a les taules que ho necessiten per poder introduir les dades de la transacció encara que que no disposem de la informació completa.
 
 SELECT *
 FROM credit_card
 WHERE id = 'CcU-9999';
  SELECT *
 FROM company
 WHERE id = 'b-9999';
 SELECT *
 FROM data_user
 WHERE id = '9999';
 
INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO data_user (id)
VALUES ('9999');

show columns from credit_card;
 ALTER TABLE credit_card
 MODIFY expiring_date VARCHAR (8) NULL;
 
 SELECT *
 FROM transaction
 WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';
 
 
 
 -- ADD INFORMATION ABOUT ID CREDIT CARD AND ID COMPANY
-- Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat

-- Comprovem la taula abans de la eliminació:

SELECT *
FROM credit_card;
-- Eliminem columna 
ALTER TABLE credit_card
DROP COLUMN pan;

-- comprovem taula després de l'eliminació

SELECT *
FROM credit_card;


-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Nivell 2

-- Exercici 1
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

-- comprovem que hi és abans de l'eliminació i després: 

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW  VistaMarketing AS(

	WITH avg_purchases_company AS(
		SELECT t.company_id, ROUND(AVG(t.amount),2) AS avg_purchase
		FROM transaction t
		WHERE declined = 0
		GROUP BY t.company_id)
	SELECT c.companvistamarketingy_name, c.phone, c.country, av.avg_purchase
	FROM avg_purchases_company av
	JOIN company c
	ON c.id = av.company_id
	ORDER BY av.avg_purchase DESC
);

-- para veure la taula de la vista hem de fer la selecció:
SELECT * FROM transactions.vistamarketing;

-- també es pot fer: 
SELECT * FROM vistamarketing;

-- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany".

SELECT *
FROM vistamarketing
WHERE country = 'Germany';

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Nivell 3

-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, 
-- però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir el diagrama de relacions.

SHOW COLUMNS FROM user;
SHOW COLUMNS FROM transaction;

RENAME TABLE user TO data_user;
SHOW COLUMNS FROM data_user;

ALTER TABLE data_user
MODIFY  id INT NOT NULL;


ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE DEFAULT (CURDATE());
select fecha_actual FROM credit_card;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_data_user_id 
FOREIGN KEY (user_id) REFERENCES data_user (id)
ON UPDATE CASCADE
ON DELETE SET NULL;

ALTER TABLE company
DROP COLUMN website;

ALTER TABLE transaction
MODIFY  credit_card_id VARCHAR(20);

ALTER TABLE credit_card
MODIFY  id varchar(20);
ALTER TABLE credit_card
MODIFY  iban varchar(100);
ALTER TABLE credit_card
MODIFY  pin varchar(4);
ALTER TABLE credit_card
MODIFY  cvv INT;


ALTER TABLE data_user
RENAME COLUMN email TO personal_mail;


-- Exercici 2
-- L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
-- o	ID de la transacció
-- o	Nom de l'usuari/ària
-- o	Cognom de l'usuari/ària
-- o	IBAN de la targeta de crèdit usada.
-- o	Nom de la companyia de la transacció realitzada.
-- o	Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
-- Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.



CREATE VIEW InformeTecnico AS(
	WITH cte_user_transaction AS(
			SELECT DATE(timestamp) as date, t.id, t.user_id, d.name, d.surname, cc.iban, c.company_name, amount
			FROM company c
			JOIN transaction t
			ON c.id = t.company_id
			JOIN credit_card cc
			ON cc.id =t.credit_card_id
			JOIN data_user d
			ON d.id = t.user_id
            WHERE declined = 0
			ORDER BY t.id
            )
	SELECT 	date, id, user_id, name, surname, iban, company_name, amount,
		SUM(amount) OVER (PARTITION BY user_id) AS total_purchases_user, 
		ROUND(AVG(amount) OVER (PARTITION BY user_id ),2) AS average_purchase_user, 
		MAX(amount) OVER (PARTITION BY user_id ) AS purchase_max_user, 
        MIN(amount) OVER (PARTITION BY user_id ) AS purchase_min_user, 
		SUM(amount) OVER () as total_purchases, 
        ROUND(AVG(amount) OVER (),2) as average_total_purchases, 
		ROUND((amount/ (SUM(amount) OVER (PARTITION BY user_id)))*100, 2) AS Perc_purchases_user_totales         
	FROM cte_user_transaction cut
	ORDER BY id
);     
    
SELECT * 
FROM InformeTecnico;

CREATE INDEX indx_transaction_amount ON transaction(amount);
CREATE INDEX indx_transaction_user_id ON transaction(user_id);










 