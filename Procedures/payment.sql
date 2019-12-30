/*---------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS payment;
DELIMITER $$

/* ----------------------------------------------------------------- */
/* Please start transaction before running this procedure */

CREATE PROCEDURE payment(oid INT ,target BOOL)
BEGIN
    IF (SELECT P.paid FROM payment AS P WHERE P.money_info = 
        (SELECT O.money_id FROM orders AS O WHERE O.id = oid FOR UPDATE) 
        AND P.tag = 'payment' FOR UPDATE) = target THEN
        SELECT "Already done";
	ELSEIF (SELECT O.disabled FROM orders AS O WHERE O.id = oid FOR UPDATE) THEN
		SELECT "Already deleted";
    ELSE
        UPDATE payment AS P
        SET P.paid = target, P.paid_datetime = CURRENT_TIMESTAMP
        WHERE P.money_info = (SELECT O.money_id FROM orders AS O WHERE O.id = oid FOR UPDATE) 
        AND P.tag = 'payment';
        
        UPDATE user_information AS UI
        SET UI.sum = UI.sum + IF(target ,-1 ,1)
        WHERE UI.id = (SELECT O.user_id FROM orders AS O WHERE O.id = oid);
    END IF;
END$$
delimiter ;
CALL payment(41007, true);
