#NIVEL 1
#ejercicio 2

#Lista de paises que estan generando ventas
SELECT DISTINCT company.country
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.amount > 0 AND transaction.declined = 0
ORDER BY country;



# Desde cuantos países se generan las ventas.
SELECT count(distinct company.country) as num_paises_con_ventas
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.amount > 0 AND transaction.declined = 0;



#	Identifica la compañía con la media más grande de ventas. 
SELECT company.company_name
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.declined=0
GROUP BY company.id
ORDER BY ROUND(avg(transaction.amount),2) desc
LIMIT 1;

#  Ejercicio 3
#	Muestras todas las transacciones realizadas por las empresas de Alemania
SELECT *
FROM transaction
WHERE EXISTS(
	SELECT company.id
    FROM company
    WHERE company.country = "Germany" AND company.id = transaction. company_id)
ORDER BY transaction.company_id ;

#Lista las empresas que han realizado transacciones por una amount superior a la media de todas las transacciones.

SELECT DISTINCT company.company_name
FROM company
WHERE EXISTS (
	SELECT transaction.company_id
    FROM transaction
    WHERE transaction.amount > (SELECT avg(transaction.amount) FROM transaction) AND transaction.declined = 0 AND transaction.company_id = company.id
        ) 
ORDER BY company.company_name;
	
    
# Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.
SELECT company.company_name
FROM company
WHERE NOT EXISTS (
		SELECT transaction.company_id
        FROM transaction
        WHERE company.id = transaction.company_id
        )
ORDER BY company.company_name;


#NIVEL 2

#Ejercicio 1
#Identifica los cinco días en los que se generó la cantidad más grande de ingresos en la empresa por ventas. Muestra la fecha de cada transacción juntamente con el total de ventas.
SELECT  DATE_FORMAT(timestamp, "%d/%m/%Y") AS fecha, SUM(amount) AS total_ventas
FROM transaction
GROUP BY fecha
ORDER BY total_ventas DESC
LIMIT 5;    

#Ejercicio 2

# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country, Round(avg(transaction.amount),2) as media_ventas
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.declined = 0
GROUP BY company.country
ORDER BY media_ventas DESC;


# Ejercicio 3
#En tú empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
# Para esto, te solicitan la lista de todas las transacciones realizadas por empresas que están situadas en el mismo País que esta compañía.
#a)	Muestra el listado aplicando JOIN y subconsultas.
SELECT * 
FROM transaction
JOIN (
		SELECT company.id
		FROM company
		WHERE company.country = (
			SELECT company.country
			FROM company
			WHERE company.company_name = "Non Institute")
					AND company.company_name <> "Non Institute"
                    )AS company_id_pais_non_institute	
ON transaction.company_id = company_id_pais_non_institute.id;

#b)	Muestra el listado sólo aplicando subconsultas. 
SELECT *
FROM transaction
WHERE EXISTS (SELECT *
		FROM company
		WHERE company.country = (
			SELECT company.country
			FROM company
			WHERE company.company_name = "Non Institute")
		AND company.company_name <> "Non Institute" AND company.id = transaction.company_id)
            ;

# NIVEL 3
#EJERCICIO 1
# Presenta el nombre, teléfono, país, fecha y amount, de las empresas que realizaron transacciones don un valor comprendido entre 350 y 400 euros y en alguna de las 
#siguientes fechas: 29/04/2015, 20/07/2018 y 13/03/2024. Ordena los resultados de mayor a menor cantidad.
SELECT company.company_name, company.phone, company.country, DATE_FORMAT(transaction.timestamp, "%d/%m/%Y") AS fecha, transaction.amount
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE transaction.declined = 0 AND DATE_FORMAT(transaction.timestamp, "%d/%m/%Y") IN ("29/04/2015","20/07/2018","13/03/2024")  AND transaction.amount BETWEEN 350 AND 400 
ORDER BY transaction.amount DESC;


#EJERCICIO 2
#Necesitamos la optimización y la asignación de los recursos y dependerá de la capacidad operativa que se requiera, para esto te solicitan la información sobre 
#la cantidad de transacciones que realizan las empresas, pero el departamento de rrhh es exigente y quiere un listado de las empresas donde se especifiquen si tienen 
#más de 400 transacciones o menos.

SELECT company.company_name, count(transaction.id),
	CASE
			WHEN count(transaction.id) <= 400 THEN "<= 400"
			ELSE "> 400"                       
	END AS grupo_transactions
FROM transaction
JOIN company
ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY count(transaction.id) DESC;


 


