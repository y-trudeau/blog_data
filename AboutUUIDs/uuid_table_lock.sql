drop function if exists f_uuid_to_id; 
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_uuid_to_id`(pUUID char(36)) RETURNS int unsigned
    DETERMINISTIC
BEGIN
	DECLARE iID int unsigned;
	DECLARE iOUT int unsigned;
	   
	select get_lock('uuid_lock',10) INTO iOUT;

	SELECT id INTO iID
    	FROM uuid_to_id WHERE uuid_hash = crc32(pUUID) and uuid = pUUID;

    	IF iID IS NOT NULL THEN
	    select release_lock('uuid_lock') INTO iOUT;
	    SIGNAL SQLSTATE '23000'
	        SET MESSAGE_TEXT = 'Duplicate entry', MYSQL_ERRNO = 1062;
	ELSE
	    insert into uuid_to_id (uuid) values (pUUID);
	    select release_lock('uuid_lock') INTO iOUT;
	    set iID = last_insert_id();
 	END IF;
	
	RETURN iID;
END;;
delimiter ;
