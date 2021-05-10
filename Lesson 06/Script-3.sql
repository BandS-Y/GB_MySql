

/*
 * УРОК 6
 * 
 * Задание № 1
 * 
 * Пусть задан некоторый пользователь.
 * Найдите человека, который больше всех общался с нашим пользователем, иначе, 
 * кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).
 * (по желанию: можете найти друга, с которым пользователь больше всего общался)
 * 
 */

SELECT * FROM messages;

-- выведем всю таблицу количества сообщений, чтоб можно было провенить
-- группировка по от кого
SELECT from_user_id, to_user_id, count(from_user_id) FROM messages GROUP BY from_user_id ORDER BY to_user_id;

-- группировка  к кому
SELECT from_user_id, to_user_id, count(from_user_id) FROM messages GROUP BY to_user_id ORDER BY from_user_id;

-- выбираем пользователя с максимальным числом сообщений к пользователю 10 
SELECT fui, tui, max(c_us) 
	FROM (SELECT from_user_id AS fui, to_user_id AS tui, count(from_user_id) AS c_us 
	FROM messages GROUP BY to_user_id HAVING to_user_id = 10) AS res;

-- выбираем пользователя с максимальным числом сообщений от пользователя 11
SELECT fui, tui, max(c_us) 
	FROM (SELECT from_user_id AS fui, to_user_id AS tui, count(to_user_id) AS c_us 
	FROM messages GROUP BY from_user_id HAVING from_user_id = 11) AS res;

-- с друзьями сделаю, если останется время

-- ________________________________________________________________________________________________________________________________________
/*
 * Задание № 2 
 * 
 * Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.
 * 
 */
SELECT * FROM posts;

SELECT id FROM posts WHERE user_id;

/*
 *  ПРАВИЛЬНЫЙ ОТВЕТ ЗДЕСЬ !!!!!!!!
 * ВСЁ ОСТАЛЬНОЕ ЭТО ИЗЫСКАНИЯ К НЕМУ !!!!!!!!!!!!!!
 */
SELECT count(*) FROM posts_likes pl WHERE like_type = 1 
	AND (SELECT user_id FROM posts p2 WHERE id = pl.post_id ) IN (SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18);

SELECT user_id FROM posts p2 WHERE user_id = 1

SELECT count(pid) FROM (SELECT id AS pid FROM posts WHERE user_id) AS pou;

-- список пользователей с возрастом
SELECT user_id, birthday, FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) FROM profiles WHERE user_id; 
SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age FROM profiles;

-- список пользователей младше 18 лет
SELECT user_id, birthday FROM profiles WHERE FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) < 18;
SELECT user_id, birthday FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18;

-- считаем лайки по постам
SELECT post_id, count(*) c_u FROM posts_likes WHERE like_type = 1 GROUP BY post_id ;

-- сумма лайков
SELECT sum(c_l.c_u)  
FROM 
(SELECT post_id, count(user_id) c_u FROM posts_likes WHERE like_type = 1 ) c_l;

SELECT sum(c_l.c_u)  
	FROM 
	(SELECT count(*) c_u FROM posts_likes WHERE like_type = 1 
	AND post_id IN (SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18)) c_l	;

SELECT count(user_id) 
FROM posts_likes 
WHERE like_type = 1;


-- вытащили иды постов и имена пользователей написавших посты c количеством лайков
SELECT id,
	(SELECT first_name FROM users u WHERE id = p2.user_id) AS name,
	(SELECT id FROM users u WHERE id = p2.user_id) AS id,
	(SELECT count(*) FROM posts_likes WHERE like_type = 1 AND post_id = p2.id) AS likes
FROM posts p2 
WHERE user_id;

-- вытащили иды постов и имена пользователей написавших посты c количеством лайков у пользователей младше 18 лет
SELECT id,
	(SELECT first_name FROM users u WHERE id = p2.user_id) AS name,
	(SELECT id FROM users u WHERE id = p2.user_id) AS id,
	(SELECT count(*) FROM posts_likes WHERE like_type = 1 AND post_id = p2.id) AS likes
FROM posts p2 
WHERE user_id IN (SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18);

-- cуммируем лайки несовершеннолетних
SELECT sum(lik.likes) FROM 
(SELECT   
	(SELECT count(*) likes FROM posts_likes WHERE like_type = 1 AND post_id = p2.id)  lik
	FROM posts p2 
	WHERE user_id IN (SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18)) u_age;

SELECT sum(lik.likes) FROM    
	(SELECT count(*) likes FROM posts_likes WHERE like_type = 1 AND post_id = p2.id)  lik
	FROM posts p2 
	WHERE user_id;

-- __________________________________________________________________________________________________________________________________

/*
 * Задание № 3
 * 
 *  Определить, кто больше поставил лайков (всего) - мужчины или женщины?
*/

SELECT user_id, gender FROM profiles;

SELECT id AS post,
	(SELECT id FROM users u WHERE id = p2.user_id) AS id_user,
	(SELECT gender FROM profiles WHERE user_id = p2.user_id) AS gender,
	(SELECT count(*) FROM posts_likes WHERE like_type = 1 AND post_id = p2.id GROUP BY (SELECT gender FROM profiles WHERE user_id = p2.user_id)) AS likes
FROM posts p2 
WHERE user_id;

-- количество постов по гендерному признаку
SELECT count(*) FROM posts_likes pl WHERE like_type = 1 
	AND (SELECT user_id FROM posts p2 WHERE id = pl.post_id ) IN (SELECT user_id FROM profiles p2 WHERE gender = 'm') ;

-- мы знаем, что лайков от женщин 6
-- a лайков от мужчин 28

SELECT user_id FROM profiles p2 WHERE gender = 'f';


SELECT 	IF ((SELECT count(*) FROM posts_likes pl WHERE like_type = 1 
	AND (SELECT user_id FROM posts p2 WHERE id = pl.post_id ) IN (SELECT user_id FROM profiles p2 WHERE gender = 'f')) > 
	(SELECT count(*) FROM posts_likes pl WHERE like_type = 1 
	AND (SELECT user_id FROM posts p2 WHERE id = pl.post_id ) IN (SELECT user_id FROM profiles p2 WHERE gender = 'm')),
	'женщин больше',
	'мужчин больше'
	) AS answer;


/*
 * Задание № 4
 * 
* (по желанию) Найти пользователя, который проявляет наименьшую активность в использовании социальной сети
*  (тот, кто написал меньше всего сообщений, отправил меньше всего заявок в друзья, ...).
*/

-- количество сообщений от пользователей
SELECT user_id, count(*) AS cp FROM posts ps GROUP BY user_id ORDER BY cp

-- количество запросов в друзья от пользователей
SELECT from_user_id, count(*) AS cr FROM friend_requests fr GROUP BY from_user_id ORDER BY cr

-- отсортируем пользователей по количеству сообщений и потом по количеству запросов в друзья
SELECT id, CONCAT(first_name, ' ', last_name) AS name,  
	(SELECT count(*) AS cp FROM posts ps WHERE user_id=u2.id) AS count_message,
	(SELECT count(*) AS cr FROM friend_requests fr  WHERE from_user_id=u2.id) AS count_requerst
FROM users u2
ORDER BY count_message, count_requerst;

-- выберем первого такого пользователя он и будет наименее активным
SELECT id, CONCAT(first_name, ' ', last_name) AS name,  
	(SELECT count(*) AS cp FROM posts ps WHERE user_id=u2.id) AS count_message,
	(SELECT count(*) AS cr FROM friend_requests fr  WHERE from_user_id=u2.id) AS count_requerst
FROM users u2
ORDER BY count_message, count_requerst
LIMIT 1;

