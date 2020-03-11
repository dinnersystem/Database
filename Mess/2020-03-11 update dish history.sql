ALTER TABLE `dinnersys`.`dish_history` 
DROP COLUMN `factory_name`,
ADD COLUMN `vege` INT NOT NULL DEFAULT 0 AFTER `charge`;

ALTER TABLE `dinnersys`.`dish_history` 
CHANGE COLUMN `daily_limit` `daily_limit` INT(11) NOT NULL AFTER `vege`;