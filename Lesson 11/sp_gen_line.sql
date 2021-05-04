

SHOW CREATE PROCEDURE sp_gen_line;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gen_line`(IN value BIGINT UNSIGNED)
BEGIN
  DECLARE v INT DEFAULT 0;
  WHILE v < value DO
    INSERT INTO users_1 (name)
    				 VALUES (v+1),
   							(v+2),
   							(v+3),
   							(v+4),
   							(v+5),
   							(v+6),
   							(v+7),
   							(v+8),
   							(v+9),
   							(v+10);
    SET v = v + 10;
  END WHILE;
END