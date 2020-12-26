CREATE OR REPLACE PROCEDURE GetNextKeyValue(
  p_keyName IN varchar,
  p_keyValue OUT number) IS
BEGIN
  UPDATE
    NextKeyValue
  SET
    KeyValue = KeyValue + 1
  WHERE
    KeyName = p_keyName;
  SELECT
    KeyValue
  INTO
    p_keyValue
  FROM
    NextKeyValue
  WHERE
    KeyName = p_keyName;
END GetNextKeyValue;
