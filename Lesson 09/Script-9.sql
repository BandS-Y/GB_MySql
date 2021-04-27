/*
 * Практическое задание по теме “Транзакции, переменные, представления”
 * 
 * Задание № 1
 * 
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
 * 
 */

use sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

SELECT * FROM users u;

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM users u;


/*
 *  Задание № 2
 * 
 * Создайте представление, которое выводит название name товарной позиции из таблицы products
 *  и соответствующее название каталога name из таблицы catalogs.
 * 
 */

USE shop;

CREATE OR REPLACE VIEW prod_cat (name, catalogs) AS
SELECT 	p.name, c2.name 
FROM 
	products p 
LEFT JOIN 
	catalogs c2
ON c2.id = p.catalog_id ;

SELECT * FROM prod_cat ;

/*
 * Задание №3
 * 
 * (по желанию) Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', 
 * '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список 
 * дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
 * 
 */

-- создадим такие записи с таблице users

INSERT INTO users (name, birthday_at, created_at) VALUES 
  ('Геннадий_2', '1990-10-05', '2018-08-01' ),
  ('Наталья_2', '1984-11-12', '2018-08-04'),
  ('Александр_2', '1985-05-20', '2018-08-16'),
  ('Сергей_2', '1988-02-14', '2018-08-17'),
  ('Иван_2', '1998-01-12', '2018-08-01'),
  ('Мария_2', '1992-08-29', '2018-08-04');
 
SELECT * FROM users u2 ;

-- работающее решение ниже.

SELECT 
	time_period.selected_date AS day,
	(SELECT EXISTS(SELECT * FROM users u WHERE created_at = day)) AS has_already
FROM
	(SELECT v.* FROM 
		(SELECT ADDDATE('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date FROM
			(SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4) v
	WHERE selected_date BETWEEN '2018-08-01' AND '2018-08-31') AS time_period;
	
/*
 * пытался сделать по своему, но докрутить не смог :-(
 * 
 * SET @i = -1;
SET @start_day = '2018-08-01';
SET @stop_day = '2018-08-31';

SELECT @start_day;

/*
 * сделал такой костыль, работает с одной оговоркой в  таблице должно быть записей больше чем разница между (@stop_day, @start_day)
 * понятно, что криво, но вариант с (cross join (select 1 union select 2 union select 3 union select 4 ... ) мне кажется не меньшим костылём.
 * с точки зрения памяти и т.п.
 *

SELECT DATE(ADDDATE(@start_day, INTERVAL @i:=@i+1 DAY)) AS date_m FROM users u2 
WHERE @i < DATEDIFF(@stop_day, @start_day) ;

SELECT @i;
SELECT DATEDIFF(@stop_day, @start_day);

SELECT DATE(ADDDATE(@start_day, INTERVAL @i:=@i+1 DAY)) AS ddate_m FROM catalogs c2 
	WHERE @i < DATEDIFF(@stop_day, @start_day) ;
	
SELECT if(
	(SELECT DATE(ADDDATE(@start_day, INTERVAL @i:=@i+1 DAY)) AS ddate_m FROM catalogs c2 
		WHERE @i < DATEDIFF(@stop_day, @start_day))
	IN u.created_at, '1', '0')
FROM users u;

SELECT
	ddate_m AS date_m_th,
	(SELECT EXISTS(SELECT * FROM users u2 WHERE created_at = date_m_th)) AS yes	 
FROM 
	(SELECT DATE(ADDDATE(@start_day, INTERVAL @i:=@i+1 DAY)) AS date_m FROM catalogs c2 
		WHERE @i < DATEDIFF(@stop_day, @start_day)) AS ddate_m;

SELECT 

SET @i = -1;

SELECT if(
	(SELECT DATE(ADDDATE(@start_day, INTERVAL @i:=@i+1 DAY)) AS date_m FROM users u2
		WHERE @i < DATEDIFF(@stop_day, @start_day)) IN 
	(SELECT created_at FROM users u), 1,0);	 
 * 
 */ 

-- ---------------------------------------------------------------------------------------------


/*
 * (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
 */

SELECT * FROM users u ORDER BY birthday_at ;

-- cуществующие таблицы не подходят. создадим отдельную таблицу с данными

DROP TABLE IF EXISTS Birth_day;
CREATE TABLE Birth_day (created_at DATE);

INSERT INTO Birth_day VALUES
	('2018-01-11'),
	('2018-05-02'),
	('2018-07-04'),
	('2018-09-15'),
	('2018-10-14'),
	('2018-02-27'),
	('2018-04-25'),
	('2018-05-20'),
	('2018-10-15'),
	('2018-08-30');
	
SELECT * FROM Birth_day ORDER BY created_at;

SELECT * FROM Birth_day ORDER BY created_at LIMIT 5;

-- выведем всё, что надо удалить
SELECT created_at AS under_five FROM Birth_day
WHERE created_at NOT IN
	(SELECT * FROM
		(SELECT * FROM Birth_day ORDER BY created_at LIMIT 5
	) AS any_any
) ORDER BY created_at;

-- удаляем
DELETE FROM Birth_day
WHERE created_at NOT IN
	(SELECT * FROM
		(SELECT * FROM Birth_day ORDER BY created_at LIMIT 5
	) AS any_any
) ORDER BY created_at;


/*
 * Практическое задание по теме “Администрирование MySQL” 
 * 
 * Задание № 1
 * 
 * Создайте двух пользователей которые имеют доступ к базе данных shop. 
 * Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
 *  второму пользователю shop — любые операции в пределах базы данных shop.
 */

-- shop  - пользователь с полным доступом

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY 'pass';
GRANT ALL ON shop.* TO 'shop'@'localhost';
GRANT GRANT OPTION ON shop.* TO 'shop'@'localhost';

SELECT USER();

/*
 *  mysql -u shop -p
 *  работаем с консоли
 */

INSERT INTO rubrics (name) VALUES('Процессоры');

SELECT * FROM rubrics;

DELETE FROM rubrics WHERE name = 'Процессоры'


-- shop_read только чтение данных
DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass';
GRANT SELECT ON shop.* TO 'shop_read'@'localhost';


INSERT INTO rubrics(name) VALUES('Процессоры');

SELECT * FROM rubrics;

SELECT Host, User FROM mysql.user;

/*
 * Задание № 2
 * 
 * (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
 * содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username 
 * таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read,
 *  который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.
 */

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR(128),
	password VARCHAR(45)
);

INSERT INTO accounts VALUES
	(NULL, 'Антон', 'pass1'),
	(NULL, 'Дима', 'pass2'),
	(NULL, 'Миша', 'pass3');


CREATE OR REPLACE VIEW username(user_id, user_name) AS 
	SELECT id, name FROM accounts;

SELECT * FROM accounts;
SELECT * FROM username;


-- Создаем пользователя shop_reader с доступом только к представлению username;

DROP USER IF EXISTS 'user_read'@'localhost';
CREATE USER 'user_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass';
GRANT SELECT ON shop_online.username TO 'user_read'@'localhost';

/*
 *  mysql -u shop -p
 *  работаем с консоли
 */
SELECT * FROM catalogs;  -- не проходит

SELECT * FROM username;   -- проходит

/*
 * Практическое задание по теме “Хранимые процедуры и функции, триггеры"
 * 
 * Задание № 1
 * 
 * Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 *  С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 *  с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
 *  с 18:00 до 00:00 — "Добрый вечер",
 *  с 00:00 до 6:00 — "Доброй ночи".
 */

SHOW PROCEDURE status LIKE 'hello';

DROP PROCEDURE IF EXISTS hello;

-- не смог нормально из Дебивира сменить ; 
-- запускал из консоли копированием

delimiter //

CREATE PROCEDURE hello()
BEGIN
	CASE 
		WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
			SELECT 'Доброе утро';
		WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END //

delimiter ;

CALL hello();

/*
 * Задание № 2
 * 
 * В таблице products есть два текстовых поля: name с названием товара и 
 * description с его описанием. Допустимо присутствие обоих полей или одно из них.
 *  Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.

 */

DROP TRIGGER IF EXISTS my_trigger;

delimiter //

CREATE TRIGGER my_trigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Что-то пошло не так';
	END IF;
END //

delimiter ;

-- рабочие варианты
INSERT INTO products (name, description, price, catalog_id)
VALUES ("amd gx 860", NULL, 5000, 12); 

INSERT INTO products (name, description, price, catalog_id)
VALUES ("amd gx 860", "видеокарта", 5000, 12);


-- выдаёт ошибку
INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 5000, 12);



