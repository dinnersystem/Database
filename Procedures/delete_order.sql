/*---------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS delete_order;
DELIMITER $$

CREATE PROCEDURE delete_order(oid INT ,supreme BOOL)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT "database deadlock";
        ROLLBACK;
    END;
	START TRANSACTION;
	
    IF (SELECT O.disabled FROM orders AS O WHERE O.id = oid FOR UPDATE) THEN
		SELECT "Already deleted";
    ELSEIF NOT supreme AND ((SELECT MAX(P.paid) FROM payment AS P WHERE P.money_info = 
			(SELECT O.money_id FROM orders AS O WHERE O.id = oid FOR UPDATE)
			FOR UPDATE) = 1) THEN 
		SELECT "Has payment";
	ELSE
		UPDATE orders AS O SET O.disabled = true WHERE O.id = oid;
        UPDATE factory AS F
        SET F.sum = F.sum - 1
        WHERE F.id IN (SELECT DP.factory 
            FROM department AS DP, dish AS D, buffet AS B
            WHERE B.order = oid AND B.dish = D.id AND D.department_id = DP.id);
        
        UPDATE user_information AS UI
        SET UI.sum = UI.sum - 1
        WHERE UI.id = (SELECT O.user_id FROM orders AS O WHERE O.id = oid);

        UPDATE dish AS D
        SET D.sum = D.sum - (SELECT COUNT(B.dish) FROM buffet AS B WHERE B.order = oid AND B.dish = D.id)
        WHERE D.id IN (SELECT B.dish FROM buffet AS B WHERE B.order = oid);
        SELECT "success";
        commit;
    END IF;
END$$
delimiter ;

CALL delete_order(41007, true);
