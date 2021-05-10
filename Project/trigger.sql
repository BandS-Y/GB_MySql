/*
* создаём триггеры и процедуры для базы
*/

-- триггер проверки наличия сименно этого сотрудника в организации при создании документа

DROP TRIGGER IF EXISTS check_worker_in_from_organisation;
DROP TRIGGER IF EXISTS check_worker_in_to_organisation;
DROP TRIGGER IF EXISTS log_ins_documents;
DROP TRIGGER IF EXISTS log_ins_works_to_transport;

DROP PROCEDURE IF EXISTS sp_doc_1;

delimiter  //

-- триггер на проверку менеджера в организации
CREATE TRIGGER check_worker_in_from_organisation BEFORE INSERT ON documents
FOR EACH ROW 
BEGIN
	IF NEW.manager NOT IN (SELECT o.id_users FROM organisation_to_worker o WHERE o.id_organisation = NEW.from_organisation_id ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Manager not in Organisation';
	END IF;
END //

-- проверка клиента в организации
CREATE TRIGGER check_worker_in_to_organisation BEFORE INSERT ON documents
FOR EACH ROW 
BEGIN
	IF NEW.client NOT IN (SELECT o.id_users FROM organisation_to_worker o WHERE o.id_organisation = NEW.to_organisation_id ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client not in Organisation';
	END IF;
END //


-- логирование добавления шапки документов
CREATE TRIGGER log_ins_documents AFTER INSERT ON documents
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.id, 'documents');
END //

-- логирование добавления строк документов
CREATE TRIGGER log_ins_works_to_transport AFTER INSERT ON works_to_transport
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.id, 'works_to_transport');
END //

-- процедура подсчитывает время работ по документу
CREATE PROCEDURE sp_doc_1(IN doc_id BIGINT UNSIGNED)
BEGIN 
	SELECT manuf, modil_num sum(time_work) FROM view_doc_and_works vdaw WHERE id = doc_id;
END//

delimiter ;


