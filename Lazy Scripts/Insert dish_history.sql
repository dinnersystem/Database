DROP PROCEDURE IF EXISTS myproc;

delimiter $$
CREATE PROCEDURE myproc()
BEGIN
    DECLARE i int DEFAULT 0;
    WHILE i <= 99 DO
        INSERT INTO `dinnersys`.`dish_history`
		(`dish_id`,
		`factory_name`,
		`dish_name`,
		`charge`,
		`born_at`,
		`daily_limit`)
		VALUES
		(i + 500,
		"Cafe",
		"Cafe",
		0,
		CURRENT_TIMESTAMP,
		-1);
        SET i = i + 1;
    END WHILE;
END $$

delimiter ;
CALL myproc;
DROP PROCEDURE IF EXISTS myproc;