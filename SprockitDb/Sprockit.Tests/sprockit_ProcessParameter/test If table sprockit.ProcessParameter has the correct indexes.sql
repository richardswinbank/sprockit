/*
Description:
Test if the table has the correct indexes

Changes:
Date		Who						Notes
----------	---						--------------------------------------------------------------
04/07/2021	Richard				Initial procedure
*/
CREATE PROCEDURE [sprockit_ProcessParameter].[test If table sprockit.ProcessParameter has the correct indexes]
AS
BEGIN
    SET NOCOUNT ON;

    ----- ASSEMBLE -----------------------------------------------
    -- Create the tables
    CREATE TABLE #actual
    (
        [IndexName] sysname NOT NULL
    );

    CREATE TABLE #expected
    (
        [IndexName] sysname NOT NULL
    );

    INSERT INTO #expected
    (
        IndexName
    )
    VALUES
	('PK__sprockit_ProcessParameter');

    ----- ACT ----------------------------------------------------

    INSERT INTO #actual
    (
        IndexName
    )
    SELECT ind.name
    FROM sys.indexes ind
        INNER JOIN sys.tables t
            ON ind.object_id = t.object_id
        INNER JOIN sys.schemas AS s
            ON s.schema_id = t.schema_id
    WHERE s.name = 'sprockit'
        AND t.name = 'ProcessParameter'
        AND ind.name IS NOT NULL;

    ----- ASSERT -------------------------------------------------

    -- Assert to have the same values
    EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';

END;
GO
