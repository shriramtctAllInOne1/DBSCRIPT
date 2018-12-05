SET ECHO      OFF
SET FEEDBACK  OFF
SET HEADING   OFF
SET PAGESIZE  10000
SET LINESIZE  1000

PROMPT Finding objects TO DROP

PURGE RECYCLEBIN;

SPOOL C:\ParFile\dropAllUserTables.sql

SELECT 'drop index ' || index_name ||';' FROM user_indexes where index_name not like 'SYS_IL%' and index_name not like '%PK';
SELECT 'drop view ' || view_name || ';' FROM user_views;
SELECT 'drop sequence ' || sequence_name || ';' FROM user_sequences;
SELECT 'drop table '|| table_name ||' cascade constraints;' FROM user_tables;
SELECT 'drop procedure '|| object_name ||';' FROM user_procedures;
SELECT 'drop synonym '|| synonym_name ||';' FROM user_synonyms;
SELECT 'drop '||object_type||' '|| object_name|| ';' FROM user_objects WHERE object_type = 'FUNCTION';
SELECT 'drop database link '|| db_link ||';' FROM user_db_links;

spool OFF

SET ECHO ON
SET FEEDBACK ON
SET HEADING ON

SPOOL C:\ParFile\delete_database.log

@C:\ParFile\dropAllUserTables.sql

PURGE RECYCLEBIN;

SPOOL OFF
EXIT