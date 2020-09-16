/*---------------------------------------------------------------------------------------------------------------*/
use dinnersys;

DROP PROCEDURE IF EXISTS delete_order;
DELIMITER $$

CREATE PROCEDURE delete_order(oid INT ,supreme BOOL)
BEGIN
	DECLARE fid INT;
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
		SET fid = (SELECT F.id FROM factory AS F, department AS DP, dish AS D, buffet AS B WHERE F.id = DP.factory AND D.department_id = DP.id AND B.dish = D.id AND B.order = oid);
		UPDATE orders AS O SET O.disabled = true WHERE O.id = oid;
        UPDATE factory AS F
        SET F.sum = F.sum - 1
        WHERE F.id = fid;
        
        UPDATE user_information AS UI
        SET UI.sum = UI.sum - 1
        WHERE UI.id = (SELECT O.user_id FROM orders AS O WHERE O.id = oid);

        UPDATE dish AS D
        SET D.sum = D.sum - (SELECT COUNT(B.dish) FROM buffet AS B WHERE B.order = oid AND B.dish = D.id)
        WHERE D.id IN (SELECT B.dish FROM buffet AS B WHERE B.order = oid);
        
        IF (SELECT F.sum FROM factory AS F WHERE F.id = fid) = 0 THEN
			UPDATE factory AS F SET F.activated = FALSE WHERE F.id = fid;
            UPDATE organization AS O SET O.external_sum = O.external_sum - 1 WHERE O.id = 
            (SELECT U.organization_id FROM users AS U, factory AS F WHERE F.id = fid AND F.boss_id = U.id);
        END IF;
        SELECT "success";
        commit;
    END IF;
END$$
delimiter ;

CALL delete_order(41007, true);
