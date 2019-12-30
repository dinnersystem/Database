/*---------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS make_order;
DELIMITER $$

CREATE PROCEDURE make_order(usr_id INT ,maker_id INT ,dishes varchar(1024) ,esti_recv DATETIME)
proce: BEGIN
    DECLARE money_id INT;
    DECLARE logistics_id INT;
	DECLARE dcharge INT;
	DECLARE oid INT;
	DECLARE daily_limit INT;
	DECLARE orders INT;
	DECLARE insert_order VARCHAR(1024);
	DECLARE user_exceed BOOL;
	DECLARE factory_exceed BOOL;
	DECLARE dish_exceed BOOL;
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT "database deadlock";
        ROLLBACK;
    END;

	START TRANSACTION;
    
    SET @cmd = concat("SELECT DP.factory
		FROM department AS DP ,dish AS D
		WHERE D.id IN " ,dishes ," AND D.department_id = DP.id
        LIMIT 1 INTO @fid;");
	PREPARE stmt FROM @cmd;
    EXECUTE stmt;
    
    INSERT INTO `money_info` (`money_sum`) VALUES (-1);		/* temporary set a number */
    SET money_id = (SELECT MAX(id) FROM money_info);
    
	INSERT INTO `payment`
	(`paid`, `money_info` ,`reversable` ,
	 `able_datetime`, `freeze_datetime`, `paid_datetime` ,`tag`)
	VALUES
	(
		FALSE, money_id, FALSE,
		CONCAT(DATE(esti_recv) ,"-00:00:00"),
		FROM_UNIXTIME(UNIX_TIMESTAMP(esti_recv) - TIME_TO_SEC((SELECT F.payment_time FROM factory AS F WHERE F.id = @fid))), 
        NULL, 'payment'
    );
    
    INSERT INTO `logistics_info` (`esti_recv_datetime`)
	VALUES (esti_recv);
    
	SET logistics_id = (SELECT MAX(id) FROM logistics_info);
    
    INSERT INTO `orders`
	(`money_id`,
	`user_id`, `order_maker` ,
	`logistics_id`)
	VALUES
	(
		money_id,
		usr_id, maker_id ,
		logistics_id
    );
	SELECT MAX(O.id) FROM orders AS O INTO @oid;

	SET insert_order = REPLACE(dishes ,')' ,',@oid)');
	SET insert_order = REPLACE(insert_order ,',' ,',@oid),(');
	SET insert_order = REPLACE(insert_order ,',(@oid)' ,'');
	SET @cmd = concat('INSERT INTO `buffet` (`dish`,`order`) VALUES ',insert_order ,';');
    PREPARE stmt FROM @cmd;
    EXECUTE stmt;
    
	UPDATE money_info 
	SET money_sum = 
	(
		SELECT SUM(D.charge)
		FROM dish AS D ,buffet AS B ,orders AS O 
		WHERE O.id = @oid AND B.dish = D.id AND B.order = O.id
	)
	WHERE id = money_id;
	
	UPDATE factory AS F
	SET F.sum = IF(DATE(F.last_update) = DATE(CURRENT_TIMESTAMP), F.sum + 1 ,1), 
	F.last_update = CURRENT_TIMESTAMP
	WHERE F.id = @fid;
	
	UPDATE user_information AS UI
	SET UI.sum = IF(DATE(UI.last_update) = DATE(CURRENT_TIMESTAMP), UI.sum + 1, 1),
    UI.last_update = CURRENT_TIMESTAMP
	WHERE UI.id = (SELECT U.info_id FROM users AS U WHERE U.id = usr_id); 

	UPDATE dish AS D
	SET D.sum = IF(DATE(D.last_update) = DATE(CURRENT_TIMESTAMP), 
		D.sum + (SELECT COUNT(B.dish) FROM buffet AS B WHERE B.order = @oid AND B.dish = D.id) ,
		(SELECT COUNT(B.dish) FROM buffet AS B WHERE B.order = @oid AND B.dish = D.id)), 
	last_update = CURRENT_TIMESTAMP
	WHERE id IN (SELECT B.dish FROM buffet AS B WHERE B.order = @oid);
   
	/*-------------------------------------------------------------------------------------------------------*/
	/* Business Logic */
	SET user_exceed = (
		NOT (SELECT UI.daily_limit FROM user_information AS UI WHERE UI.id = (SELECT U.info_id FROM users AS U WHERE U.id = usr_id)) = -1 AND
		(SELECT UI.daily_limit - UI.sum FROM user_information AS UI WHERE UI.id = (SELECT U.info_id FROM users AS U WHERE U.id = usr_id)) < 0);
	SET factory_exceed = (
		NOT (SELECT F.daily_limit FROM factory AS F WHERE F.id = @fid) = -1 AND
		(SELECT F.daily_limit - F.sum FROM factory AS F WHERE F.id = @fid) < 0);
	SET dish_exceed = ((
		SELECT MIN(IF(D.daily_limit = -1 ,1 ,D.daily_limit - D.sum)) 
        FROM dish AS D 
        WHERE id IN 
			(SELECT B.dish FROM buffet AS B WHERE B.order = @oid)) 
		< 0);
	IF user_exceed OR factory_exceed OR dish_exceed THEN 
		SELECT "daily limit exceed";
		ROLLBACK;
		LEAVE proce;
	END IF;
	/*-------------------------------------------------------------------------------------------------------*/
	
	select @oid;
    commit;
END$$
delimiter ;
CALL make_order(1, 1, '(1 ,2 ,3 ,4)' ,CURRENT_TIMESTAMP);
