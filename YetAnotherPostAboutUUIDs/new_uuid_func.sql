drop function if exists f_new_uuid; 
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_new_uuid`() RETURNS char(36)
    NOT DETERMINISTIC
BEGIN
    DECLARE cNewUUID char(36);
    DECLARE cMd5Val char(32);
   
    set cMd5Val = md5(concat(rand(),now(6)));
    set cNewUUID = concat(left(md5(concat(year(now()),week(now()))),4),left(cMd5Val,4),'-',
	mid(cMd5Val,5,4),'-4',mid(cMd5Val,9,3),'-',mid(cMd5Val,13,4),'-',mid(cMd5Val,17,12));

    RETURN cNewUUID;
END;;
delimiter ;

drop function if exists f_uuid2b64;
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_uuid2b64`(icUUID char(36)) RETURNS char(22)
    DETERMINISTIC
BEGIN
    return left(to_base64(unhex(replace(icUUID,'-',''))),22);
END;;
delimiter ;

drop function if exists f_b642uuid;
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_b642uuid`(icUUID char(24)) RETURNS char(36)
    DETERMINISTIC
BEGIN
    DECLARE cUUID char(36);
    set cUUID = lower(hex(from_base64(concat(icUUID,'=='))));
    return concat(left(cUUID,8),'-',mid(cUUID,9,4),'-',mid(cUUID,13,4),'-',mid(cUUID,17,4),'-',mid(cUUID,21,12));
END;;
delimiter ;

