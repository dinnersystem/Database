#### update dish ####
DROP PROCEDURE IF EXISTS update_dish;

DELIMITER $$
CREATE PROCEDURE update_dish(id INT ,dname VARCHAR(1024) ,charge INT ,vege INT ,idle BOOL ,daily_limit INT)
BEGIN
	UPDATE `dish_history` as dh
	SET dh.`die_at` = CURRENT_TIMESTAMP
	WHERE (dh.die_at > '9999-12-31 00:00:00' or dh.die_at is null)
    and dh.dish_id = id;
    
	INSERT INTO `dish_history`
	(`dish_id`,
	`factory_name`,
	`dish_name`,
	`charge`,
	`daily_limit`,
	`die_at`)
	VALUES
	(id,
	(
		SELECT CONCAT(F.name ,"-" ,DP.name) 
        FROM factory AS F ,dish AS D ,department AS DP
        WHERE D.id = id AND D.department_id = DP.id AND DP.factory = F.id
	),
	dname,
	charge,
	daily_limit,
	'9999-12-31 23:59:59');

	UPDATE `dish`
	SET `dish_name` = dname,
	`charge` = charge,
	`is_vegetarian` = vege,
	`is_idle` = idle,
	`daily_limit` = daily_limit
	WHERE `dish`.`id` = id;
END$$
DELIMITER ;

CALL update_dish(1 ,'qwer' ,87 ,1 ,FALSE ,5487);