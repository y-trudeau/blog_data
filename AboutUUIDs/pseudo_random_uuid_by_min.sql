drop function if exists f_new_uuid; 
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_new_uuid`() RETURNS char(36)
    NOT DETERMINISTIC
BEGIN
	    DECLARE cNewUUID char(36);
	    DECLARE cMd5Val char(32);
	   
	    set cMd5Val = md5(concat(rand(),now(4)));
	    set cNewUUID = concat(left(md5(minute(now())),4),left(cMd5Val,4),'-',
		        mid(cMd5Val,5,4),'-',mid(cMd5Val,9,4),'-',mid(cMd5Val,13,4),'-',mid(cMd5Val,17,12));

	    RETURN cNewUUID;
END;;
delimiter ;
