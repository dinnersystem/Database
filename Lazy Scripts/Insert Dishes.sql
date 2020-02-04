DROP PROCEDURE IF EXISTS myproc;

delimiter $$
CREATE PROCEDURE myproc()
BEGIN
    DECLARE i int DEFAULT 0;
    WHILE i <= 99 DO
        INSERT INTO `dinnersys`.`dish` (`dish_name`,`charge`,`is_vegetarian`,`is_idle`,`department_id`,`daily_limit`,`last_update`,`sum`)
		VALUES ("Cafe", 0, 0, false, FLOOR(i / 25) + 21, -1, CURRENT_TIMESTAMP, 0);
        SET i = i + 1;
    END WHILE;
END $$

delimiter ;
CALL myproc;
DROP PROCEDURE IF EXISTS myproc;