DROP PROCEDURE IF EXISTS myproc;

delimiter $$
CREATE PROCEDURE myproc()
BEGIN
    DECLARE i int DEFAULT 1;
    
    /* INSERT INTO `dinnersys`.`department`(`id`,`name`,`factory`,`father_department`) VALUES (25 ,"單點" ,7 ,25);
    INSERT INTO `dinnersys`.`department`(`id`,`name`,`factory`,`father_department`) VALUES (26 ,"閒置" ,7 ,26);
    INSERT INTO `dinnersys`.`department`(`id`,`name`,`factory`,`father_department`) VALUES (27 ,"單點" ,7 ,27);
    INSERT INTO `dinnersys`.`department`(`id`,`name`,`factory`,`father_department`) VALUES (28 ,"單點" ,7 ,28);
    
	WHILE i <= 99 DO
        INSERT INTO `dinnersys`.`dish` (`dish_name`,`charge`,`is_vegetarian`,`is_idle`,`department_id`,`daily_limit`,`last_update`,`sum`)
		VALUES ("Cafe", 0, 0, false, FLOOR(i / 25) + 25, -1, CURRENT_TIMESTAMP, 0);
        SET i = i + 1;
    END WHILE; */
    
    WHILE i <= 100 DO
        INSERT INTO `dinnersys`.`dish_history` (`dish_id`, `factory_name`, `dish_name`, `charge`, `born_at`, `daily_limit`)
		VALUES (i + 600, "關東煮 - 單點", "idling", 0, CURRENT_TIMESTAMP, -1);
        SET i = i + 1;
    END WHILE;
END $$

delimiter ;
CALL myproc;
DROP PROCEDURE IF EXISTS myproc;