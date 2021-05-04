/*
 * Практическое задание по теме “Оптимизация запросов”
 * 
 * Задание № 1
 * 
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
 * catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
 * идентификатор первичного ключа и содержимое поля name.
 */

-- создаём таблицу 
DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	id SERIAL PRIMARY KEY,
	id_in INT UNSIGNED,
	date_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
	name VARCHAR(255) COMMENT 'поле имени из таблицы',
	table_log VARCHAR(64) COMMENT 'имя таблицы'
	) COMMENT = 'таблица логирования';
	
-- триггеры в отдельном файле

SELECT * FROM users u;
SELECT * FROM logs l;

INSERT INTO users (name, birthday_at)
VALUES ('Джон', '1990-01-01');

SELECT * FROM catalogs c ;

INSERT INTO catalogs (name)
VALUES ('Cистемная память'),
		('Блоки питания');



SELECT * FROM products p ;

INSERT INTO products (name, description, price, catalog_id)
VALUES ('Asus', 'some discription', 1500, 3);

SELECT * FROM logs l;

/*
 * Задание №2
 * 
 * Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 * 
 */

-- для экспериментов созадём отдельную таблицу
-- при экспериментах комп завис, пришлось доставать процедуру и таблицу из базы :-)
SHOW CREATE TABLE users_1 ;

CREATE TABLE `users_1` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT 'Имя покупателя',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) COMMENT='Покупатели test'

SELECT count(*) FROM users_1 u2 ; 

-- процедура в отдельном файле
CALL sp_gen_line(10000); 

-- 10 000 строк генериться за 8,2 секунд.
-- при 100 тыс. повисло всё :-) работало до этого больше 180 секунд