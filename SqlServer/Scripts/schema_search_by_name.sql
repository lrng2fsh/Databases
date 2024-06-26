declare @whato_look_for varchar(max) = 'icd'

SELECT 
	'TABLES',
    DB_NAME() AS DatabaseName,
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS TableName,
	concat('select top 10 ',  '''' + TABLE_NAME + ''' as ''TABLE'', * from ', DB_NAME(), '.', TABLE_SCHEMA, '.', TABLE_NAME, ' with (nolock)') as 'SELECT'
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_TYPE = 'BASE TABLE' -- This ensures you are searching for regular tables (not views or other types)
    AND charindex(@whato_look_for, TABLE_NAME) > 0 ;

---
select 'COLUMNS', DB_NAME() AS DatabaseName, s.name as 'Schema',
c.name as 'ColumnName', t.name as 'TableName',
concat('select top 10 ', '''' + t.name + ''', ', c.name, ', * from ', DB_NAME(), '.', s.name, '.', t.name, ' with (nolock)') as 'SELECT'
from sys.columns c
join sys.tables t on c.object_id = t.object_id
join sys.schemas s on t.schema_id = s.schema_id
where 1=1
and charindex(@whato_look_for, c.name) > 0 
order by TableName, ColumnName;

-- 
-- STORED PROCEDURES
Select 'STORED PROCEDURES', DB_NAME() AS DatabaseName, object_name(object_id) name, object_id, definition
From sys.sql_modules m
Where charindex(@whato_look_for, m.definition) > 0
 
-- FUNCTIONS 
Select 'FUNCTIONS', DB_NAME() AS DatabaseName, object_name(object_id) name, object_id, definition
From sys.sql_modules m
Where charindex(@whato_look_for, m.definition) > 0
AND OBJECTPROPERTY(object_id, 'IsScalarFunction') = 1
