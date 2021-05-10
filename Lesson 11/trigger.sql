 /*
 * Практическое задание по теме “Оптимизация запросов”
 * 
 * Задание № 1
 * 
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
 * catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
 * идентификатор первичного ключа и содержимое поля name.
 */

 -- создаём триггеры 
 
 /*
  * id SERIAL PRIMARY KEY,
	id_in INT UNSIGNED,
	date_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
	name VARCHAR(255) COMMENT 'поле имени из таблицы',
	table_log VARCHAR(64) COMMENT 'имя таблицы'
  */
 
 DROP TRIGGER IF EXISTS log_ins_users;
 DROP TRIGGER IF EXISTS log_ins_catalogs;
 DROP TRIGGER IF EXISTS log_ins_products;

delimiter //

CREATE TRIGGER log_ins_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.name, 'users');
END //

CREATE TRIGGER log_ins_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.name, 'catalogs');
END //

CREATE TRIGGER log_ins_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.name, 'products');
END //

delimiter ;