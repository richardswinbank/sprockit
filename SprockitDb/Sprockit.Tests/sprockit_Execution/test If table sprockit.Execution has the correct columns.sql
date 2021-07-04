/*
Description:
Test if the table has the correct columns

Changes:
Date		Who						Notes
----------	---						--------------------------------------------------------------
04/07/2021	Richard				Initial procedure
*/
CREATE PROCEDURE [sprockit_Execution].[test If table sprockit.Execution has the correct columns]
AS
BEGIN
    SET NOCOUNT ON;

    ----- ASSEMBLE -----------------------------------------------
    -- Create the tables
    CREATE TABLE #actual
    (
        [ColumnName] sysname NOT NULL,
        [DataType] sysname NOT NULL,
        [MaxLength] SMALLINT NOT NULL,
        [Precision] TINYINT NOT NULL,
        [Scale] TINYINT NOT NULL
    );

    CREATE TABLE #expected
    (
        [ColumnName] sysname NOT NULL,
        [DataType] sysname NOT NULL,
        [MaxLength] SMALLINT NOT NULL,
        [Precision] TINYINT NOT NULL,
        [Scale] TINYINT NOT NULL
    );

    INSERT INTO #expected
    (
        ColumnName,
        DataType,
        MaxLength,
        Precision,
        Scale
    )
    VALUES
	('AvgDuration', 'int', 4, 10, 0),
	('BatchId', 'int', 4, 10, 0),
	('BranchWeight', 'int', 4, 10, 0),
	('EndDateTime', 'datetime', 8, 23, 3),
	('EndStatus', 'nvarchar', 40, 0, 0),
	('ExecutionId', 'int', 4, 10, 0),
	('ExecutionParameters', 'xml', -1, 0, 0),
	('ExecutionProperties', 'xml', -1, 0, 0),
	('ExternalHandlerId', 'nvarchar', 510, 0, 0),
	('InitialWatermark', 'nvarchar', 510, 0, 0),
	('IsEnabled', 'bit', 1, 1, 0),
	('Priority', 'tinyint', 1, 3, 0),
	('ProcessId', 'int', 4, 10, 0),
	('ProcessType', 'nvarchar', 20, 0, 0),
	('StartDateTime', 'datetime', 8, 23, 3),
	('UpdatedWatermark', 'nvarchar', 510, 0, 0);

    ----- ACT ----------------------------------------------------

    INSERT INTO #actual
    (
        ColumnName,
        DataType,
        MaxLength,
        Precision,
        Scale
    )
    SELECT c.name AS ColumnName,
           st.name AS DataType,
           c.max_length AS MaxLength,
           c.precision AS [Precision],
           c.scale AS Scale
    FROM sys.columns AS c
        INNER JOIN sys.tables AS t
            ON t.object_id = c.object_id
        INNER JOIN sys.schemas AS s
            ON s.schema_id = t.schema_id
        LEFT JOIN sys.types AS st
            ON st.user_type_id = c.user_type_id
    WHERE t.type = 'U'
          AND s.name = 'sprockit'
          AND t.name = 'Execution'
    ORDER BY t.name,
             c.name;

    ----- ASSERT -------------------------------------------------

    -- Assert to have the same values
    EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';

END;
GO
