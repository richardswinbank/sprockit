/*
Description:
Test if the database has the correct collation

Changes:
Date		Who					Notes
----------	---					--------------------------------------------------------------
04/07/2021	Richard				Initial test
*/
CREATE PROCEDURE [sprockit_db].[test If database has correct collation]
AS
BEGIN
    SET NOCOUNT ON;

    ----- ASSEMBLE -----------------------------------------------

    DECLARE @expected VARCHAR(255),
        @actual VARCHAR(255)

    SELECT @expected = 'SQL_Latin1_General_CP1_CI_AS'

    ----- ACT ----------------------------------------------------

    SELECT @actual = CAST(DATABASEPROPERTYEX('Sprockit200', 'Collation') AS VARCHAR(255));

    ----- ASSERT -------------------------------------------------
    EXEC tSQLt.AssertEquals @expected, @actual;
END;
