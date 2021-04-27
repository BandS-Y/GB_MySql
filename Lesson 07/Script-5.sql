
/*
*
*  ДЗ по утоку № 7
*
*	Задание № 1
*
* Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
* 
*/

SELECT * FROM users;

SELECT * FROM orders o ;

-- т.к. в таблице заказов заказы есть на всех пользователей, то для наглядности удалим пользователя с id=4
DELETE FROM orders_products WHERE order_id = 7;
DELETE FROM orders WHERE user_id = 4;

-- решаем таким запросом
SELECT 
	u2.name
FROM 
	users u2 
JOIN 
	orders o 
ON 
	u2.id = o.user_id 
	GROUP BY name;
	
-- Теперь пользователя  Сергей нет в списке.

/*
 * 	Задание № 2
 * 
 * Выведите список товаров products и разделов catalogs, который соответствует товару.
 * 
 */

SELECT * FROM products p ;

SELECT * FROM catalogs c ;

-- решение
SELECT 
	p.name,
	c.name
FROM 
	products p
JOIN
	catalogs c
ON 
	c.id = p.catalog_id ;
	

/*
 * 	Задание № 3
 * 
 * (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов 
 * flights с русскими названиями городов.
 * 
 */

DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	FROM_t VARCHAR(255) COMMENT 'Город откуда вылет',
	to_t VARCHAR(255) COMMENT 'Город приземления'
);

INSERT INTO flights VALUES 
(DEFAULT, 'moscow', 'omsk'),
(DEFAULT, 'novgorod', 'kazan'),
(DEFAULT, 'irkutsk', 'moscow'),
(DEFAULT, 'omsk', 'irkutsk'),
(DEFAULT, 'moscow', 'kazan');


DROP TABLE IF EXISTS cities;

CREATE TABLE cities (
	label_t VARCHAR(255) COMMENT 'метка города',
	name_t VARCHAR(255) COMMENT 'Имя города по метке'
);

INSERT INTO cities VALUES 
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

-- так получилось
SELECT 
	(SELECT name_t FROM cities WHERE f2.FROM_t = label_t) AS fr,
	(SELECT name_t FROM cities WHERE f2.to_t = label_t) AS to_t
FROM 
	flights f2;

-- так не смог разобраться
SELECT 
	c2.name_t AS fr,
FROM 
	flights f2 
JOIN 
	cities c2 
WHERE 
	f2.FROM_t = c2.label_t;


	