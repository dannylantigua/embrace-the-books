/* CREATE TABLESPACES */

/* main database */
DROP TABLESPACE agencyportal INCLUDING CONTENTS;
CREATE TABLESPACE agencyportal
DATAFILE
	'c:/oracle/ora92/oradata/agencyportal/agencyportal.dbf'
SIZE 25M
REUSE AUTOEXTEND ON
NEXT 5000K
MAXSIZE 50M
ONLINE
PERMANENT;
