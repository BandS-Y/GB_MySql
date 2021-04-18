/*
*  Урок 5
* 
* Задача № 1
* 
* Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

SELECT * FROM users;

UPDATE users  SET created_at=now(), updated_at=now();

/*Задача № 2
 * 
 * Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
 * и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к 
 * типу DATETIME, сохранив введённые ранее значения.
 */


-- Создадим указанную "неправильную" таблицу и заполним её данными

DROP TABLE IF EXISTS users;
truncate TABLE users;

CREATE TABLE users1 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255) COMMENT 'Текст должен быть',
  updated_at VARCHAR(255) COMMENT 'Текст должен быть'
) COMMENT = 'Покупатели';

INSERT INTO users1 (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

UPDATE users1  SET created_at='20.10.2017 9:10', updated_at='20.10.2017 10:15';

-- исправим ошибку проектирования таблицы

-- ALTER TABLE users CHANGE created_at DATE_FORMAT(created_at, '%Y.%m.%d');
SELECT * FROM users1;

-- ALTER TABLE users1 MODIFY created_at STR_TO_DATE(created_at, '%Y.%m.%d %h:%m');

-- SELECT DATE_FORMAT(created_at, '%Y.%m.%d') FROM users1 u2;
-- SELECT str_to_date(created_at, '%Y.%m.%d') FROM users1 u2;
-- UPDATE str_to_date(created_at, '%Y.%m.%d') FROM users1 u2;
-- SELECT created_at FROM users1 u2;

UPDATE users1 SET created_at = STR_TO_DATE(created_at,'%d %M %Y');

-- что-то не могу победить, не работают даже простые решения. Даже таблица не дропается, пришлось создать новую.

/*Задача № 3
 * 
 * В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
 *  если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи 
 * таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны
 *  выводиться в конце, после всех.
 */

SELECT * FROM storehouses_products;

SELECT value FROM storehouses_products ORDER BY value = 0, value ;

/*Задача № 4
 * 
 * (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
 *  Месяцы заданы в виде списка английских названий (may, august)
 */
 
SELECT * FROM users1;

SELECT name  FROM users1 u WHERE MONTH (birthday_at) IN  (5,8) ;

-- сделал немного по другому, но вроде правильно.

/*Задача № 5
 * 
 * (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
 * 
 */
 
SELECT * FROM catalogs c ;

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(`id`, 5,1,2);

/*
 *Практическое задание теме «Агрегация данных»
 *
 *  Задача № 1
 * 
 * Подсчитайте средний возраст пользователей в таблице users.
 * 
 */

SELECT avg(FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25)) AS average_age FROM users1 u ;


/*
 *   Задача № 2
 * 
 * Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 * 
 */

-- по дням рождения в год рождения 

SELECT COUNT(*) AS total, weekday(birthday_at) AS day_week FROM users1 u GROUP BY day_week;

-- по дням рождения в текущем году

SELECT COUNT(*) AS total, weekday(CONCAT('2010-', SUBSTRING(birthday_at, 6, 10))) AS day_week FROM users1 u GROUP BY day_week;
 

/*
 *  Задача № 3
 * 
 * (по желанию) Подсчитайте произведение чисел в столбце таблицы.
 */


SELECT  EXP(sum(LN(id))) AS composition FROM  users1;
