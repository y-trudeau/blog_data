drop function if exists f_uuid_to_id; 
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_uuid_to_id`(pUUID char(36)) RETURNS int unsigned
    DETERMINISTIC
BEGIN
	DECLARE iID int unsigned;
	DECLARE iOUT int unsigned;
	DECLARE tsMin timestamp;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '40001' RETURN iID;
	   
	SELECT id INTO iID
    	FROM uuid_to_id WHERE uuid_hash = crc32(pUUID) and uuid = pUUID;

    	IF iID IS NOT NULL THEN
	    SIGNAL SQLSTATE '23000'
	        SET MESSAGE_TEXT = 'Duplicate entry', MYSQL_ERRNO = 1062;
	ELSE
	    insert into dedup (uuid_hash) values (murmur_hash(pUUID));
	    insert into uuid_to_id (uuid) values (pUUID);
	    set iID = last_insert_id();
	    select min(ts) into tsMin from dedup where ts < now() - interval 5 second;
	    delete from dedup where ts = tsMin limit 2;
	    
 	END IF;
	
	RETURN iID;
END;;
delimiter ;
