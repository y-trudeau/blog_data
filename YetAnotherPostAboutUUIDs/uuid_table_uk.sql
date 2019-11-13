drop function if exists f_uuid_to_id; 
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_uuid_to_id`(pUUID char(36)) RETURNS int unsigned
    DETERMINISTIC
BEGIN
	DECLARE iID int unsigned;

	SELECT id INTO iID
    	FROM uuid_to_id WHERE uuid = pUUID;

    	IF iID IS NULL THEN
	    insert into uuid_to_id (uuid) values (pUUID);
	    set iID = last_insert_id();
 	END IF;
	
	RETURN iID;
END;;
delimiter ;
