DELIMITER $$
CREATE FUNCTION hasTag(cTag varchar(10), cTags text)
RETURNS integer
DETERMINISTIC
BEGIN
	Declare iTagPos int;
	select find_in_set(cTag,cTags) into iTagPos;
	IF iTagPos > 0 THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION addTags(cNewTags text,cCurTags text)
RETURNS text
DETERMINISTIC
BEGIN
    Declare iLen int;
    Declare iPos int;
    Declare cTag varchar(10);

    set iLen = length(cNewTags);
    while iLen > 0 DO
      set iPos = locate(',',cNewTags);
      if iPos = 0 THEN
        set cCurTags = addTag(cNewTags, cCurTags);
        set iLen = 0;
      else
        set cTag = left(cNewTags,iPos-1);
        set cCurTags = addTag(cTag, cCurTags);
        set cNewTags = right(cNewTags,iLen-iPos);
        set iLen = length(cNewTags);
      end if;
    end while;
    return cCurTags;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION addTag(cTag varchar(10),cTags text)
RETURNS text
DETERMINISTIC
BEGIN
    Declare iTagExists tinyint;

    select count(*) into iTagExists from dictTags where tag = cTag;
    if iTagExists > 0 then
      if hasTag(cTag,cTags) < 1 then
        if length(cTags) > 0 then
          set cTags = concat(cTags,',',cTag);
        else
          set cTags = concat(cTags,cTag);
        end if;
      end if;
    end if;
    return cTags;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION removeTag(cTag varchar(10),cTags text)
RETURNS text
DETERMINISTIC
BEGIN
    Declare iTagExists tinyint;
    Declare iPos int;
    Declare iCnt int;

    if hasTag(cTag,cTags) > 0 then
      -- insert into debug (msg) values ('hasTag true');
      set cTags = concat(cTags,',__last');
      -- insert into debug (msg) values (concat('cTags with terminator: ',cTags));
      set iCnt = FIND_IN_SET('__last',cTags);
      -- insert into debug (msg) values (concat('iCnt: ', iCnt));
      set iPos = FIND_IN_SET(cTag,cTags);
      -- insert into debug (msg) values (concat('iPos: ', iPos));
      set cTags = substring_index(trim(both ',' from concat_ws(',',SUBSTRING_INDEX(cTags,',',iPos-1),SUBSTRING_INDEX(cTags,',',(-iCnt+iPos)))),',',iCnt-2);
    end if;
    return cTags;
END$$
DELIMITER ;

