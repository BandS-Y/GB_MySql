/*
 * База данных по обеспечению работы ремонтной мастерской велосипедов. Обеспечивает ведение информации по:
- Клиентам
	- велосипедам (транспорт)
- видам работ
- проведённым работам по велосипедам
- сотрудникам
- проведённым работам сотрудниками
- поставщикам запчастей (ЗЧ)
- инструментам
Планируем таблицы:
- люди (ид, имя, фамилия, почта, телефон)
- клиент (ид, статус, ДР, адрес)
- организации (ид, наименование, адрес, телефон, сайт, платёжные данные, )
- сотрудники (ид, ид_орг, ид_люд, должность, раб_тел, раб_почта)
- транспорт (ид, производитель(к), марка(к), клиент(к), номер_рамы)
- производитель (ид, название, страна)
- марки (ид, наименование, каталожный номер)
- клиент + транспорт (ид_клиента, ид_транспорта)
- инструменты (ид, производитель (к), марка(к), номер)
- расходные материалы  (ид, производитель (к), марка(к))
- виды работы
- проведённые работы

  в результате многие вещи от задуманного в первом приближении объёма пока убрал, т.к. объём работ оказался гораздо большим, чем я планировал.
  выше описано именно то, что реализовано. Дальнейшие появнения идут рядом с таблицами и запросами.
  ко всему прочему я выгружу полный дамп БД.
 */


-- Таблица организаций, как поставщиков, так и собственная проводящая работы

DROP TABLE IF EXISTS organisation;
CREATE TABLE organisation (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) COMMENT 'Название фирмы',
  adress varchar(130) DEFAULT NULL, -- по хорошему надо справочник адресов, но что-то много таблиц получается
  phone char(11) DEFAULT NULL,
  site varchar(130) DEFAULT NULL,
  pay_data varchar(130) DEFAULT NULL, -- тоже надо бы развернуть, но....
  PRIMARY KEY (id),
  CONSTRAINT phone_check1 CHECK (regexp_like(phone,_utf8mb4'^[0-9]{11}$'))
) COMMENT = 'Поставщики';


-- вносим информацию по организациям

INSERT INTO organisation (name, adress, phone) values
	('Велоцентр','Ленина 45','79139132348'),
	('Инструмент центр','Набережная 28','79233454345'),
	('Мир запчастей','Полевая 77','79899999999');

-- для облегчения реализаии добавим организацию для клиентов 
INSERT INTO organisation (name, adress, phone) values
	('Частное лицо','','99999999999');

SELECT * FROM organisation o ;

-- таблица людей как таковых всех подряд, по старинке назвал пользователями, хотя это не так
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  first_name varchar(145) NOT NULL,
  last_name varchar(145) NOT NULL,
  email varchar(145) NOT NULL,
  phone char(11) NOT NULL,
  created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY email_idx (email),
  UNIQUE KEY phone_idx (phone),
  CONSTRAINT phone_check CHECK (regexp_like(phone,_utf8mb4'^[0-9]{11}$'))
) COMMENT = 'Люди';


-- вносим данные по людям здесь работники
INSERT into users (first_name, last_name, email, phone) values
	('Петр','Иванов','1232@mail.ru','79899999999'),
	('Мария','Облачная','1233@mail.ru','79899999989'),
	('Кузьма','Прутков','1234@mail.ru','79899999979'),
	('Сергей','Белый','1235@mail.ru','79899999969');

-- здесь те, кто станет потом клиентами, вспомнил про них потом.
INSERT into users (first_name, last_name, email, phone) values
	('Виктор','Петров','1242@mail.ru','79899999959'),
	('Ольга','Ветренная','1253@mail.ru','79899999589');

SELECT * FROM users u ;

-- таблица привязки людей к организациям
DROP TABLE IF EXISTS organisation_to_worker;
CREATE TABLE organisation_to_worker (
  id_users bigint unsigned NOT NULL,
  id_organisation bigint unsigned NOT NULL,
  PRIMARY KEY (id_users, id_organisation),
  CONSTRAINT fk_organisation_to_worker_users_organisation FOREIGN KEY (id_organisation) REFERENCES organisation (id),
  CONSTRAINT fk_organisation_to_worker_users_users FOREIGN KEY (id_users) REFERENCES users (id)
  ) COMMENT = 'Работники организаций';
 
 -- привязываем людей к организации первые два - работники велоцентра, остальные мененджеры поставщиков.
 INSERT into organisation_to_worker values
 	(1, 1),
 	(2, 1),
 	(3, 2),
 	(4, 3);
 
 -- Виктор и Ольга частные лица
  INSERT into organisation_to_worker values
 	(7, 4),
 	(8, 4);
 	
 SELECT * FROM organisation_to_worker;

-- запрос выводит работников из организации по именам и названиям организации
SELECT 
	(SELECT concat(first_name, last_name) FROM users u where otw.id_users = u.id) AS name,
	(SELECT o.name  FROM organisation o  where otw.id_organisation = o.id) AS org
FROM 
	organisation_to_worker otw;

-- тот же запрос сделанный через джоин
SELECT 
	concat(name_u.first_name, ' ', name_u.last_name) AS name,
	o.name  AS org
FROM organisation_to_worker otw 
	JOIN users AS name_u ON otw.id_users =name_u.id
	JOIN organisation o ON otw.id_organisation = o.id ;


-- сразу сделаем вьюху на базе запроса
CREATE or replace VIEW view_peope_in_org
AS 
	SELECT 
	concat(name_u.first_name, ' ', name_u.last_name) AS name,
	o.name  AS org
FROM organisation_to_worker otw 
	JOIN users AS name_u ON otw.id_users =name_u.id
	JOIN organisation o ON otw.id_organisation = o.id ;
	
SELECT * FROM view_peope_in_org ;

-- делаем таблицу клиентов, добавляем информацию по ним
DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	user_id bigint unsigned NOT NULL ,
	birthday date NOT NULL,
	client_status varchar(30) DEFAULT NULL, -- поле пока не используется, по идее должно показывать статус для отображения привелегированности
	adress varchar(130) DEFAULT NULL, -- по хорошему надо справочник адресов, но что-то много таблиц получается
	PRIMARY KEY (`user_id`),
	CONSTRAINT `fk_clients_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) comment = 'Клиенты';
 

INSERT INTO clients values
	(7, '1980-01-01', 'simple', 'Москва'),
	(8, '1991-01-05', 'simple', 'Novosibirsk');

SELECT * FROM clients c ;

-- производители всего, инструментов, запчастей, расходников
DROP TABLE IF EXISTS manufacturer;
CREATE table manufacturer (
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	name VARCHAR(255) COMMENT 'Название производителя',
	country varchar(130) DEFAULT NULL
);

-- добавляем производителей
INSERT INTO manufacturer (name, country) VALUES
	('Mersedes', 'gdr'),
	('Dirt', 'India'),
	('Crovok', 'China'),
	('Warta', 'Russia');

SELECT * FROM manufacturer m ;

-- соответственно модели всего инструментов, запчастей, расходников
DROP TABLE IF EXISTS model;
CREATE table model (
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	catalog_num VARCHAR(255) COMMENT 'Каталожный номер'
);


-- добавляем каталожные номера. 
INSERT INTO model (catalog_num) VALUES
	('CR_0012'),
	('FG_879-85'),
	('juT-098-988'),
	('899-445-545'),
	('weel'),
	('325315423'),
	('rte-23');

DELETE FROM model;
SELECT * FROM model m ;


-- таблица транспорта клиентов 
DROP TABLE IF EXISTS transport;
CREATE table  transport (
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	id_clients bigint unsigned NOT NULL,
    id_manufacturer bigint unsigned NOT NULL,
    id_model bigint unsigned NOT NULL,
    num VARCHAR(255) COMMENT 'номер рамы',
    CONSTRAINT fk_transport_clients FOREIGN KEY (id_clients) REFERENCES clients (user_id),
    CONSTRAINT fk_transport_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer (id),
    CONSTRAINT fk_transport_model FOREIGN KEY (id_model) REFERENCES model (id)
 );

-- в новой, чистой базе могут быть проблемы, т.к. пишем ИДы напрямую, а  у меня стоит автоинкримент
INSERT INTO transport (id_clients, id_manufacturer, id_model, num) VALUES
	(7, 1, 8, '34589-0940'),
	(7, 2, 9, '346524'),
	(7, 3, 10, '30940'),
	(8, 1, 8, '78648-0940');

SELECT * FROM transport t ;


-- таблица инструментов по идее надо учитывать расходы на его закупку и амортизацию. здесь не реализовано. 
DROP TABLE IF EXISTS instruments;
CREATE table  instruments ( 
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	name VARCHAR(255),
    id_manufacturer bigint unsigned NOT NULL,
    id_model bigint unsigned NOT NULL,
    CONSTRAINT fk_instruments_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer (id),
    CONSTRAINT fk_instruments_model FOREIGN KEY (id_model) REFERENCES model (id)
);

INSERT INTO instruments (name, id_manufacturer, id_model) VALUES
	('молоток',3 ,8 ),
	('ключ 8Х12',3 ,9 ),
	('отвёртка',4 ,10 ),
	('станок сверлильный', 4, 11 ),
	('кисть малярная', 2, 12);

-- запчасти для транспорта, могут быть и для инструмента
DROP TABLE IF EXISTS spare_part;
CREATE table  spare_part ( 
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	name VARCHAR(255),
    id_manufacturer bigint unsigned NOT NULL,
    id_model bigint unsigned NOT NULL,
    CONSTRAINT fk_spare_part_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer (id),
    CONSTRAINT fk_spare_parts_model FOREIGN KEY (id_model) REFERENCES model (id)
);

-- запчасти ссылка на модели могут быть на те же, что и рамы и т.п. не хотел придумывать новые.
-- сейчас понимаю, что это избыточно для этой работы
INSERT INTO spare_part (name, id_manufacturer, id_model) VALUES
	('колесо',1 , 14),
	('рама',1 ,13 ),
	('диск тормозной',2 ,12 ),
	('фара',2 ,11 );

-- типы работ, которые могут быт проведены. и срок их выполнения в минутах
DROP TABLE IF EXISTS works;
CREATE table  works ( 
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	name VARCHAR(255),
	time_to_end time,
	sum_of_work INT(11) UNSIGNED DEFAULT NULL
);

-- забыл про стоимость работ
ALTER TABLE works ADD sum_of_work INT(11) UNSIGNED DEFAULT NULL;

-- сами запчасти и работы 
INSERT INTO works (name, time_to_end, sum_of_work) VALUES
	('замена колеса', 15, 200),
	('ремонт шины', 30, 300),
	('регулировка тормозов', 20, 1000),
	('самазка звёздочки', 50, 500),
	('подкачка колёс', 10, 50);

SELECT * FROM works w ;

-- таблица документов в котором учитываются работы, по сути шапка документа
DROP TABLE IF EXISTS documents ;
CREATE TABLE documents (
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	doc_number VARCHAR(255),
	from_organisation_id bigint unsigned NOT NULL, -- организация оказывающая услуги, поставку и т.п.
	manager bigint unsigned NOT NULL, -- работник организации в шапке документа
	to_organisation_id bigint unsigned NOT NULL, -- организация, которой оказывают услуги
	client bigint unsigned NOT NULL, -- клиент, которому оказывают услуги, либо менеджер организации, которой оказывают услуги
	CONSTRAINT fk_documents_from_organisation FOREIGN KEY (from_organisation_id) REFERENCES organisation (id),
	CONSTRAINT fk_documents_manager FOREIGN KEY (manager) REFERENCES users (id),
	CONSTRAINT fk_documents_to_organisation FOREIGN KEY (to_organisation_id) REFERENCES organisation (id),
	CONSTRAINT fk_documents_client FOREIGN KEY (client) REFERENCES users (id)
);

SELECT o.id_users FROM organisation_to_worker o WHERE o.id_organisation = 3;

-- тестируем работу триггера по вставке ниже скрипт с ошибкой, т.к. в организации работают пользователи с ИД 1 и 2
INSERT INTO documents (doc_number, from_organisation_id, manager, to_organisation_id, client) VALUES
	('№ 1323',1 ,3 , 4, 6);

-- здесь остаётся неправильный клиент
INSERT INTO documents (doc_number, from_organisation_id, manager, to_organisation_id, client) VALUES
	('№ 1323',1 ,1 , 4, 6);


-- вставляем правильные данные по шапкам документов
INSERT INTO documents (doc_number, from_organisation_id, manager, to_organisation_id, client) VALUES
	('№ 1323',1 ,1 ,4 ,7 ), -- велоцентр ремонтирует велик клиента 7
	('№ 1324',1 ,2 ,4 ,7 ),
	('№ 1354',1 ,1 ,4 ,8 ), 
	('№ 1316',3 ,4 ,1 ,1 ); 

SELECT * FROM documents d ;

-- таблица строк работы с транспортом
DROP TABLE IF EXISTS works_to_transport ;
CREATE table  works_to_transport ( 
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	documents_id bigint unsigned NOT NULL,
	works_id bigint unsigned NOT NULL,
	transport_id bigint unsigned NOT NULL,
	spare_part_id bigint unsigned NOT NULL,
	organisation_to_worker_user_id bigint unsigned NOT NULL,
	CONSTRAINT fk_works_to_transport_documents FOREIGN KEY (documents_id) REFERENCES documents (id),
	CONSTRAINT fk_works_to_transport_works FOREIGN KEY (works_id) REFERENCES works (id),
	CONSTRAINT fk_works_to_transport_transport FOREIGN KEY (transport_id) REFERENCES transport (id),
	CONSTRAINT fk_works_to_transport_spare_part FOREIGN KEY (spare_part_id) REFERENCES spare_part (id),
	CONSTRAINT fk_works_to_transport_organisation_to_worker_user FOREIGN KEY (organisation_to_worker_user_id) REFERENCES organisation_to_worker (id_users)
);

-- добавил привязку к документу, иначе всё это не имеет смысла
ALTER TABLE works_to_transport ADD documents_id bigint unsigned NOT NULL;
ALTER TABLE works_to_transport ADD CONSTRAINT fk_works_to_transport_documents FOREIGN KEY (documents_id) REFERENCES documents (id);


-- добавим строки для двух докумнетов. ремонт двух велосипедов двумя разными сотрудниками у одного клиента
INSERT INTO works_to_transport (documents_id, works_id, transport_id, spare_part_id, organisation_to_worker_user_id) VALUES 
	(1, 6, 1, 1, 1), -- замена колеса велика 34589-0940
	(1, 7, 1, 1, 1), -- ремонт шины 34589-0940
	(1, 8, 1, 3, 1), -- регулировка тормозов 34589-0940
	(2, 6, 2, 1, 2), -- замена колеса 346524
	(2, 7, 2, 1, 2), -- ремонт шины 346524
	(2, 8, 2, 3, 2); -- регулировка тормозов 346524
	
INSERT INTO works_to_transport (documents_id, works_id, transport_id, spare_part_id, organisation_to_worker_user_id) VALUES 
	(2, 9, 2, 2, 2); -- смазка звёздочки велика 346524
	
SELECT * FROM works_to_transport wtt ;

-- сделаем вьюху всего документа, чтоб потом из него вытаскивать любые срезы по данным
CREATE or replace VIEW view_doc_and_works
AS 
SELECT
	doc.id AS id,
	doc.doc_number AS doc_num,
	(SELECT concat(u.first_name, ' ', u.last_name) FROM users u WHERE doc.manager = u.id) AS manager,
	(SELECT concat(u.first_name, ' ', u.last_name) FROM users u WHERE doc.client = u.id) AS client,
	w.name AS work_name,
	w.time_to_end AS time_work,
	w.sum_of_work AS sum_work,
	(SELECT man.name FROM manufacturer man WHERE tr.id_manufacturer = man.id) AS manuf,
	(SELECT model.catalog_num FROM model WHERE tr.id_model = model.id) AS modil_num,
	sp.name AS detail
FROM works_to_transport wtt
	JOIN documents AS doc ON wtt.documents_id = doc.id
	JOIN works AS w ON wtt.works_id = w.id
	JOIN transport AS tr ON wtt.transport_id = tr.id
	JOIN spare_part AS sp ON wtt.spare_part_id = sp.id ;

SELECT * FROM view_doc_and_works vdaw ;

-- подсчитаем сумму по документам
SELECT manager, sum(sum_work) FROM view_doc_and_works vdaw GROUP BY doc_num ;

-- подсчитаем сколько времени всего было потрачено на работы по работам
SELECT work_name, sum(time_work) FROM view_doc_and_works vdaw GROUP BY work_name ;

-- процедура выводит сколько времени было потрачено на ремонт конкретной модели по документу
CALL sp_doc_1(1);

-- создадим таблицу логирования действий с таблицами документов и строк документов
DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	id SERIAL PRIMARY KEY,
	id_in INT UNSIGNED,
	date_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
	name VARCHAR(255) COMMENT 'поле имени из таблицы',
	table_log VARCHAR(64) COMMENT 'имя таблицы'
) COMMENT = 'таблица логирования';

SELECT * FROM logs l ;



/*
 * для полноценной системы работы тут ещё много
 * нужны таблицы прихода и расхода
 * таблицы складов и всех их реквизитов
*/ 